import Parsing

public struct DocumentTypeDeclaration: Equatable {
  public var name: String
  public var externalId: ExternalID?
  public var internalDeclarations: [InternalDeclaration]? // NB: InternalSubset

  public enum InternalDeclaration: Equatable {
    case element(ElementDeclaration)
    case attributeList(AttributeListDeclaration)
    case entity(EntityDeclaration)
    case notation(NotationDeclaration)
    case processingInstruction(ProcessingInstruction)
    case comment(Comment)
    case parameterEntityReference(ParameterEntityReference)
  }
}

let documentTypeDeclaration = Parse {
  "<!DOCTYPE".utf8
  Parse {
    Skip {
      atLeastOneWhiteSpace
    }
    name
    Optionally {
      Skip {
        atLeastOneWhiteSpace
      }
      externalId
    }
    Skip {
      Whitespace()
    }
    Optionally {
      "[".utf8
      Many {
        Skip {
          Whitespace()
        }
        internalDeclaration
        Skip {
          Whitespace()
        }
      }
      "]".utf8
      Skip {
        Whitespace()
      }
    }
  }
  ">".utf8
}

let internalDeclaration = OneOf {
  elementDeclaration.map(DocumentTypeDeclaration.InternalDeclaration.element)
  attributeListDeclaration.map(DocumentTypeDeclaration.InternalDeclaration.attributeList)
  entityDeclaration.map(DocumentTypeDeclaration.InternalDeclaration.entity)
  notationDeclaration.map(DocumentTypeDeclaration.InternalDeclaration.notation)
  processingInstruction.map(DocumentTypeDeclaration.InternalDeclaration.processingInstruction)
  comment.map(DocumentTypeDeclaration.InternalDeclaration.comment)
  parameterEntityReference.map(DocumentTypeDeclaration.InternalDeclaration.parameterEntityReference)
}
