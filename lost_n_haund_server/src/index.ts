import { serve } from '@hono/node-server'
import { Hono } from 'hono'
import UserHandler from './handlers/userHandler.js'
import PostHandler from './handlers/postHandler.js'

export const app = new Hono()
const u = new UserHandler()
const p = new PostHandler()

app.get('/users', async (c) => {
  try {
    const users = await u.getUsers(c)
    if (!users) {
      c.status(404)
      return c.json({ error: "users not found" })
    }

    c.status(200)
    return c.json({ users })

  } catch (e) {
    c.status(500)
    return c.json({ error: "Internal server error" })
  }
})

app.get('/posts', async (c) => {
  const posts = await p.getPosts(c)

  return c.json(posts)
})

app.post('/posts', async (c) => {
  const res = await p.postPosts(c)
  if (res.status === 400) {
    c.status(res.status)
    return c.json( res.error )
  }

  if (res.status === 500) {
    c.status(res.status)
    return c.json( res.error )
  }

  c.status(res.status)
  return c.json( res.success )
})

app.put('/posts/:id', async (c) => {
  const res = await p.updatePost(c)

  if (res.status === 400) {
    c.status(res.status)
    return c.json( res.error )
  }

  if (res.status === 500) {
    c.status(res.status)
    return c.json( res.error )
  }

  c.status(res.status)
  return c.json( res.success )
})

app.delete('/posts/:id', async (c) => {
  const res = await p.deletePost(c)

  if (res.status === 404) {
    c.status(res.status)
    return c.json( res.error )
  }

  if (res.status === 503) {
    c.status(res.status)
    return c.json( res.error )
  }

  if (res.status === 500) {
    c.status(res.status)
    return c.json( res.error )
  }

  c.status(res.status)
  return c.json( res.success )
})

app.get('/upload', async (c) => {
  c.status(200)
  return c.json("Upload path works")
})

app.post('/upload', async (c) => {
  const formData = await c.req.formData()
  const file = formData.get('file')

  try {
    if (!file || !(file instanceof File)) {
      return c.json({ message: 'No valid file uploaded' }, 400)
    }

    const [success, error] = await u.upload(file)
    if (error !== "") {
      c.status(503)
      return c.json({ error: error });
    }

    c.status(200)
    return c.json({ success })

  } catch (e) {
    c.status(500)
    return c.json({ error: e })
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
