import client from './db.js'
import type { Context, Next } from 'hono'

class Handler {
  async runQuery(c: Context) {
    const title = c.req.query('title') || ''
    
    try {
      const db = client.db('sample_mflix')
      const movies = db.collection('movies')

      // const query = { title: {$regex: /The Great .*/i} }
      const query = { title: new RegExp(`^${title}`, 'i') }
      const movie = movies.find(query).toArray()

      if ((await movie).length > 20) {
        return (await movie).slice(0, 20)
      }

      return movie
    } catch (e) {
      console.error("Error", e)
    }
  }
}


export default Handler
