import type { Context } from "hono";
import type { HandlerResult } from './../utils/success.js'
import { NewSuccess, NewError } from './../utils/success.js'
import { resend, auth } from "../utils/auth.js";
import { APIError } from "better-auth/api";
import type { StatusCode } from "hono/utils/http-status";

export default class UserAuth {
  async signUp(c: Context): Promise<HandlerResult> {
    const formData = await c.req.formData()
    const name = String(formData.get('user_name')!)
    const email = String(formData.get('user_email')!)
    const pass = String(formData.get('user_pass')!)
    const [firstName, lastName = ''] = name.split(' ')

    try {
      const res = await auth.api.signUpEmail({
        body: {
          name: name,
          email: email,
          password: pass,
        }
      })

      const audienceId = '1c5c7e1e-0835-47ce-b903-9ad11db9e206'
      await resend.contacts.create({
        email,
        firstName,
        lastName,
        unsubscribed: false,
        audienceId,
      });

      // const token = res.token
      // const callbackURL = c.req.query('callback') ?? "http://localhost:3030"

      // await auth.api.sendVerificationEmail({
      //   body: {
      //     email,
      //     callbackURL
      //   }
      // })

      return {
        success: NewSuccess('Successfully created account'),
        status: 201
      }

    } catch (e) {
      if (e instanceof APIError) {
        console.error(e.message)
        console.error(e.status)
        console.error(e.statusCode)
        return {
          error: NewError(e.message),
          status: e.statusCode as StatusCode
        }
      }

      return {
        error: NewError(`Unknown error ${e}`),
        status: 500
      }
    }
  }

  async signIn(c: Context): Promise<HandlerResult> {
    const formData = await c.req.formData()
    const user_email = String(formData.get('user_email')!)
    const user_pass = String(formData.get('user_pass')!)
    try {
      const data = await auth.api.signInEmail({
        body: {
          email: user_email,
          password: user_pass,
          callbackURL: "http:localhost:3030/users"
        }
      })

      return {
        success: NewSuccess(`${data.token}`),
        status: 200
      }
    } catch (e) {
      if (e instanceof APIError) {
        console.error(e.message)
        console.error(e.status)
        console.error(e.statusCode)
        return {
          error: NewError(e.message),
          status: e.statusCode as StatusCode
        }
      }

      return {
        error: NewError(`Unknown error ${e}`),
        status: 500
      }
    }
  }
}