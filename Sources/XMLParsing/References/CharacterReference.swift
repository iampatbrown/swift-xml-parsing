import Parsing

public enum CharacterReference: Equatable, CustomStringConvertible {
  case decimal(UnicodeScalar)
  case hex(UnicodeScalar)

  public var description: String {
    switch self {
    case let .decimal(unicodeScalar):
      return "&#\(String(unicodeScalar.value, radix: 10));"
    case let .hex(unicodeScalar):
      return "&#\(String(unicodeScalar.value, radix: 16));"
    }
  }
}

// TODO: Compare performance to ParserBuilder implementation
struct CharacterReferenceParser: ParserPrinter {
  func parse(_ input: inout Substring.UTF8View) throws -> CharacterReference {
    guard input.starts(with: "&#".utf8)
    else { throw ParsingError.failed() }

    let radix: Int
    if input.dropFirst(2).starts(with: "x".utf8) {
      radix = 16
      input.removeFirst(3)
    } else {
      radix = 10
      input.removeFirst(2)
    }

    let parser = Parsers.IntParser<Substring.UTF8View, UInt32>.init(isSigned: false, radix: radix)

    guard
      let value = try? parser.parse(&input),
      let scalar = UnicodeScalar(value),
      input.starts(with: ";".utf8)
    else { throw ParsingError.failed() }
    return radix == 16 ? .hex(scalar) : .decimal(scalar)
  }

  func print(_ output: CharacterReference, to input: inout Substring.UTF8View) {
    input.append(contentsOf: output.description.utf8)
  }
}
