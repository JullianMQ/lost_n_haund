import type { StatusCode } from "hono/utils/http-status"

export type Success = {
  message?: unknown
  urlImage?: string
}
const NewSuccess = (message?: string, urlImage?: string):
  Success => {
    return { message, urlImage }
}

export type CustomError = string | Error
const NewError = ( message: string | Error ):
  CustomError => {
    return message
}

export { NewSuccess, NewError }

export type HandlerResult = {
  success?: Success
  error?: CustomError
  status: StatusCode
}

// export interface SuccessConstructor {
//   new (message?: string, urlImage?: string) : Success
//   (message?: string, urlImage?: string) : Success
// }
//
// export const Success: SuccessConstructor = function (
//   this: Success,
//   message?: string,
//   urlImage?: string
// ): Success {
//     return { message, urlImage}
// } as SuccessConstructor
