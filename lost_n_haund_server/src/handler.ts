import client from './db.js'
import type { Context } from 'hono'
import type { Success, CustomError, HandlerResult } from './utils/success.js'
import { regexOrAll } from './utils/regexUtil.js'
import { NewSuccess, NewError } from './utils/success.js'
import { existsSync, mkdirSync, createReadStream } from 'fs'
import { writeFile, unlink } from 'fs/promises'
import { google } from 'googleapis'
import path from 'path'
import { fileURLToPath } from 'url'
import { z } from 'zod'
import { zValidator } from '@hono/zod-validator'
import { nullPostsSchema, type postsSchema } from './utils/postsTypes.js'
import { localToUTC, phTime } from './utils/dateTimeConversion.js'
import type { stringFormat } from 'zod/mini'

// TODO: Maybe there's a way to upload the file directly? than saving it first in the server
// Although we could do more operations(checking, minify, conversion etc.)
// this way in the future, incase we need to minimize the file size works as needed right now
const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)
const CLIENT_ID = process.env.CLIENT_ID
const CLIENT_SECRET = process.env.CLIENT_SECRET
const REDIRECT_URI = process.env.REDIRECT_URI
const REFRESH_TOKEN = process.env.REFRESH_TOKEN

const oauth2Client = new google.auth.OAuth2(
  CLIENT_ID,
  CLIENT_SECRET,
  REDIRECT_URI
)

oauth2Client.setCredentials({ refresh_token: REFRESH_TOKEN })
const drive = google.drive({ version: 'v3', auth: oauth2Client })
const db = client.db('lost_n_haund')

class Handler {
  async getUsers(c: Context) {
    // TODO: Add ways to search by stud_id, email etc.
    const user_name = c.req.query('name') || ''
    // const user_num = c.req.query('user_num') || ''
    const page = c.req.query('page') === undefined ? 0 : parseInt(c.req.query('page')!)
    const usersDB = db.collection('users')

    try {
      // Used skip and limit pagination for now, as I don't think there's that much data
      // const query = { name: {$regex: /john .*/i} }
      const query = {
        user_name: new RegExp(`^${user_name}`, 'i')
      }
      const users = await usersDB.find(query).skip(page).limit(20).toArray()

      return users
    } catch (e) {
      console.error("Error", e)
    }
  }

  // TODO: pass an object to get both keys and value
  // as a way to filter
  // queryFunc(object) {
  //   [...args].forEach(element => {
  //     if (element === "" || element.length === 0) {
  //
  //     }
  //   });
  // }

  async getPosts(c: Context) {
    const item_name = c.req.query('name') || ''
    const description = c.req.query('description') || ''
    const location_found = c.req.query('location') || ''
    const status = c.req.query('status') || ''
    const reference_id = c.req.query('reference_id') || ''
    const item_category = c.req.queries('categories') || []
    const page = c.req.query('page') === undefined ? 0 : parseInt(c.req.query('page')!)
    const postsDB = db.collection('posts')

    try {
      const query = {
        $and: [
          { item_name: regexOrAll(item_name) },
          { description: regexOrAll(description) },
          { location_found: regexOrAll(location_found) },
          { status: regexOrAll(status) },
          { reference_id: regexOrAll(reference_id) },
          {
            item_category: item_category.length !== 0
              ? { $all: item_category }
              : { $not: / / }
          },
        ]
      }
      const posts = await postsDB.find(query).skip(page).limit(20).toArray()
      return posts

    } catch (e) {
      console.error("Error", e);
    }
  }

  postsSchema = z.object({
    item_name: z.string(),
    item_category: z.array(z.string()),
    description: z.string(),
    date_found: z.coerce.date(),
    location_found: z.string(),
    status: z.enum(["held", "archived", "pending", "returned"]).default("pending"),
    reference_id: z.string(),
  })

  async postPosts(c: Context): Promise<HandlerResult> {
    const formData = await c.req.formData()
    const postsDB = db.collection('posts')

    try {
      const rawData = {
        item_name: formData.get("item_name") as string,
        item_category: (formData.getAll("item_category") as string[]) ?? [],
        description: formData.get("description") as string,
        date_found: localToUTC(formData.get("date_found") as string, phTime),
        location_found: formData.get("location_found") as string,
        status: (formData.get("status") as string) || "pending",
        reference_id: formData.get("reference_id") as string,
      }

      const res = this.postsSchema.safeParse(rawData)
      if (!res.success) {
        console.error(res.error);
        return {
          error: NewError('Error parsing data'),
          status: 400
        }
      }

      const postResult = await postsDB.insertOne(res.data)
      console.log("postResult", postResult)
      if (!postResult.acknowledged) {
        return {
          error: NewError('Mongo error'),
          status: 503
        }
      }

      return {
        success: NewSuccess('Item successfully posted'),
        status: 201
      }
    }

    catch (e) {
      console.error('Internal server error:', e);
      return {
        error: NewError('Internal server error'),
        status: 500
      }
    }
  }

  async updatePost(c: Context): Promise<HandlerResult> {
    const postsDB = db.collection('posts')
    const id = c.req.param('id')

    try {
      const formData = await c.req.formData()
      const updatedData: Record<string, unknown> = {}
      const formEntries = formData.entries()

      for (const [key, value] of formEntries) {
        if (value === null) continue
        if (typeof value === "string" && value.trim() === "") continue

        if (key === "item_category") {
          const categories = formData.getAll("item_category") as string[]
          if (categories.length > 0) updatedData[key] = categories
        } else if (key === "date_found") {
          updatedData[key] = localToUTC(value as string, phTime)
        } else {
          updatedData[key] = value
        }
      }

      const res = this.postsSchema.partial().safeParse(updatedData)
      if (!res.success) {
        return {
          status: 400,
          error: NewError('Invalid data')
        }
      }

      const updateResult = await postsDB.updateOne(
        { reference_id: id },
        { $set: updatedData }
      )

      if (updateResult.matchedCount === 0) {
        return {
          status: 400,
          error: NewError('Post not found')
        }
      }

      return {
        success: NewSuccess('Post update successfully'),
        status: 200
      }
    }

    catch (e) {
      console.error('Error updating post:', e);
      return {
        status: 500,
        error: NewError('Internal server error')
      }
    }
  }

  async upload(f: File): Promise<[Success, CustomError]> {
    let [success, error] = [NewSuccess(""), NewError("")]
    const dirPath = path.join(__dirname, 'assets', 'images')
    if (!existsSync(dirPath)) {
      mkdirSync(dirPath, { recursive: true })
    }

    const filePath = path.join(dirPath, f.name)
    const buffer = await f.arrayBuffer()

    try {
      await writeFile(filePath, Buffer.from(buffer))

      const res = await drive.files.create({
        requestBody: {
          name: f.name,
          mimeType: f.type,
        },
        media: {
          mimeType: f.type,
          body: createReadStream(filePath)
        }
      })

      const fileId = res.data.id

      drive.permissions.create({
        fileId: fileId!,
        requestBody: {
          role: 'reader',
          type: 'anyone'
        }
      })
      // server doesn't keep unnecessary files
      await unlink(filePath)

      success = {
        message: 'File uploaded to Google Drive successfully',
        urlImage: `https://lh3.googleusercontent.com/d/${res.data.id}`
      }

      return [success, error]

    } catch (e) {
      if (e instanceof Error) {
        console.error('Service unavailable: ', e)
        const err = NewError(e)
        return [success, err]
      }

      // basically useless, but needed in case we throw errors that are not Error objects
      const err = NewError(String(e))
      return [success, err]
    }
  }
}


export default Handler
