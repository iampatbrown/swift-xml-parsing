import Parsing

public struct SystemLiteral: Equatable {
  var rawValue: String
}

let systemLiteral = QuotedLiteral().map(toSystemLiteral)

private let toSystemLiteral = Conversions.struct(SystemLiteral.init)
