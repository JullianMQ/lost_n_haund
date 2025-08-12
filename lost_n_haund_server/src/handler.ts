import client from './db.js'
import type { Context, Next } from 'hono'
import { google } from 'googleapis'

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
}


export default Handler
