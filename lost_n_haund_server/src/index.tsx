import { serve } from "@hono/node-server";
import { Hono } from "hono";
import UserHandler from "./handlers/userHandler.js";
import ItemPostHandler from "./handlers/postHandler.js";
import ClaimsHandler from "./handlers/claimsHandler.js";
import { Top } from "./pages/verified.js";
import { auth } from "./utils/auth.js";
import { addOwnerId, requireAdmin, requireAuth } from "./middleware/authMiddleware.js";

export const app = new Hono<{
  Variables: {
    user: typeof auth.$Infer.Session.user | null;
    session: typeof auth.$Infer.Session.session | null;
  }
}>();
const u = new UserHandler();
const p = new ItemPostHandler();
const cl = new ClaimsHandler();

app.get("/users/auth/verified", async (c) => {
  const message = "You may now enter the app!";
  return c.html(<Top message={message} />);
});

// TODO: CREATE MIDDLEWARE FOR ADMINS, MODERATORS, STUDENTS
// ==> ADMINS - able to do anything
// ==> MODERATORS - accept and deny claims, delete posts
// ==> STUDENTS - create, update, delete their specific posts/claims/accounts
app.use("/claims/*", requireAuth);
app.use("/posts/*", requireAuth, addOwnerId);
app.use("/user/*", requireAdmin);

app.on(["POST", "GET"], "/users/auth/*", (c) => {
  return auth.handler(c.req.raw);
});

app.get("/user", async (c) => {
  try {
    const users = await u.getUsers(c);
    if (!users) {
      c.status(404);
      return c.json({ error: "users not found" });
    }

    c.status(200);
    return c.json({ users });
  } catch (e) {
    c.status(500);
    return c.json({ error: "Internal server error" });
  }
});

app.get("/posts", async (c) => {
  try {
    const posts = await p.getItems(c);
    return c.json(posts);
  } catch (e) {
    console.error(`Unexpected error ${e}`);
    return c.json({ error: "Internal server error" }, 500);
  }
});

app.post("/posts", async (c) => {
  const res = await p.createLostItemPost(c);
  c.status(res.status);
  if (res.status >= 400 && res.status <= 511) {
    // supported error codes from hono
    return c.json(res.error);
  }

  return c.json(res.success);
});

app.get("/claims", async (c) => {
  try {
    const claims = await cl.getClaimPosts(c);
    return c.json(claims);
  } catch (e) {
    console.error(`Unexpected error ${e}`);
    return c.json({ error: "Internal server error" }, 500);
  }
});

app.post("/claims", async (c) => {
  const res = await cl.createClaimItemPost(c);
  c.status(res.status);
  if (res.status >= 400 && res.status <= 511) {
    // supported error codes from hono
    return c.json(res.error);
  }

  return c.json(res.success);
});

app.put("/claims/:id", async (c) => {
  const res = await cl.updateClaimPost(c);
  c.status(res.status);
  if (res.status >= 400 && res.status <= 511) {
    // supported error codes from hono
    return c.json(res.error);
  }

  return c.json(res.success);
});

app.delete("/claims/:id", async (c) => {
  const res = await cl.deleteClaimPost(c);
  c.status(res.status);
  if (res.status >= 400 && res.status <= 511) {
    // supported error codes from hono
    return c.json(res.error);
  }

  return c.json(res.success);
});

app.put("/posts/:id", async (c) => {
  const res = await p.updateItemPost(c);
  c.status(res.status);

  if (res.status >= 400 && res.status <= 511) {
    // supported error codes from hono
    return c.json(res.error);
  }

  return c.json(res.success);
});

app.delete("/posts/:id", async (c) => {
  const res = await p.deletePost(c);
  c.status(res.status);

  if (res.status >= 400 && res.status <= 511) {
    // supported error codes from hono
    return c.json(res.error);
  }

  return c.json(res.success);
});

app.post("/upload", async (c) => {
  const formData = await c.req.formData();
  const file = formData.get("file");

  try {
    if (!file || !(file instanceof File)) {
      return c.json({ message: "No valid file uploaded" }, 400);
    }

    const [success, error] = await u.upload(file);
    if (error !== "") {
      c.status(503);
      return c.json({ error: error });
    }

    c.status(200);
    return c.json({ success });
  } catch (e) {
    c.status(500);
    return c.json({ error: e });
  }
});

const server = serve(
  {
    fetch: app.fetch,
    port: 3030,
  },
  (info) => {
    console.log(`Server is running on http://localhost:${info.port}`);
  },
);

// graceful shutdown
process.on("SIGINT", () => {
  server.close();
  process.exit(0);
});
process.on("SIGTERM", () => {
  server.close((err) => {
    if (err) {
      console.error(err);
      process.exit(1);
    }
    process.exit(0);
  });
});
