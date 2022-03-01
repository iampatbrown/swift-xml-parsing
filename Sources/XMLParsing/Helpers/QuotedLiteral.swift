import Foundation
import Parsing

struct QuotedLiteral: ParserPrinter {
  let parser: Parsers.OneOf2<
    DoubleQuoted<PrefixBy>,
    SingleQuoted<PrefixBy>
  >

  init(_ isLiteral: @escaping (UnicodeScalar) -> Bool = { _ in true }) {
    self.parser = .init(
      DoubleQuoted {
        prefixWhile(scalar: isLiteral, orUntil: "\"")
      },
      SingleQuoted {
        prefixWhile(scalar: isLiteral, orUntil: "'")
      }
    )
  }

  func parse(_ input: inout Substring.UTF8View) throws -> String {
    try self.parser
      .map { String(decoding: $0, as: UTF8.self) }
      .parse(&input)
  }

  func print(_ output: String, to input: inout Substring.UTF8View) throws {
    let output = Input(output.utf8)
    try self.parser.print(output, to: &input)
  }
}
