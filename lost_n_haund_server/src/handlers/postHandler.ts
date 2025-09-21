import type { Context } from 'hono'
import type { HandlerResult } from './../utils/success.js'
import { regexOrAll } from './../utils/regexUtil.js'
import { NewSuccess, NewError } from './../utils/success.js'
import { zodPostsSchema } from './../utils/postsTypes.js'
import { localToUTC, phTime } from './../utils/dateTimeConversion.js'
import db from './../db.js'
import { ObjectId } from 'mongodb'


class ItemPostHandler {
  private postsDB = db.collection('posts')

  async getItems(c: Context) {

    const item_name = c.req.query('name') || ''
    const description = c.req.query('description') || ''
    const location_found = c.req.query('location') || ''
    const status = c.req.query('status') || ''
    const item_category = c.req.queries('categories') || []
    const page = c.req.query('page') === undefined ? 0 : parseInt(c.req.query('page')!)

    try {
      const query = {
        $and: [
          { item_name: regexOrAll(item_name) },
          { description: regexOrAll(description) },
          { location_found: regexOrAll(location_found) },
          { status: regexOrAll(status) },
          {
            item_category: item_category.length !== 0
              ? { $all: item_category }
              : { $not: / / }
          },
        ]
      }
      const posts = await this.postsDB.find(query).skip(page).limit(20).toArray()
      return posts

    } catch (e) {
      console.error("Error", e);
    }
  }

  async createLostItemPost(c: Context): Promise<HandlerResult> {
    const formData = await c.req.formData()

    try {
      const rawData = {
        item_name: formData.get("item_name") as string,
        item_category: (formData.getAll("item_category") as string[]) ?? [],
        description: formData.get("description") as string,
        date_found: localToUTC(formData.get("date_found") as string, phTime),
        location_found: formData.get("location_found") as string,
        status: (formData.get("status") as string) || "pending",
      }

      const res = zodPostsSchema.safeParse(rawData)
      if (!res.success) {
        console.error(res.error);
        return {
          error: NewError('Error parsing data'),
          status: 400
        }
      }

      const postResult = await this.postsDB.insertOne(res.data)
      if (!postResult.acknowledged) {
        return {
          error: NewError('Mongo error'),
          status: 503
        }
      }

      return {
        success: NewSuccess('Item successfully posted'),
        status: 201
      }
    }

    catch (e) {
      console.error('Internal server error:', e);
      return {
        error: NewError('Internal server error'),
        status: 500
      }
    }
  }

  async updateItemPost(c: Context): Promise<HandlerResult> {
    const id = c.req.param('id')

    try {
      const formData = await c.req.formData()
      const updatedData: Record<string, unknown> = {}
      const formEntries = formData.entries()
      
      for (const [key, value] of formEntries) {
        if (value === null) continue
        if (typeof value === "string" && value.trim() === "") continue

        if (key === "item_category") {
          const categories = formData.getAll("item_category") as string[]
          if (categories.length > 0) updatedData[key] = categories
        } else if (key === "date_found") {
          updatedData[key] = localToUTC(value as string, phTime)
        } else {
          updatedData[key] = value
        }
      }

      const res = zodPostsSchema.partial().safeParse(updatedData)
      if (!res.success) {
        return {
          status: 400,
          error: NewError('Invalid data')
        }
      }

      const updateResult = await this.postsDB.updateOne(
        { _id: new ObjectId(id) },
        { $set: updatedData }
      )

      if (updateResult.matchedCount === 0) {
        return {
          status: 400,
          error: NewError('Post not found')
        }
      }

      return {
        success: NewSuccess('Post update successfully'),
        status: 200
      }
    }

    catch (e) {
      console.error('Error updating post:', e);
      return {
        status: 500,
        error: NewError('Internal server error')
      }
    }
  }

  async deletePost(c: Context): Promise<HandlerResult> {
    const id = c.req.param('id')

    try {
      const res = await this.postsDB.deleteOne(
        { _id: new ObjectId(id) }
      )

      if (res.deletedCount === 0) {
        return {
          error: NewError("Data not found"),
          status: 404
        }
      }

      if (!res.acknowledged) {
        return {
          error: NewError('Mongo error'),
          status: 503
        }
      }

      return {
        success: NewSuccess("Data successfully deleted"),
        status: 202
      }

    } catch (e) {
      console.error('Error deleting post:', e);
      return {
        status: 500,
        error: NewError('Internal server error')
      }
    }
  }
}

export default ItemPostHandler
