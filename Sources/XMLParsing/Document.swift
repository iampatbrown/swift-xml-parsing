import Parsing

public struct Document: Equatable {
  public var version: String?
  public var characterEncoding: String?
  public var isStandalone: Bool
  public var declaration: DocumentTypeDeclaration?
  public var leadingContent: [Content]?
  public var root: Element
  public var trailingContent: [Content]?

  public enum Content: Equatable {
    case comment(Comment)
    case processingInstruction(ProcessingInstruction)
  }

  public init(
    version: String? = nil,
    characterEncoding: String? = nil,
    isStandalone: Bool,
    declaration: DocumentTypeDeclaration? = nil,
    leadingContent: [Document.Content]? = nil,
    root: Element,
    trailingContent: [Document.Content]? = nil
  ) {
    self.version = version
    self.characterEncoding = characterEncoding
    self.isStandalone = isStandalone
    self.declaration = declaration
    self.leadingContent = leadingContent
    self.root = root
    self.trailingContent = trailingContent
  }

  public static func parser() -> DocumentParser {
    .init()
  }
}

public struct DocumentParser: Parser {
  public init() {}

  public func parse(_ input: inout Substring.UTF8View) -> Document? {
    document.parse(&input)
  }
}

let document = Parse {
  Optionally {
    xmlDeclaration
  }
  documentContent
  Optionally {
    documentTypeDeclaration
  }
  documentContent
  element
  documentContent
}.map { xmlDeclaration, leadingContent1, docTypeDecl, leadingContent2, element, trailingContent in
  Document(
    version: xmlDeclaration?.version,
    characterEncoding: xmlDeclaration?.characterEncoding,
    isStandalone: xmlDeclaration?.isStandalone ?? true,
    declaration: nil,
    leadingContent: leadingContent1 + leadingContent2,
    root: element,
    trailingContent: trailingContent
  )
}

let xmlDeclaration = Parse {
  "<?xml".utf8
  version
  Optionally {
    characterEncoding
  }
  Optionally {
    standaloneDeclaration
  }
  Skip {
    Whitespace()
  }
  "?>".utf8
}.map {
  (version: $0, characterEncoding: $1, isStandalone: $2)
}

let version = Parse {
  Skip {
    atLeastOneWhiteSpace
  }
  "version".utf8
  skipEqualSign
  OneOf {
    doubleQuoted {
      versionNumber
    }
    singleQuoted {
      versionNumber
    }
  }
}

let versionNumber = Parse {
  "1.".utf8
  Int.parser(isSigned: false)
}.map { "1.\($0)" }

let characterEncoding = Parse {
  Skip {
    atLeastOneWhiteSpace
  }
  "encoding".utf8
  skipEqualSign
  OneOf {
    doubleQuoted {
      encodingName
    }
    singleQuoted {
      encodingName
    }
  }
}

let encodingName = Parse {
  utf8DecodingPrefix(1, while: isEncodingNameStartCharacter)
  utf8DecodingPrefix(while: isEncodingNameCharacter)
}.map(+)

func isEncodingNameStartCharacter(_ s: UnicodeScalar) -> Bool {
  "A"..."Z" ~= s || "a"..."z" ~= s
}

func isEncodingNameCharacter(_ s: UnicodeScalar) -> Bool {
  if isEncodingNameStartCharacter(s) { return true }
  switch s {
  case "_", "-", ".", "0"..."9": return true
  default: return false
  }
}

let standaloneDeclaration = Parse {
  Skip {
    atLeastOneWhiteSpace
  }
  "standalone".utf8
  skipEqualSign
  OneOf {
    singleQuoted {
      isStandalone
    }
    doubleQuoted {
      isStandalone
    }
  }
}

let isStandalone = OneOf {
  "yes".utf8.map { true }
  "no".utf8.map { false }
}

enum ParsedDocumentContent {
  case comment(Comment)
  case processingInstruction(ProcessingInstruction)
  case whiteSpace
}

let documentContent = Many(into: [Document.Content]()) {
  parsedDocumentContent
} do: { documentContent, content in
  switch content {
  case let .comment(comment):
    documentContent.append(.comment(comment))
  case let .processingInstruction(processingInstruction):
    documentContent.append(.processingInstruction(processingInstruction))
  case .whiteSpace:
    break
  }
}

let parsedDocumentContent = OneOf {
  comment
    .map(ParsedDocumentContent.comment)
  processingInstruction
    .map(ParsedDocumentContent.processingInstruction)
  Skip {
    atLeastOneWhiteSpace
  }.map { ParsedDocumentContent.whiteSpace }
}
