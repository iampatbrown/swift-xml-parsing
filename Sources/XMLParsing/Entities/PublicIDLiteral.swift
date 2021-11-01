import Parsing

public struct PublicIDLiteral: Equatable {
  var rawValue: String
}

let publicIDLiteral = quotedLiteral(isPublicIDCharacter)
  .map(PublicIDLiteral.init)

func isPublicIDCharacter(_ s: UnicodeScalar) -> Bool {
  switch s {
  case "_", "-", ",", ";", ":", "!", "?", ".", "'", "(", ")", "@", "*", "/", "\u{20}", "\u{a}", "\u{d}", "#", "%", "+",
       "=", "$", "0"..."9", "a"..."z", "A"..."Z": return true
  default: return false
  }
}
