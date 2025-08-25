export function regexOrAll(value: string) {
    if (value !== '') {
      return new RegExp(`${value}`, 'i')
    }
    return new RegExp(`.*`, 'i')
  }

