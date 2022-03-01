import Parsing

public struct EntityValue: Equatable {
  var rawValue: [Fragment] = []

  public enum Fragment: Equatable {
    case string(String)
    case parameterEntityReference(ParameterEntityReference)
    case reference(Reference)
  }
}

private let toStringFragment = /EntityValue.Fragment.string
private let toParameterEntityReferenceFragment = /EntityValue.Fragment.parameterEntityReference
private let toReferenceFragment = /EntityValue.Fragment.reference

private func isValidDoubleQuotedCharacter(_ s: UnicodeScalar) -> Bool {
  s != "\"" && s != "%" && s != "&"
}

private func isValidSingleQuotedCharacter(_ s: UnicodeScalar) -> Bool {
  s != "'" && s != "%" && s != "&"
}

let stringFragmentWithoutDoubleQuotes = prefixWhile(
  scalar: isValidDoubleQuotedCharacter,
  minLength: 1
)
  .map(.string.map(toStringFragment))

let stringFragmentWithoutSingleQuotes = prefixWhile(
  scalar: isValidSingleQuotedCharacter,
  minLength: 1
)
  .map(.string.map(toStringFragment))

let parameterEntityReferenceFragment = parameterEntityReference
  .map(toParameterEntityReferenceFragment)

let referenceFragment = reference.map(toReferenceFragment)

let entityValueFragmentWithoutDoubleQuotes = OneOf {
  stringFragmentWithoutDoubleQuotes
  parameterEntityReferenceFragment
  referenceFragment
}

let doubleQuotedEntityValue = DoubleQuoted {
  Many {
    OneOf {
      stringFragmentWithoutDoubleQuotes
      parameterEntityReferenceFragment
      referenceFragment
    }
  }
}

let singleQuotedEntityValue = SingleQuoted {
  Many {
    OneOf {
      stringFragmentWithoutSingleQuotes
      parameterEntityReferenceFragment
      referenceFragment
    }
  }
}

let entityValue = OneOf {
  doubleQuotedEntityValue
  singleQuotedEntityValue
}

// let entityValue = OneOf {
//  DoubleQuoted {
//    Many {
//      OneOf {
//        LookaheadPrefix(1..., whileFirst: isDoubleQuotedEntityValueCharacter)
//          .map(.string)
//          .map(/EntityValue.Fragment.string)
//        parameterEntityReference
//          .map(/EntityValue.Fragment.parameterEntityReference)
//        reference
//          .map(/EntityValue.Fragment.reference)
//      }
//    }
//  }
//  SingleQuoted {
//    Many {
//      OneOf {
//        LookaheadPrefix(1..., whileFirst: isSingleQuotedEntityValueCharacter)
//          .map(.string)
//          .map(/EntityValue.Fragment.string)
//        parameterEntityReference
//          .map(/EntityValue.Fragment.parameterEntityReference)
//        reference
//          .map(/EntityValue.Fragment.reference)
//      }
//    }
//  }
// }.map(.struct(EntityValue.init(rawValue:)))
//
// let _entityValue = OneOf {
//  DoubleQuoted {
//    Many {
//      OneOf {
//        LookaheadPrefix(1..., whileFirst: isDoubleQuotedEntityValueCharacter)
//          .map(.string)
//          .map(/EntityValue.Fragment.string)
//        parameterEntityReference
//          .map(/EntityValue.Fragment.parameterEntityReference)
//        reference
//          .map(/EntityValue.Fragment.reference)
//      }
//    }
//  }
//  SingleQuoted {
//    Many {
//      OneOf {
//        LookaheadPrefix(1..., whileFirst: isSingleQuotedEntityValueCharacter)
//          .map(.string)
//          .map(/EntityValue.Fragment.string)
//        parameterEntityReference
//          .map(/EntityValue.Fragment.parameterEntityReference)
//        reference
//          .map(/EntityValue.Fragment.reference)
//      }
//    }
//  }
// }.map(.representing(EntityValue.self))
//
//
