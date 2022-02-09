//import Parsing
//
//public enum EntityDeclaration: Equatable {
//  case general(GeneralEntityDeclaration)
//  case parameter(ParameterEntityDeclaration)
//}
//
//public struct GeneralEntityDeclaration: Equatable {
//  public var name: String
//  public var definition: Definition
//
//  public enum Definition: Equatable {
//    case `internal`(EntityValue)
//    case external(ExternalID, Notation?)
//
//    public struct Notation: Equatable {
//      public var type: String
//    }
//  }
//}
//
//public struct ParameterEntityDeclaration: Equatable {
//  public var name: String
//  public var definition: Definition
//
//  public enum Definition: Equatable {
//    case `internal`(EntityValue)
//    case external(ExternalID)
//  }
//}
//
//let entityDeclaration = Parse {
//  "<!ENTITY".utf8
//  Skip {
//    atLeastOneWhiteSpace
//  }
//  OneOf {
//    generalEntityDeclaration
//      .map(EntityDeclaration.general)
//    parameterEntityDeclaration
//      .map(EntityDeclaration.parameter)
//  }
//  Skip {
//    Whitespace()
//  }
//  ">".utf8
//}
//
//let generalEntityDeclaration = Parse {
//  name
//  Skip {
//    atLeastOneWhiteSpace
//  }
//  entityDefinition
//}.map(GeneralEntityDeclaration.init)
//
//let entityDefinition = OneOf {
//  entityValue
//    .map(GeneralEntityDeclaration.Definition.internal)
//  Parse {
//    externalId
//    Optionally {
//      notationDataDeclaration
//    }
//  }.map(GeneralEntityDeclaration.Definition.external)
//}
//
//let notationDataDeclaration = Parse {
//  Skip {
//    atLeastOneWhiteSpace
//  }
//  "NDATA".utf8
//  Skip {
//    atLeastOneWhiteSpace
//  }
//  name
//}.map(GeneralEntityDeclaration.Definition.Notation.init)
//
//let parameterEntityDeclaration = Parse {
//  "%".utf8
//  Skip {
//    atLeastOneWhiteSpace
//  }
//  name
//  Skip {
//    atLeastOneWhiteSpace
//  }
//  parameterEntityDefinition
//}.map(ParameterEntityDeclaration.init)
//
//let parameterEntityDefinition = OneOf {
//  entityValue
//    .map(ParameterEntityDeclaration.Definition.internal)
//  externalId
//    .map(ParameterEntityDeclaration.Definition.external)
//}
