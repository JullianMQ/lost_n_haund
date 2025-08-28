import type { Context } from "hono"
import db from "../db.js"
import { NewError, NewSuccess, type HandlerResult } from "../utils/success.js"
import { zodClaimSchema } from "../utils/claimsTypes.js"
import { regexOrAll } from "../utils/regexUtil.js"


class ClaimsHandler {
  private claimsDB = db.collection('claims')

  async getClaimPosts(c: Context) {
    const first_name = c.req.query('first_name') || ''
    const last_name = c.req.query('last_name') || ''
    const user_email = c.req.query('user_email') || ''
    const phone_num = c.req.query('phone_num') || ''
    const user_id = c.req.query('user_id') || ''
    const reference_id = c.req.query('reference_id') || ''
    const page = c.req.query('page') === undefined ? 0 : parseInt(c.req.query('page')!)

    try {
      const query = {
        $and: [
          { first_name: regexOrAll(first_name) },
          { last_name: regexOrAll(last_name) },
          { user_email: regexOrAll(user_email) },
          { phone_num: regexOrAll(phone_num) },
          { user_id: regexOrAll(user_id) },
          { reference_id: regexOrAll(reference_id) },
        ]
      }

      const claims = await this.claimsDB.find(query).skip(page).limit(20).toArray()
      return claims

    } catch (e) {
      return {
        status: 500,
        error: NewError('Internal server error')
      }
    }
  }

  async createClaimItemPost(c: Context): Promise<HandlerResult> {
    const formData = await c.req.formData()

    try {
      const rawData = {
        first_name: formData.get("first_name") as string,
        last_name: formData.get("last_name") as string,
        user_email: formData.get("user_email") as string,
        phone_num: formData.get("phone_num") as string,
        user_id: formData.get("user_id") as string,
        reference_id: formData.get("reference_id") as string,
        justification: formData.get("justification") as string,
      }

      const res = zodClaimSchema.safeParse(rawData, {
        error: (iss) => {
          if (iss.code === "too_small") {
            return "justification too short, should be at least 50 characters"
          } else if (iss.code === "too_big") {
            return "justification too long, should be 400 max characters"
          }
        }
      })

      if (!res.success) {
        console.error(`Error ${res.error.issues.map(issue => issue.message).join(", ")}`)
        return {
          status: 400,
          error: NewError(`Error parsing data: ${res.error.issues.map(issue => issue.message).join(", ")}`)
        }
      }

      const claimResult = await this.claimsDB.insertOne(res.data)
      if (!claimResult.acknowledged) {
        return {
          status: 503,
          error: NewError('Mongo error')
        }
      }

      return {
        status: 200,
        success: NewSuccess('Successfully created a claim item post')
      }
    } catch (e) {
      return {
        status: 500,
        error: NewError(`Error creating claim item post ${e}`)
      }
    }
  }
}

export default ClaimsHandler
