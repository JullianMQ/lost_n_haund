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
const accountDB = db.collection("account");

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

  // async updateUser(c: Context): Promise<HandlerResult> {
  //   const formData = await c.req.formData();
  //   const user_id = c.req.param("id");
  //   const filter = { user_id: user_id };
  //
  //   const updateUserValues: Record<string, unknown> = {};
  //   let [firstName, lastName]: string = "";
  //   // TODO: Implement updating of user role
  //   // const usersKeys = ["user_name", "phone_num", "user_role"]
  //   const usersKeys = ["user_name", "phone_num"];
  //
  //   for (const key of usersKeys) {
  //     const value = formData.get(key);
  //     // keeping this one for now
  //     if (!value) {
  //       // not sure what's better, checking falsy values or specified ones
  //       continue;
  //     }
  //     updateUserValues[key] = value;
  //     firstName = String(updateUserValues["user_name"]).split(" ")[0];
  //     lastName = String(updateUserValues["user_name"]).split(" ")[1] || "";
  //     // keep in case of change in the future
  //     // if (value !== null && value !== undefined && value !== "") {
  //     //   updateUserValues[key] = value
  //     // }
  //   }
  //
  //   if (Object.keys(updateUserValues).length === 0) {
  //     return {
  //       status: 400,
  //       error: NewError("No valid values in the request"),
  //     };
  //   }
  //
  //   try {
  //     const res = await authUsersDB.findOne(filter);
  //     if (!res) {
  //       return {
  //         status: 404,
  //         error: NewError("User not found"),
  //       };
  //     }
  //
  //     const resContacts = await resend.contacts.update({
  //       email: res?.user_email,
  //       audienceId: audienceId,
  //       firstName: firstName,
  //       lastName: lastName,
  //     });
  //
  //     if (resContacts.error !== null) {
  //       return {
  //         status: 503,
  //         error: NewError(
  //           `Error updating the user ${resContacts.error.message}`,
  //         ),
  //       };
  //     }
  //
  //     const update = { $set: updateUserValues };
  //     const resMongo = await authUsersDB.updateOne(filter, update);
  //     if (!resMongo.acknowledged) {
  //       return {
  //         status: 503,
  //         error: NewError(`Error updating the user: Mongo UserDB Error`),
  //       };
  //     }
  //
  //     if (firstName !== "") {
  //       const resAuthUpdate = { $set: { name: `${firstName} ${lastName}` } };
  //       const resAuthFilter = { email: res.user_email };
  //       const resAuthMongo = await authUsersDB.updateOne(
  //         resAuthFilter,
  //         resAuthUpdate,
  //       );
  //       if (!resAuthMongo.acknowledged) {
  //         return {
  //           status: 503,
  //           error: NewError(`Error updating the user: Mongo AuthUserDB Error`),
  //         };
  //       }
  //     }
  //
  //     return {
  //       status: 200,
  //       success: NewSuccess("Updated user successfully"),
  //     };
  //   } catch (e) {
  //     return {
  //       status: 500,
  //       error: NewError(`Error updating the user ${e}`),
  //     };
  //   }
  // }

  // async deleteUser(c: Context): Promise<HandlerResult> {
  //   const user_id = c.req.param("id");
  //   const filter = { user_id: user_id };
  //
  //   try {
  //     const res = await authUsersDB.findOne(filter);
  //     if (!res) {
  //       return {
  //         status: 404,
  //         error: NewError("User not found"),
  //       };
  //     }
  //
  //     const resContacts = await resend.contacts.remove({
  //       email: res?.user_email,
  //       audienceId: audienceId,
  //     });
  //
  //     if (resContacts.error !== null) {
  //       return {
  //         status: 503,
  //         error: NewError(
  //           `Error deleting the user ${resContacts.error.message}`,
  //         ),
  //       };
  //     }
  //
  //     const resUsersMongo = await authUsersDB.deleteOne(filter);
  //     if (!resUsersMongo.acknowledged) {
  //       return {
  //         status: 503,
  //         error: NewError("Error deleting the user: Mongo users error"),
  //       };
  //     }
  //
  //     const resAuthUsersMongo = await authUsersDB.findOneAndDelete({
  //       email: res?.user_email,
  //     });
  //     if (!resAuthUsersMongo?._id) {
  //       return {
  //         status: 503,
  //         error: NewError("Error deleting the user: Mongo authUsers error"),
  //       };
  //     }
  //
  //     const resAccountMongo = await accountDB.deleteOne({
  //       accountId: resAuthUsersMongo._id,
  //     });
  //     if (!resAccountMongo.acknowledged) {
  //       return {
  //         status: 503,
  //         error: NewError("Error deleting the user: Mongo account error"),
  //       };
  //     }
  //
  //     return {
  //       status: 200,
  //       success: NewSuccess("Successfully deleted account"),
  //     };
  //   } catch (e) {
  //     console.error(`Error: ${e}`);
  //     return {
  //       status: 500,
  //       error: NewError("Error deleting account"),
  //     };
  //   }
  // }

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
