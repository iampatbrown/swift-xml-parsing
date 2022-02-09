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
//func isLegalCharacter(_ s: UnicodeScalar) -> Bool {
//  s != "\u{fffe}" && s != "\u{ffff}"
//}
//
//func isNameStartCharacter(_ s: UnicodeScalar) -> Bool {
//  switch s {
//  case "_",
//       ":",
//       "\u{2c00}"..."\u{2fef}",
//       "\u{37f}"..."\u{1fff}",
//       "\u{200c}"..."\u{200d}",
//       "\u{370}"..."\u{37d}",
//       "\u{2070}"..."\u{218f}",
//       "\u{3001}"..."\u{d7ff}",
//       "\u{10000}"..."\u{effff}",
//       "\u{c0}"..."\u{d6}",
//       "\u{d8}"..."\u{f6}",
//       "\u{f8}"..."\u{2ff}",
//       "\u{f900}"..."\u{fdcf}",
//       "\u{fdf0}"..."\u{fffd}",
//       "a"..."z",
//       "A"..."Z":
//    return true
//  default:
//    return false
//  }
//}
//
//func isNameCharacter(_ s: UnicodeScalar) -> Bool {
//  if isNameStartCharacter(s) { return true }
//  switch s {
//  case "-",
//       ".",
//       "\u{203f}"..."\u{2040}",
//       "\u{0300}"..."\u{036f}",
//       "\u{b7}",
//       "0"..."9":
//    return true
//  default:
//    return false
//  }
//}
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
