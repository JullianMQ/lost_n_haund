import { createMiddleware } from 'hono/factory'
import { auth } from "../utils/auth.js";

const requireAuth = createMiddleware(async (c, next) => {
  const session = await auth.api.getSession({ headers: c.req.raw.headers });

  if (!session) {
    return c.json({ message: "Unauthorized" }, 401);
  }

  c.set("user", session.user)
  c.set("session", session.session)
  return next();
})

const requireAdmin = createMiddleware(async (c, next) => {
  const session = await auth.api.getSession({ headers: c.req.raw.headers });

  if (!session || session.user.user_role !== "Admin") {
    return c.json({ message: "Unauthorized" }, 401);
  }

  c.set("user", session.user)
  c.set("session", session.session)
  return next();
})

// TODO:
const canModifyPost = createMiddleware(async (c, next) => {
  // user(if they own)/admin can update or delete their post
})

const canModifyClaim = createMiddleware(async (c, next) => {
  // user(if they own)/admin can CRUD their claim
})

export { requireAuth, requireAdmin }
