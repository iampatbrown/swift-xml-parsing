import Parsing

let optionalWhiteSpace = Whitespace<Substring.UTF8View>().printing("".utf8)
let atLeastOneWhiteSpace = Whitespace<Substring.UTF8View>().filter { !$0.isEmpty }
  .printing(" ".utf8)

func isLegalCharacter(_ s: UnicodeScalar) -> Bool {
  s != "\u{fffe}" && s != "\u{ffff}"
}

func isNameStartCharacter(_ s: UnicodeScalar) -> Bool {
  switch s {
  case "_",
       ":",
       "\u{2c00}"..."\u{2fef}",
       "\u{37f}"..."\u{1fff}",
       "\u{200c}"..."\u{200d}",
       "\u{370}"..."\u{37d}",
       "\u{2070}"..."\u{218f}",
       "\u{3001}"..."\u{d7ff}",
       "\u{10000}"..."\u{effff}",
       "\u{c0}"..."\u{d6}",
       "\u{d8}"..."\u{f6}",
       "\u{f8}"..."\u{2ff}",
       "\u{f900}"..."\u{fdcf}",
       "\u{fdf0}"..."\u{fffd}",
       "a"..."z",
       "A"..."Z":
    return true
  default:
    return false
  }
}

func isNameCharacter(_ s: UnicodeScalar) -> Bool {
  if isNameStartCharacter(s) { return true }
  switch s {
  case "-",
       ".",
       "\u{203f}"..."\u{2040}",
       "\u{0300}"..."\u{036f}",
       "\u{b7}",
       "0"..."9":
    return true
  default:
    return false
  }
}

func prefixWhile(
  scalar predicate: @escaping (UnicodeScalar) -> Bool,
  orUntil posibleMatch: String? = nil,
  minLength: Int = 0,
  maxLength: Int? = nil
) -> PrefixBy {
  PrefixBy(minLength: minLength, maxLength: maxLength) { input, _ in
    guard
      let scalar = input.firstScalar,
      posibleMatch.map({ !input.starts(with: $0.utf8) }) ?? true,
      predicate(scalar)
    else { return 0 }
    return UTF8.width(scalar)
  }
}

let name = PrefixBy { input, output -> Int in
  guard let scalar = input.firstScalar else { return 0 }
  if output.isEmpty {
    return isNameStartCharacter(scalar) ? UTF8.width(scalar) : 0
  } else {
    return isNameCharacter(scalar) ? UTF8.width(scalar) : 0
  }
}.map(.string)

extension Conversions {
  static func `struct`<Values, Root>(
    _ initializer: @escaping (Values) -> Root
  ) -> Conversions.Structure<Values, Root> {
    .struct(initializer)
  }
}

let testSeparated = Separated {
  Prefix(1...5) { $0 == .init(ascii: "'") }
  Prefix(1...5) { $0 == .init(ascii: "'") }
} separator: {
  ",".utf8
}
