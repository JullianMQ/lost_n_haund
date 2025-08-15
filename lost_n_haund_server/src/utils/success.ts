export type Success = {
  message?: unknown
  urlImage?: string
}

const NewSuccess = (
  message?: string,
  urlImage?: string):
  Success => {
  return { message, urlImage }
}

export { NewSuccess }

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
