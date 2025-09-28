import { createMiddleware } from 'hono/factory'
import { auth } from "../utils/auth.js";

const authMiddleware = createMiddleware(async (c, next) => {
  const session = await auth.api.getSession({ headers: c.req.raw.headers });

  if (!session) {
    c.set("user", null);
    c.set("session", null);
    return c.json({ message: "Unauthorized" }, 401);
  }

  if (session.user.user_role !== "Admin") {
    return c.json({ message: "Unauthorized" }, 401);
  }

  return next();
})

export { authMiddleware }
