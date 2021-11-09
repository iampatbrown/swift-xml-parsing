import Parsing

public struct Element: Equatable {
  public var name: String
  public var attributes: [Attribute] = []
  public var content: [Content] = []

  public struct Attribute: Equatable {
    public var name: String
    public var value: AttributeValue

    public init(name: String, value: AttributeValue) {
      self.name = name
      self.value = value
    }

    public init(name: String, value: String) {
      self.name = name
      self.value = .init(rawValue: [.string(value)])
    }
  }

  public enum Content: Equatable {
    case string(String)
    case element(Element)
    case reference(Reference)
    case cdata(CDATA)
    case processingInstruction(ProcessingInstruction)
    case comment(Comment)
  }

  public init(
    name: String,
    attributes: [Element.Attribute] = [],
    content: [Element.Content] = []
  ) {
    self.name = name
    self.attributes = attributes
    self.content = content
  }
}

public typealias Attribute = Element.Attribute

var element: AnyParser<Substring.UTF8View, Element> {
  Parse {
    OneOf {
      nonEmptyElement
      emptyElement
    }
  }.eraseToAnyParser()
}

let content = Many {
  Skip {
    Whitespace()
  }
  OneOf {
    string.map(Element.Content.string)
    Lazy { element }.map(Element.Content.element)
    reference.map(Element.Content.reference)
    cdata.map(Element.Content.cdata)
    processingInstruction.map(Element.Content.processingInstruction)
    comment.map(Element.Content.comment)
  }
  Skip {
    Whitespace()
  }
}

let nonEmptyElement = Parse {
  startTag
  Lazy { content }
  endTagName
}.compactMap { startTag, content, endTagName in
  startTag.name == endTagName ? Element(name: startTag.name, attributes: startTag.attributes, content: content) : nil
}

let emptyElement = OneOf {
  emptyElementTag
  Parse {
    startTag
    endTagName
  }.compactMap { startTag, endTagName in
    startTag.name == endTagName ? startTag : nil
  }
//  }.flatMap { startTag, endTagName in
//    if startTag.name == endTagName {
//      Always(Element(name: startTag.name, attributes: startTag.attributes))
//    }
//  }
}.map { Element(name: $0.name, attributes: $0.attributes) }

let startTag = Parse {
  "<".utf8
  name
  attributes
  Skip {
    Whitespace()
  }
  ">".utf8
}.map { (name: $0, attributes: $1) }

let endTagName = Parse {
  "</".utf8
  name
  Skip {
    Whitespace()
  }
  ">".utf8
}

let emptyElementTag = Parse {
  "<".utf8
  name
  attributes
  Skip {
    Whitespace()
  }
  "/>".utf8
}.map { (name: $0, attributes: $1) }

let attributes = Many {
  Skip {
    atLeastOneWhiteSpace
  }
  attribute
}

let attribute = Parse {
  name
  skipEqualSign
  attributeValue
}.map(Attribute.init)

let string = Parse {
  utf8DecodingPrefix(while: isStringCharacter, orUpTo: "]]>".utf8, trimmingWhiteSpace: true)
//    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    .filter { !$0.isEmpty } // TODO: Double check this...

}

func isStringCharacter(_ s: UnicodeScalar) -> Bool {
  s != "<" && s != "&"
}
