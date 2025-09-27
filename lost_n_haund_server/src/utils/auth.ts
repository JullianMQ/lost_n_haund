import { betterAuth } from "better-auth"
import { mongodbAdapter } from "better-auth/adapters/mongodb"
import db from "./../db.js"
import { Resend } from "resend"
import path from "path"
import fs from "fs"
import { admin, bearer, openAPI } from "better-auth/plugins"

process.loadEnvFile()
const resend = new Resend(process.env.TEST_API_TOKEN)

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
      partitioned: true // New browser standards will mandate this for foreign cookies
    }
  },
  autoSignIn: false,
  user: {
    modelName: "authUser",
    deleteUser: {
      enabled: true
    },
    // additionalFields: { 
    //
    // }
  },
  emailVerification: {
    sendOnSignUp: true,
    sendVerificationEmail: async ({ user, url }) => {
      const template = path.join(process.cwd(), "src/assets/html/email.html")
      // turned into string so we can replace the template with javascript
      let html = fs.readFileSync(template, "utf-8")
      html = html
        .replace("{{user_name}}", user.name)
        .replace("{{user_email}}", user.email)
        .replaceAll("{{verify_url}}", url)

      await resend.emails.send({
        from: 'Lost N Haund <send@jullianq.tech>',
        to: user.email,
        subject: "Verify your email address",
        html: html
      })
    },
  },
  plugins: [
    openAPI(),
    bearer(),
    admin(),
  ]
})

export { auth, resend }
