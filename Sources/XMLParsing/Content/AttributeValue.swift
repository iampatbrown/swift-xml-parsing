import Parsing

public struct AttributeValue: Equatable {
  var rawValue: [Fragment]

  enum Fragment: Equatable {
    case string(String)
    case reference(Reference)
  }
}

private let toStringFragment = /AttributeValue.Fragment.string
private let toReferenceFragment = /AttributeValue.Fragment.reference
private let toAttributeValue = Conversions.struct(AttributeValue.init)

private func isDoubleQuotedAttributeValueCharacter(_ s: UnicodeScalar) -> Bool {
  s != "\"" && s != "<" && s != "&"
}

private func isSingleQuotedAttributeValueCharacter(_ s: UnicodeScalar) -> Bool {
  s != "'" && s != "<" && s != "&"
}

private let stringFragmentWithoutDoubleQuote = prefixWhile(
  scalar: isDoubleQuotedAttributeValueCharacter,
  minLength: 1
).map(.string.map(toStringFragment))

private let fragmentWithoutDoubleQuote = OneOf {
  stringFragmentWithoutDoubleQuote
  reference.map(toReferenceFragment)
}

private let doubleQuotedAttributeValue = DoubleQuoted {
  Many {
    fragmentWithoutDoubleQuote
  }.map(toAttributeValue)
}

private let stringFragmentWithoutSingleQuote = prefixWhile(
  scalar: isSingleQuotedAttributeValueCharacter,
  minLength: 1
).map(.string.map(toStringFragment))

private let fragmentWithoutSingleQuote = OneOf {
  stringFragmentWithoutSingleQuote
  reference.map(toReferenceFragment)
}

private let singleQuotedAttributeValue = SingleQuoted {
  Many {
    fragmentWithoutSingleQuote
  }.map(toAttributeValue)
}

let attributeValue = OneOf {
  doubleQuotedAttributeValue
  singleQuotedAttributeValue
}
