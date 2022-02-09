//import Parsing
//
//public enum ExternalID: Equatable {
//  case system(SystemLiteral)
//  case `public`(PublicIDLiteral, SystemLiteral)
//}
//
//let externalId = OneOf {
//  Parse {
//    "SYSTEM".utf8
//    Skip {
//      atLeastOneWhiteSpace
//    }
//    systemLiteral
//  }.map(ExternalID.system)
//  Parse {
//    "PUBLIC".utf8
//    Skip {
//      atLeastOneWhiteSpace
//    }
//    publicIDLiteral
//    Skip {
//      atLeastOneWhiteSpace
//    }
//    systemLiteral
//  }.map(ExternalID.public)
//}
