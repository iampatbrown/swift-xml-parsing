import Combine
import Parsing

func singleQuoted<Upstream>(
  @ParserBuilder _ build: () -> Upstream
) -> AnyParser<Upstream.Input, Upstream.Output>
  where Upstream: Parser, Upstream.Input == Substring.UTF8View
{
  let upstream = build()
  return AnyParser { input in
    guard input.starts(with: "'".utf8) else { return nil }
    let original = input
    input.removeFirst()
    guard let output = upstream.parse(&input), input.starts(with: "'".utf8) else {
      input = original
      return nil
    }
    input.removeFirst()
    return output
  }
}

func doubleQuoted<Upstream>(
  @ParserBuilder _ build: () -> Upstream
) -> AnyParser<Upstream.Input, Upstream.Output>
  where Upstream: Parser, Upstream.Input == Substring.UTF8View
{
  let upstream = build()
  return AnyParser { input in
    guard input.starts(with: "\"".utf8) else { return nil }
    let original = input
    input.removeFirst()
    guard let output = upstream.parse(&input), input.starts(with: "\"".utf8) else {
      input = original
      return nil
    }
    input.removeFirst()
    return output
  }
}

func utf8DecodingPrefix(
  minLength: Int = 0,
  maxLength: Int = .max,
  while predicate: @escaping (UnicodeScalar) -> Bool
) -> AnyParser<Substring.UTF8View, String> {
  AnyParser { input in
    var utf8Decoder = Unicode.UTF8()
    var bytesIterator = input.makeIterator()
    var count = 0
    var length = 0

    Decode: while length < maxLength {
      switch utf8Decoder.decode(&bytesIterator) {
      case let .scalarValue(scalar) where predicate(scalar):
        count += UTF8.width(scalar)
        length += 1
      default:
        break Decode
      }
    }

    guard length >= minLength else { return nil }
    defer { input.removeFirst(count) }
    return String(decoding: input.prefix(count), as: UTF8.self)
  }
}

func utf8DecodingPrefix(
  _ length: Int,
  while predicate: @escaping (UnicodeScalar) -> Bool
) -> AnyParser<Substring.UTF8View, String> {
  utf8DecodingPrefix(minLength: length, maxLength: length, while: predicate)
}

func utf8DecodingPrefix(
  _ range: PartialRangeFrom<Int>,
  while predicate: @escaping (UnicodeScalar) -> Bool
) -> AnyParser<Substring.UTF8View, String> {
  utf8DecodingPrefix(minLength: range.lowerBound, maxLength: .max, while: predicate)
}

func utf8DecodingPrefix(
  while predicate: @escaping (UnicodeScalar) -> Bool,
  orUpTo possibleMatch: String.UTF8View,
  trimmingWhiteSpace: Bool = false
) -> AnyParser<Substring.UTF8View, String> {
  AnyParser { input in
    let original = input

    var utf8Decoder = Unicode.UTF8()
    var bytesIterator = input.makeIterator()
    var count = 0

    Decode: while !bytesIterator.starts(with: possibleMatch) {
      switch utf8Decoder.decode(&bytesIterator) {
      case let .scalarValue(scalar) where predicate(scalar):
        count += UTF8.width(scalar)
      default:
        break Decode
      }
    }
    defer { input.removeFirst(count) }
    let output = original.prefix(count)
    guard trimmingWhiteSpace else { return String(decoding: output, as: UTF8.self) }
    // TODO: fix this.... maybe that's why I shouldn't return a string here....
    let startIndex = output.firstIndex(where: { (byte: UTF8.CodeUnit) in
      byte != .init(ascii: " ")
        && byte != .init(ascii: "\n")
        && byte != .init(ascii: "\r")
        && byte != .init(ascii: "\t")
    }) ?? output.startIndex

    let endIndex = output.lastIndex(where: { (byte: UTF8.CodeUnit) in
      byte != .init(ascii: " ")
        && byte != .init(ascii: "\n")
        && byte != .init(ascii: "\r")
        && byte != .init(ascii: "\t")
    }).map { output.index($0, offsetBy: 1) } ?? output.endIndex
    return String(decoding: output[startIndex..<endIndex], as: UTF8.self)


  }
}



func quotedLiteral(
  _ isLiteral: @escaping (UnicodeScalar) -> Bool = { _ in true }
) -> AnyParser<Substring.UTF8View, String> {
  OneOf {
    doubleQuoted {
      utf8DecodingPrefix { $0 != "\"" && isLiteral($0) }
    }
    singleQuoted {
      utf8DecodingPrefix { $0 != "'" && isLiteral($0) }
    }
  }.eraseToAnyParser()
}

extension Parser {
  func debug(
    _ prefix: String = "",
    input debugInput: ((Input) -> Void)? = nil,
    output debugOutput: ((Output) -> Void)? = nil,
    file: StaticString = #fileID,
    line: UInt = #line
  ) -> AnyParser<Input, Output> {
    AnyParser { input in
      guard let output = self.parse(&input) else {
        print("""
        ---
        Parsing Failed\(prefix.isEmpty ? "" : ":\(prefix)")@\(file):\(line)
        """)
        debugInput.map { $0(input) } ?? print(input)
        print("---")
        return nil
      }
      debugOutput.map { $0(output) }
      return output
    }
  }

  func debug(
    _ prefix: String = "",
    file: StaticString = #fileID,
    line: UInt = #line
  ) -> AnyParser<Input, Output> where Input == Substring.UTF8View {
    self.debug(prefix, input: { print(String(decoding: $0, as: UTF8.self)) }, file: file, line: line)
  }
}
