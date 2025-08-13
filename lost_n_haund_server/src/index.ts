import { serve } from '@hono/node-server'
import { Hono } from 'hono'
import Handler from './handler.js'

export const app = new Hono()
const h = new Handler()

app.get('/', (c) => {
  return c.text('Hello Hono!')
})

app.get('/users', async (c) => {
  c.header("Content-Type", "application/json")
  try {
    const users = await h.getUsers(c)
    if (!users) {
      c.status(404)
      return c.json({ error: "users not found" })
    }

    c.status(200)
    return c.json([
      { "users": users }
    ])

  } catch (e) {
    c.status(500)
    c.json({ error: "Internal server error" })
  }
})

app.get('/upload', async (c) => {
  c.header("Content-Type", "application/json")
  c.status(200)
  return c.json("Upload path works")
})

app.post('/upload', async (c) => {
  c.header("Content-Type", "application/json")
  const formData = await c.req.formData()
  const file = formData.get('file')

  try {
    if (!file || !(file instanceof File)) {
      return c.json({ message: 'No valid file uploaded' }, 400)
    }

    return await h.upload(c, file)

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
