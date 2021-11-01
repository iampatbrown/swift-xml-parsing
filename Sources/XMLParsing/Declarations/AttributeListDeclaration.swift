import Parsing

public struct AttributeListDeclaration: Equatable {
  public var elementName: String
  public var attributes: [AttributeDefinition]

  public struct AttributeDefinition: Equatable {
    public var name: String
    public var type: AttributeType
    public var defaults: Defaults

    public enum AttributeType: Equatable {
      case string
      case token(Token)
      case `enum`([String])
      case notationEnum([String])

      public enum Token: String {
        case id = "ID"
        case idRef = "IDREF"
        case idRefs = "IDREFS"
        case entity = "ENTITY"
        case entities = "ENTITIES"
        case nameToken = "NMTOKEN"
        case nameTokens = "NMTOKENS"
      }
    }

    public enum Defaults: Equatable {
      case required
      case implied
      case fixed(AttributeValue)
      case `default`(AttributeValue)
    }
  }
}

public typealias AttributeDefinition = AttributeListDeclaration.AttributeDefinition
public typealias AttributeType = AttributeListDeclaration.AttributeDefinition.AttributeType

let attributeListDeclaration = Parse {
  "<!ATTLIST".utf8
  Skip {
    atLeastOneWhiteSpace
  }
  name
  Many {
    attributeDefinition
  }
  Skip {
    Whitespace()
  }
  ">".utf8
}.map(AttributeListDeclaration.init)

let attributeDefinition = Parse {
  Skip {
    atLeastOneWhiteSpace
  }
  name
  Skip {
    atLeastOneWhiteSpace
  }
  type
  Skip {
    atLeastOneWhiteSpace
  }
  defaults
}.map(AttributeDefinition.init)

let type = OneOf {
  stringType
  tokenType
  enumType
  notationEnumType
}

let stringType = "CDATA".utf8.map { AttributeType.string }

// TODO: Maybe there is a different way to do this... using CaseIterable didn't work as well for me
let tokenType = OneOf {
  "ID".utf8.map { AttributeType.Token.id }
  "IDREF".utf8.map { AttributeType.Token.idRef }
  "IDREFS".utf8.map { AttributeType.Token.idRefs }
  "ENTITY".utf8.map { AttributeType.Token.entity }
  "ENTITIES".utf8.map { AttributeType.Token.entities }
  "NMTOKEN".utf8.map { AttributeType.Token.nameToken }
  "NMTOKENS".utf8.map { AttributeType.Token.nameTokens }
}.map(AttributeType.token)

let enumType = Parse {
  "(".utf8
  Many(atLeast: 1) {
    Skip {
      Whitespace()
    }
    nameToken
    Skip {
      Whitespace()
    }
  } separatedBy: {
    "|".utf8
  }
  ")".utf8
}.map(AttributeType.enum)

let notationEnumType = Parse {
  "NOTATION".utf8
  Skip {
    atLeastOneWhiteSpace
  }
  "(".utf8
  Many(atLeast: 1) {
    Skip {
      Whitespace()
    }
    name
    Skip {
      Whitespace()
    }
  } separatedBy: {
    "|".utf8
  }
  ")".utf8
}.map(AttributeType.notationEnum)

let defaults = OneOf {
  "#REQUIRED".utf8.map { AttributeDefinition.Defaults.required }
  "#IMPLIED".utf8.map { AttributeDefinition.Defaults.implied }
  fixedDefaultValue.map(AttributeDefinition.Defaults.fixed)
  attributeValue.map(AttributeDefinition.Defaults.default)
}

let fixedDefaultValue = Parse {
  "#FIXED".utf8
  Skip { atLeastOneWhiteSpace }
  attributeValue
}
