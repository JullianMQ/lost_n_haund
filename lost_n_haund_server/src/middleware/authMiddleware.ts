import { createMiddleware } from "hono/factory";
import { auth } from "../utils/auth.js";
import db from "../db.js";
import { ObjectId } from "mongodb";

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
  if (!user) {
    return c.json({ message: "Unauthorized" }, 401);
  }

  const owner_id = user?.id;
  c.set("owner_id", owner_id);
  return next();
});

const canUpdatePost = createMiddleware(async (c, next) => {
  const post_id = c.req.param("id");
  const resource = await db.collection("posts").findOne({ _id: new ObjectId(post_id) });

  if (!resource) {
    return c.json({ message: "Post not found" }, 404);
  }

  const owner_id = resource.owner_id;

  if (owner_id === c.get("owner_id")) {
    return next();
  }

  return c.json({ message: "Forbidden" }, 403);
});

const canDeletePost = createMiddleware(async (c, next) => {
  const user = c.get("user");
  if (user.role === "admin" || user.role === "moderator") {
    return next();
  }

  const post_id = c.req.param("id");
  const resource = await db.collection("posts").findOne({ _id: new ObjectId(post_id) });
  if (!resource) {
    return c.json({ message: "Post not found" }, 404);
  }

  const owner_id = resource.owner_id;
  if (owner_id === c.get("owner_id")) {
    return next();
  }

  return c.json({ message: "Forbidden" }, 403);
});

const availableClaims = createMiddleware(async (c, next) => {
  const user = c.get("user");
  if (user.role === "admin" || user.role === "moderator") {
    return next();
  }

  const claims = await db.collection("claims").find({ owner_id: c.get("owner_id") }).toArray();
  if (claims.length === 0) {
    return c.json({ message: "No claims available" }, 404);
  }

  return next();
});

const canAccessClaim = createMiddleware(async (c, next) => {
  const user = c.get("user");
  const claim_id = c.req.param("id");
  const resource = await db.collection("claims").findOne({ _id: new ObjectId(claim_id) });
  if (!resource) {
    return c.json({ message: "Claim not found" }, 404);
  }

  if (user.role === "admin" || user.role === "moderator") {
    return next();
  }

  const owner_id = resource.owner_id;
  if (owner_id === c.get("owner_id")) {
    return next();
  }

  return c.json({ message: "Forbidden" }, 403);
})

export { requireAuth, requireAdmin, addOwnerId, canUpdatePost, canDeletePost, availableClaims, canAccessClaim };
