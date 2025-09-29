import { betterAuth } from "better-auth";
import { mongodbAdapter } from "better-auth/adapters/mongodb";
import db from "./../db.js";
import { Resend } from "resend";
import path from "path";
import fs from "fs";
import { admin, openAPI } from "better-auth/plugins";

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
      },
      user_role: {
        type: "string",
        required: true,
        defaultValue: "Student",
        input: false,
      },
    },
  },
  // TODO: CREATE HOOK FOR UPDATING AND DELETING USER
  databaseHooks: {
    user: {
      create: {
        after: async (user) => {
          resend.contacts.create({
            audienceId: "1c5c7e1e-0835-47ce-b903-9ad11db9e206",
            email: user.email,
            unsubscribed: false,
            firstName: user.name.split(" ")[0],
            lastName: user.name.split(" ")[1],
          });
        },
      },
      update: {
        before: async (user, ctx) => {
          console.log("user", user);

          // resend.contacts.update({
          //   email: user.email,
          //   audienceId: audienceId,
          //   firstName: user.name?.split(" ")[0],
          //   lastName: user.name?.split(" ")[1],
          // });
        },
        after: async (user, context) => {
          console.log("user.name", user.name);
        },
      },
      // delete: {
      //   before: async (user) => {
      //     resend.contacts.remove({
      //       email: user.email,
      //       audienceId: audienceId,
      //     });
      //   },
      // },
    },
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
  plugins: [openAPI(), admin()],
});

export { auth, resend };
