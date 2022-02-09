//import Parsing
//
//public struct CDATA: Equatable {
//  var rawValue: String
//
//  public init(rawValue: String) {
//    self.rawValue = rawValue
//  }
//}
//
//let cdata = Parse {
//  "<![CDATA[".utf8
//  utf8DecodingPrefix(while: isLegalCharacter, orUpTo: "]]>".utf8)
//  "]]>".utf8
//}.map(CDATA.init)
