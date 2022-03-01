import Parsing

public struct PublicIDLiteral: Equatable {
  var rawValue: String
}

private func isPublicIDCharacter(_ s: UnicodeScalar) -> Bool {
  switch s {
  case "_", "-", ",", ";", ":", "!", "?", ".", "'", "(", ")", "@", "*", "/", "\u{20}", "\u{a}",
       "\u{d}", "#", "%", "+", "=", "$", "0"..."9", "a"..."z", "A"..."Z": return true
  default: return false
  }
}

let publicIDLiteral =
  QuotedLiteral(isPublicIDCharacter).map(toPublicIDLiteral)

private let toPublicIDLiteral = Conversions.struct(PublicIDLiteral.init)
