import { createMiddleware } from "hono/factory";
import { auth } from "../utils/auth.js";

const requireAuth = createMiddleware<{
  Variables: {
    user: typeof auth.$Infer.Session.user | null;
    session: typeof auth.$Infer.Session.session | null;
  };
}>(async (c, next) => {
  const session = await auth.api.getSession({ headers: c.req.raw.headers });

  if (!session) {
    return c.json({ message: "Unauthorized" }, 401);
  }

  c.set("user", session.user);
  c.set("session", session.session);
  return next();
});

const requireAdmin = createMiddleware<{
  Variables: {
    user: typeof auth.$Infer.Session.user | null;
    session: typeof auth.$Infer.Session.session | null;
  };
}>(async (c, next) => {
  const session = await auth.api.getSession({ headers: c.req.raw.headers });

  if (!session || session.user.role !== "admin") {
    return c.json({ message: "Unauthorized" }, 401);
  }

  c.set("user", session.user);
  c.set("session", session.session);
  return next();
});

const addOwnerId = createMiddleware(async (c, next) => {
  const user = c.get("user");
  console.log("user", user)

  const owner_id = user.id;
  console.log("owner_id", owner_id)

  return next();
});

// TODO:
const canModifyPost = createMiddleware(async (c, next) => {
  // user(if they own)/admin can update or delete their post
});

const canModifyClaim = createMiddleware(async (c, next) => {
  // user(if they own)/admin can CRUD their claim
});

export { requireAuth, requireAdmin, addOwnerId };
