//import Parsing
//
//let atLeastOneWhiteSpace = Whitespace().filter { !$0.isEmpty }
//
//let skipEqualSign = Skip {
//  Whitespace()
//  "=".utf8
//  Whitespace()
//}
//

//
//let name = Parse {
//  utf8DecodingPrefix(1, while: isNameStartCharacter)
//  utf8DecodingPrefix(while: isNameCharacter)
//}.map(+)
//
//let nameToken = utf8DecodingPrefix(1..., while: isNameStartCharacter)
//
//let nameTokens = Many(atLeast: 1) {
//  nameToken
//} separatedBy: {
//  " ".utf8
//}
