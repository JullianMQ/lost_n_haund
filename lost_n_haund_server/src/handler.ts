import client from './db.js'
import type { Context, Next } from 'hono'
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

class Handler {
  async runQuery(c: Context) {
    const title = c.req.query('title') || ''
    let page = c.req.query('page') || '0'
    const intPage = isNaN(parseInt(page)) ? 0 : parseInt(page)

    try {
      const db = client.db('sample_mflix')
      const movies = db.collection('movies')

      // Used skip and limit pagination for now, as I don't think there's that much data
      // const query = { title: {$regex: /The Great .*/i} }
      const query = { title: new RegExp(`^${title}`, 'i') }
      const movie = movies.find(query).skip(intPage).limit(20).toArray()

      return movie
    } catch (e) {
      console.error("Error", e)
    }
  }

  async postItem(c: Context) {
    // TODO: Add information about
    // Item name
    // Item Category
    // Description (how much money was in the wallet when they found it?)
    // Location
    // Status
    // Reference ID       
  }

  async upload(c: Context, f: File) {
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

      return c.json({
        message: 'File uploaded to Google Drive successfully',
        urlImage: `https://lh3.googleusercontent.com/d/${res.data.id}`
      })
    } catch (err) {
      console.error('Upload error:', err)
      return c.json({ message: 'Error uploading file' }, 500)
    }
  }
}


export default Handler
