import type { Context } from "hono";
import type { Success, CustomError } from "./../utils/success.js";
import { regexOrAll } from "./../utils/regexUtil.js";
import { NewSuccess, NewError } from "./../utils/success.js";
import { existsSync, mkdirSync, createReadStream } from "fs";
import { writeFile, unlink } from "fs/promises";
import { google } from "googleapis";
import path from "path";
import { fileURLToPath } from "url";
import db from "./../db.js";

// TODO: Maybe there's a way to upload the file directly? than saving it first in the server
// Although we could do more operations(checking, minify, conversion etc.)
// this way in the future, incase we need to minimize the file size works as needed right now
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const CLIENT_ID = process.env.CLIENT_ID;
const CLIENT_SECRET = process.env.CLIENT_SECRET;
const REDIRECT_URI = process.env.REDIRECT_URI;
const REFRESH_TOKEN = process.env.REFRESH_TOKEN;

const oauth2Client = new google.auth.OAuth2(
  CLIENT_ID,
  CLIENT_SECRET,
  REDIRECT_URI,
);

oauth2Client.setCredentials({ refresh_token: REFRESH_TOKEN });
const drive = google.drive({ version: "v3", auth: oauth2Client });
const authUsersDB = db.collection("authUser");

class UserHandler {
  async getUsers(c: Context) {
    const user_name = c.req.query("name") || "";
    const user_email = c.req.query("user_email") || "";
    const user_id = c.req.query("user_id") || "";
    const phone_num = c.req.query("phone_num") || "";
    const user_role = c.req.query("user_role") || "";
    const page =
      c.req.query("page") === undefined ? 0 : parseInt(c.req.query("page")!);

    try {
      // Used skip and limit pagination for now, as I don't think there's that much data
      // const query = { name: {$regex: /john .*/i} }
      const query = {
        $and: [
          { name: regexOrAll(user_name) },
          { email: regexOrAll(user_email) },
          { user_id: regexOrAll(user_id) },
          { phone_num: regexOrAll(phone_num) },
          { user_role: regexOrAll(user_role) },
        ],
      };
      const users = await authUsersDB
        .find(query)
        .skip(page)
        .limit(20)
        .toArray();
      return users;
    } catch (e) {
      console.error("Error", e);
    }
  }

  async upload(f: File): Promise<[Success, CustomError]> {
    let [success, error] = [NewSuccess(""), NewError("")];
    const dirPath = path.join(__dirname, "assets", "images");
    if (!existsSync(dirPath)) {
      mkdirSync(dirPath, { recursive: true });
    }

    const filePath = path.join(dirPath, f.name);
    const buffer = await f.arrayBuffer();

    try {
      await writeFile(filePath, Buffer.from(buffer));

      const res = await drive.files.create({
        requestBody: {
          name: f.name,
          mimeType: f.type,
          parents: ["1gTxMWFG93KcJKWoz0UNVJCgLAC0ZVze8"],
        },
        media: {
          mimeType: f.type,
          body: createReadStream(filePath),
        },
      });

      const fileId = res.data.id;

      drive.permissions.create({
        fileId: fileId!,
        requestBody: {
          role: "reader",
          type: "anyone",
        },
      });
      // server doesn't keep unnecessary files
      await unlink(filePath);

      success = {
        message: "File uploaded to Google Drive successfully",
        urlImage: `https://lh3.googleusercontent.com/d/${res.data.id}`,
      };

      return [success, error];
    } catch (e) {
      console.error("Service unavailable: ", e);
      const err = NewError(String(e));
      return [success, err];
    }
  }
}

export default UserHandler;
