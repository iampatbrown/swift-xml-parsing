import Parsing

public struct EntityReference: Equatable {
  var rawValue: String
}

let entityReference = Parse {
  "&".utf8
  name
  ";".utf8
}.map(toEntityReference)

private let toEntityReference = Conversions.struct(EntityReference.init)
