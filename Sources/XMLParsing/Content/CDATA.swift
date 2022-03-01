import Parsing

public struct CDATA: Equatable {
  var rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }
}

let cdata = Parse {
  "<![CDATA[".utf8
  PrefixBy { input, _ in
    guard !input.starts(with: "]]>".utf8), let scalar = input.firstScalar, isLegalCharacter(scalar)
    else { return 0 }
    return UTF8.width(scalar)
  }
  .map(.string)
  "]]>".utf8
}.map(toCdata)

private let toCdata = Conversions.struct(CDATA.init)
