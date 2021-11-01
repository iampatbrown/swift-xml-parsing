import Parsing

public struct ParameterEntityReference: Equatable {
  var rawValue: String
}

let parameterEntityReference = Parse {
  "%".utf8
  name.map(ParameterEntityReference.init)
  ";".utf8
}
