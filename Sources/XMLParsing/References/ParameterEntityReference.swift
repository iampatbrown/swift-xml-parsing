import Parsing

public struct ParameterEntityReference: Equatable {
  var rawValue: String
}

let parameterEntityReference = Parse {
  "%".utf8
  name
  ";".utf8
}.map(toParameterEntityReference)

private let toParameterEntityReference = Conversions.struct(ParameterEntityReference.init)
