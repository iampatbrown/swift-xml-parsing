import Parsing

public struct AttributeValue: Equatable {
  var rawValue: [Fragment]

  enum Fragment: Equatable {
    case string(String)
    case reference(Reference)
  }
}

let attributeValue = OneOf {
  doubleQuoted {
    Many {
      OneOf {
        utf8DecodingPrefix(1...) { $0 != "\"" && isAttributeValueCharacter($0) }
          .map(AttributeValue.Fragment.string)
        reference
          .map(AttributeValue.Fragment.reference)
      }
    }
  }
  singleQuoted {
    Many {
      OneOf {
        utf8DecodingPrefix(1...) { $0 != "'" && isAttributeValueCharacter($0) }
          .map(AttributeValue.Fragment.string)
        reference
          .map(AttributeValue.Fragment.reference)
      }
    }
  }
}.map(AttributeValue.init)

func isAttributeValueCharacter(_ s: UnicodeScalar) -> Bool {
  s != "<" && s != "&"
}


