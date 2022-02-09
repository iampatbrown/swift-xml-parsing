//import Parsing
//
//public enum CharacterReference: Equatable {
//  case decimal(UnicodeScalar)
//  case hex(UnicodeScalar)
//}
//
//// TODO: Double check older implementation
//let characterReference = AnyParser<Substring.UTF8View, CharacterReference> { input in
//  guard input.starts(with: "&#".utf8) else { return nil }
//  let original = input
//  let radix: UInt32
//  if input.dropFirst(2).starts(with: "x".utf8) {
//    radix = 16
//    input.removeFirst(3)
//  } else {
//    radix = 10
//    input.removeFirst(2)
//  }
//
//  guard
//    let value = UInt32.parser(isSigned: false, radix: radix).parse(&input),
//    let scalar = UnicodeScalar(value),
//    input.starts(with: ";".utf8)
//  else {
//    input = original
//    return nil
//  }
//  return radix == 16 ? .hex(scalar) : .decimal(scalar)
//}
