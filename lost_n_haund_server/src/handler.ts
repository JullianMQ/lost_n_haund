import client from './db.js'
import type { Context, Next } from 'hono'
import type { Success } from './utils/success.js'
import { NewSuccess } from './utils/success.js'
import { existsSync, mkdirSync, createReadStream } from 'fs'
import { writeFile, unlink } from 'fs/promises'
import { google } from 'googleapis'
import path from 'path'
import { fileURLToPath } from 'url'

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

  async postItem(c: Context) {
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
        // TODO: REFACTOR THIS 
        $and: [
          { item_name: item_name !== '' ? new RegExp(`${item_name}`, 'i') : new RegExp(`.*`, 'i') },
          { description: description !== '' ? new RegExp(`${description}`, 'i') : new RegExp(`.*`, 'i') },
          { location_found: location_found !== '' ? new RegExp(`${location_found}`, 'i') : new RegExp(`.*`, 'i') },
          { status: status !== '' ? new RegExp(`${status}`, 'i') : new RegExp(`.*`, 'i') },
          { reference_id: reference_id !== '' ? reference_id : new RegExp(`.*`, 'i') },
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

    // TODO: Add information about
    // Item name
    // Item Category
    // Image
    // Description (how much money was in the wallet when they found it?)
    // Location
    // Status
    // Reference ID       
  }

  async upload(c: Context, f: File): Promise<[Success, Error]> {
    let [success, error] = [NewSuccess(""), Error("")]
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
      error = e as Error
      console.error('Upload error:', e)
      return [success, error]
    }
  }
}


export default Handler
