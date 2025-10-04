import z from "zod"

export const zodClaimSchema = z.object({
  owner_id: z.string(),
  first_name: z.string().min(2),
  last_name: z.string().min(2),
  user_email: z.email(),
  phone_num: z.coerce.string().regex(/^09\d{9}$/),
  user_id: z.string().regex(/^\d{8}$/),
  reference_id: z.string(),
  justification: z.string().max(400).min(30),
})

export const zodPostClaimSchema = z.object({
  owner_id: z.string(),
  first_name: z.string().min(2),
  last_name: z.string().min(2),
  user_email: z.email(),
  phone_num: z.coerce.string().regex(/^09\d{9}$/),
  user_id: z.string().regex(/^\d{8}$/),
  image_url: z.string(),
  reference_id: z.string(),
  justification: z.string().max(400).min(30),
})
