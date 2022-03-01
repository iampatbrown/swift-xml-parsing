import Parsing

public struct ProcessingInstruction: Equatable {
  public var target: String
  public var content: String?
}

let processingInstructionTarget = name.filter { $0.lowercased() != "xml" }
let processingInctrationContent = Optionally {
  atLeastOneWhiteSpace
  PrefixBy { input, _ in
    guard !input.starts(with: "?>".utf8), let scalar = input.firstScalar, isLegalCharacter(scalar)
    else { return 0 }
    return UTF8.width(scalar)
  }.map(.string)
}

let processingInstruction = Parse {
  "<?".utf8
  processingInstructionTarget
  processingInctrationContent
  "?>".utf8
}.map(toProcessingInstruction)

private let toProcessingInstruction = Conversions.struct(ProcessingInstruction.init)
