import Parsing

public enum EntityDeclaration: Equatable {
  case general(GeneralEntityDeclaration)
  case parameter(ParameterEntityDeclaration)
}

public struct GeneralEntityDeclaration: Equatable {
  public var name: String
  public var definition: Definition

  public enum Definition: Equatable {
    case `internal`(EntityValue)
    case external(ExternalID, Notation?)

    public struct Notation: Equatable {
      public var type: String
    }
  }
}

public struct ParameterEntityDeclaration: Equatable {
  public var name: String
  public var definition: Definition

  public enum Definition: Equatable {
    case `internal`(EntityValue)
    case external(ExternalID)
  }
}

//let entityDeclaration = Parse {
//  "<!ENTITY".utf8
//  atLeastOneWhiteSpace
//  OneOf {
//    Parse(/EntityDeclaration.general) { generalEntityDeclaration }
//    Parse(/EntityDeclaration.parameter) { parameterEntityDeclaration }
//  }
//  optionalWhiteSpace
//  ">".utf8
//}
//
//let generalEntityDeclaration = Parse(.struct(GeneralEntityDeclaration.init(name:definition:))) {
//  name
//  atLeastOneWhiteSpace
//  entityDefinition
//}
//
//let entityDefinition = OneOf {
//  Parse(/GeneralEntityDeclaration.Definition.internal) { entityValue }
//
//  Parse(/GeneralEntityDeclaration.Definition.external) {
//    externalId
//    Optionally { notationDataDeclaration }
//  }
//}
//
//let notationDataDeclaration =
//  Parse(.struct(GeneralEntityDeclaration.Definition.Notation.init(type:))) {
//    atLeastOneWhiteSpace
//    "NDATA".utf8
//    atLeastOneWhiteSpace
//    name
//  }
//
//let parameterEntityDeclaration = Parse(.struct(ParameterEntityDeclaration.init(name:definition:))) {
//  "%".utf8
//  atLeastOneWhiteSpace
//  name
//  atLeastOneWhiteSpace
//  parameterEntityDefinition
//}
//

//let parameterEntityDefinition = OneOf {
//  Parse(/ParameterEntityDeclaration.Definition.internal) { entityValue }
//  Parse(/ParameterEntityDeclaration.Definition.external) { externalId }
//}
