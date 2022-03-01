@usableFromInline
enum ParsingError: Error {
  case failed(String = "parsing failed")
}

@usableFromInline
enum PrintingError: Error {
  case failed(String = "printing failed")
}

@usableFromInline
enum ConvertingError: Error {
  case failed(String = "printing failed")
}
