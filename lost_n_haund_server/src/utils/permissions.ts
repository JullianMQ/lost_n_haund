import { createAccessControl } from "better-auth/plugins/access";
import { defaultStatements, adminAc } from "better-auth/plugins/admin/access";

const access = { 
  ...defaultStatements,
    project: ["create", "update", "delete", "delete-post", "ban", "list-users"], 
} as const; 

export const ac = createAccessControl(access); 

export const student = ac.newRole({
  project: ["create", "update", "delete"]
})

export const moderator = ac.newRole({
  project: ["create", "delete-post", "ban", "list-users"],
  user: ["ban", "list", "get"]
})

export const admin = ac.newRole({
  project: ["create", "update", "delete", "ban"],
  ...adminAc.statements
})
