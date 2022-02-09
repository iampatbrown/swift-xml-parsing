//import Parsing
//
//public struct NotationDeclaration: Equatable {
//  public var name: String
//  public var id: ID
//
//  public enum ID: Equatable {
//    case external(ExternalID)
//    case `public`(PublicIDLiteral)
//  }
//}
//
//let notationDeclaration = Parse {
//  "<!NOTATION".utf8
//  Skip {
//    atLeastOneWhiteSpace
//  }
//  name
//  Skip {
//    atLeastOneWhiteSpace
//  }
//  OneOf {
//    externalId.map(NotationDeclaration.ID.external)
//    publicID.map(NotationDeclaration.ID.public)
//  }
//  ">".utf8
//}.map(NotationDeclaration.init)
//
//let publicID = Parse {
//  "PUBLIC".utf8
//  Skip {
//    atLeastOneWhiteSpace
//  }
//  publicIDLiteral
//}
