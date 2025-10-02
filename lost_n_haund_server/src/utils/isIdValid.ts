import type { Context } from "hono";
import { ObjectId } from "mongodb";

export default function isIDValid(c: Context): ObjectId | null {
  if (!ObjectId.isValid(c.req.param("id"))) {
    return null;
  }

  const id = new ObjectId(c.req.param("id"));
  return id;
}
