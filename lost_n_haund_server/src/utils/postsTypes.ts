import z from "zod"

export const zodPostsSchema = z.object({
    item_name: z.string(),
    item_category: z.array(z.string()),
    description: z.string(),
    date_found: z.coerce.date(),
    location_found: z.string(),
    status: z.enum(["held", "archived", "pending", "returned"]).default("pending"),
    reference_id: z.string(),
  })

export type postsSchema = {
  item_name: string,
  item_category: string[],
  description: string,
  date_found: Date,
  location_found: string,
  status: "held" | "archived" | "pending" | "returned"
  reference_id: string,
}

export const nullPostsSchema: postsSchema = {
  item_name: "",
  item_category: [],
  description: "",
  date_found: new Date(),
  location_found: "",
  status: "pending",
  reference_id: "",
}
