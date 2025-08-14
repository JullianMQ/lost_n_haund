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

