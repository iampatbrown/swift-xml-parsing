import Parsing

public struct EntityValue: Equatable {
  var rawValue: [Fragment] = []

  enum Fragment: Equatable {
    case string(String)
    case parameterEntityReference(ParameterEntityReference)
    case reference(Reference)
  }
}

let entityValue = OneOf {
  doubleQuoted {
    Many {
      OneOf {
        utf8DecodingPrefix(1...) { $0 != "\"" && isEntityValueCharacter($0) }
          .map(EntityValue.Fragment.string)
        parameterEntityReference
          .map(EntityValue.Fragment.parameterEntityReference)
        reference
          .map(EntityValue.Fragment.reference)
      }
    }
  }
  singleQuoted {
    Many {
      OneOf {
        utf8DecodingPrefix(1...) { $0 != "'" && isEntityValueCharacter($0) }
          .map(EntityValue.Fragment.string)
        parameterEntityReference
          .map(EntityValue.Fragment.parameterEntityReference)
        reference
          .map(EntityValue.Fragment.reference)
      }
    }
  }
}.map(EntityValue.init)

func isEntityValueCharacter(_ s: UnicodeScalar) -> Bool {
  s != "%" && s != "&"
}
