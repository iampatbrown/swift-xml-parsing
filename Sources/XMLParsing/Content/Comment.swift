//import Parsing
//
//public struct Comment: Equatable {
//  var rawValue: String
//
//  public init(rawValue: String) {
//    self.rawValue = rawValue
//  }
//}
//
//let comment = Parse {
//  "<!--".utf8
//  utf8DecodingPrefix(while: isLegalCharacter, orUpTo: "--".utf8)
//  "-->".utf8
//}.map(Comment.init)
