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
