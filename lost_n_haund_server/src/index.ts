import { serve } from '@hono/node-server'
import { Hono } from 'hono'
import Handler from './handler.js'

export const app = new Hono()
const h = new Handler()

app.get('/', (c) => {
  return c.text('Hello Hono!')
})

app.get('/movies', async (c) => {
  c.header("Content-Type", "application/json")
  try {
    const movie = await h.runQuery(c)
    if (!movie) {
      c.status(404)
      return c.json({ error: "Movie not found" })
    }

    c.status(200)
    return c.json([

      { "movie": movie }
    ])
app.get('/upload', async (c) => {
  c.header("Content-Type", "application/json")
  c.status(200)
  return c.json("Upload path works")
})
  } catch (e) {
    c.status(500)
    c.json({ error: "Internal server error" })
  }
})

const server = serve({
  fetch: app.fetch,
  port: 3030
}, (info) => {
  console.log(`Server is running on http://localhost:${info.port}`)
})

// graceful shutdown
process.on('SIGINT', () => {
  server.close()
  process.exit(0)
})
process.on('SIGTERM', () => {
  server.close((err) => {
    if (err) {
      console.error(err)
      process.exit(1)
    }
    process.exit(0)
  })
})
