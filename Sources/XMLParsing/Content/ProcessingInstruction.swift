import Parsing

public struct ProcessingInstruction: Equatable {
  public var target: String
  public var content: String?
}

let processingInstruction = Parse {
  "<?".utf8
  processingInstructionTarget
  Optionally {
    Skip {
      atLeastOneWhiteSpace
    }
    utf8DecodingPrefix(while: isLegalCharacter, orUpTo: "?>".utf8)
  }
  "?>".utf8
}.map(ProcessingInstruction.init)

let processingInstructionTarget = name.filter { $0.lowercased() != "xml" }
