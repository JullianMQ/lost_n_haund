const [phTime, minutes, seconds, ms] = [8, 60, 60, 1000]

function localToUTC(dateStr: string, tzOffsetHours: number) {
  let localDate = new Date(dateStr)
  let utcDate = new Date(localDate.getTime() - tzOffsetHours * minutes * seconds * ms) // conversion from ph to utc for database storing
  return utcDate
}

export { phTime, localToUTC }
