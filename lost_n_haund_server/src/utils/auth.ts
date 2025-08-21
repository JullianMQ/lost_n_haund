import { betterAuth } from "better-auth"
import { mongodbAdapter } from "better-auth/adapters/mongodb"
import db from "./../db.js"

export const auth = betterAuth({
  baseURL: process.env.BETTER_AUTH_URL,
  basePath: "/users/auth",
  database: mongodbAdapter(db),
  emailAndPassword: {
    enabled: true,
    requireEmailVerification: false,
  },
  autoSignIn: false,
  user: {
    modelName: "authUser",
  }
})

// const response = await auth.api.signInEmail({
//   body: {
//     email,
//     password
//   },
//   asResponse: true
// })
