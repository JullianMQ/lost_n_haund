import { APIError, betterAuth } from "better-auth";
import { mongodbAdapter } from "better-auth/adapters/mongodb";
import db from "./../db.js";
import { Resend } from "resend";
import path from "path";
import fs from "fs";
import {
  admin as adminPlugin,
  createAuthMiddleware,
  openAPI,
} from "better-auth/plugins";
import { ac, admin, moderator, student } from "./permissions.js";

process.loadEnvFile();
const resend = new Resend(process.env.TEST_API_TOKEN);

const audienceId = "1c5c7e1e-0835-47ce-b903-9ad11db9e206";
const auth = betterAuth({
  basePath: "/users/auth",
  database: mongodbAdapter(db),
  emailAndPassword: {
    enabled: true,
    requireEmailVerification: true,
  },
  advanced: {
    defaultCookieAttributes: {
      sameSite: "none",
      secure: true,
      partitioned: true, // New browser standards will mandate this for foreign cookies
    },
  },
  autoSignIn: false,
  user: {
    modelName: "authUser",
    updateUser: {
      enabled: true,
    },
    deleteUser: {
      enabled: true,
    },
    additionalFields: {
      phone_num: {
        type: "string",
        required: false,
      },
      user_id: {
        type: "string",
        required: true,
        input: true,
        unique: true,
      },
    },
  },
  hooks: {
    before: createAuthMiddleware(async (ctx) => {
      if (ctx.path.startsWith("/sign-up/email")) {
        const user_id = ctx.body.user_id;
        const not_unique = await db
          .collection("authUser")
          .findOne({ user_id: user_id });

        if (not_unique) {
          throw new APIError("CONFLICT", {
            message: "User with id already exists",
          });
        }

        await resend.contacts.create({
          audienceId: audienceId,
          email: ctx.body.email,
          unsubscribed: false,
          firstName: ctx.body.name.split(" ")[0],
          lastName: ctx.body.name.split(" ")[1],
        });
      }

      if (ctx.path.match("/delete-user") || ctx.path.match("/remove-user")) {
        const email = ctx.body.email;
        if (!email) {
          throw new APIError("BAD_REQUEST", {
            message: "No email provided",
          });
        }

        try {
          const res = await resend.contacts.remove({
            email: email,
            audienceId: audienceId,
          });

          if (res.error !== null) {
            throw new APIError("SERVICE_UNAVAILABLE", {
              message: "Resend Service unavailable",
            });
          }
        } catch (e) {
          console.error(e);
          throw new APIError("SERVICE_UNAVAILABLE", {
            message: "Resend Service unavailable",
          });
        }
      }
    }),

    after: createAuthMiddleware(async (ctx) => {
      if (ctx.path.match("/update-user")) {
        const email = ctx.context.session?.user.email ?? ctx.body.email;
        const name = ctx.body.name;
        const role: string = ctx.body.data.role;
        const roles = ["admin", "student", "moderator"];

        if (!roles.includes(role)) {
          throw new APIError("BAD_REQUEST", {
            message: "Role can only be admin, student, or moderator",
          });
        }

        if (!email) {
          throw new APIError("NOT_FOUND", {
            message: "User not found",
          });
        }

        if (name) {
          try {
            await resend.contacts.update({
              email: email,
              audienceId: audienceId,
              firstName: ctx.body.name.split(" ")[0],
              lastName: ctx.body.name.split(" ")[1],
            });
          } catch (e) {
            console.error(e);
            throw new APIError("SERVICE_UNAVAILABLE", {
              message: "Resend Service unavailable",
            });
          }
        }
      }
    }),
  },
  emailVerification: {
    sendOnSignUp: true,
    sendVerificationEmail: async ({ user, token }, request) => {
      const origin = request
        ? new URL(request.url).origin
        : process.env.BETTER_AUTH_URL || "http://localhost:3030";
      const verifyUrl = `${origin}/users/auth/verify-email?token=${encodeURIComponent(token)}&callbackURL=/users/auth/verified`;

      const template = path.join(process.cwd(), "src/assets/html/email.html");
      // turned into string so we can replace the template with javascript
      let html = fs.readFileSync(template, "utf-8");
      html = html
        .replace("{{user_name}}", user.name)
        .replace("{{user_email}}", user.email)
        .replaceAll("{{verify_url}}", verifyUrl);

      await resend.emails.send({
        from: "Lost N Haund <send@jullianq.tech>",
        to: user.email,
        subject: "Verify your email address",
        html: html,
      });
    },
  },
  plugins: [
    openAPI(),
    adminPlugin({
      ac,
      roles: {
        student,
        moderator,
        admin,
      },
      defaultRole: "student",
      defaultBanReason: "Inappropriate posting",
    }),
  ],
});

export { auth, resend };
