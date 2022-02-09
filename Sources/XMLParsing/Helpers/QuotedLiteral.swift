import Foundation
import Parsing

struct QuotedLiteral<Input: AppendableCollection>: ParserPrinter where
  Input.SubSequence == Input,
  Input.Element == UTF8.CodeUnit
{
  let parser: Parsers.OneOf2<
    DoubleQuoted<LookaheadPrefix<Input>>,
    SingleQuoted<LookaheadPrefix<Input>>
  >

  init(_ isLiteral: @escaping (UnicodeScalar) -> Bool = { _ in true }) {
    self.parser = Parsers.OneOf2(
      DoubleQuoted {
        LookaheadPrefix<Input> {
          $0.first != .init(ascii: "\"") && UTF8.decodeOne($0).map(isLiteral) ?? false
        }
      },
      SingleQuoted {
        LookaheadPrefix<Input> {
          $0.first != .init(ascii: "'") && UTF8.decodeOne($0).map(isLiteral) ?? false
        }
      }
    )
  }

  func parse(_ input: inout Input) throws -> String {
    try self.parser
      .map { String(decoding: $0, as: UTF8.self) }
      .parse(&input)
  }

  func print(_ output: String, to input: inout Input) throws {
    let output = Input(output.utf8)
    try self.parser.print(output, to: &input)
  }
}

func quotedLiteral(
  _ isLiteral: @escaping (UnicodeScalar) -> Bool = { _ in true }
) -> AnyParser<Substring.UTF8View, String> {
  OneOf {
    DoubleQuoted {
      utf8DecodingPrefix { $0 != "\"" && isLiteral($0) }
    }
    SingleQuoted {
      utf8DecodingPrefix { $0 != "'" && isLiteral($0) }
    }
  }.eraseToAnyParser()
}
