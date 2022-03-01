import Parsing

public struct Comment: Equatable {
  var rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }
}

let comment = Parse(.struct(Comment.init(rawValue:))) {
  "<!--".utf8
  PrefixBy { input, _ in
    guard !input.starts(with: "--".utf8), let scalar = input.firstScalar, isLegalCharacter(scalar)
    else { return 0 }
    return UTF8.width(scalar)
  }
  .map(.string)
  "-->".utf8
}
