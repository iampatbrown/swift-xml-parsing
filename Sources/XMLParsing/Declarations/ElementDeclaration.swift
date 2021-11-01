import Parsing

public struct ElementDeclaration: Equatable {
  public var name: String
  public var content: ContentSpecification

  public enum ContentSpecification: Equatable {
    case empty
    case any
    case mixed(allowedNames: [String])
    case content(Particle)

    public struct Particle: Equatable {
      public var type: ParticleType
      public var count: Count

      public enum ParticleType: Equatable {
        case named(String)
        case oneOf([Particle]) // should be at least 2
        case ordered([Particle]) // at least one
      }

      public enum Count {
        case one
        case oneOrMore // +
        case zeroOrMore // *
        case zeroOrOne // ?
      }
    }
  }
}

public typealias ContentSpecification = ElementDeclaration.ContentSpecification
public typealias ContentParticle = ElementDeclaration.ContentSpecification.Particle

let elementDeclaration = Parse {
  "<!ELEMENT".utf8
  Parse {
    Skip {
      atLeastOneWhiteSpace
    }
    name
    Skip {
      atLeastOneWhiteSpace
    }
    contentSpecification
    Skip {
      Whitespace()
    }
  }
  ">".utf8
}.map(ElementDeclaration.init)

let contentSpecification = OneOf {
  "EMPTY".utf8.map { ContentSpecification.empty }
  "ANY".utf8.map { ContentSpecification.any }
  mixed.map(ContentSpecification.mixed)
  contentParticle.map(ContentSpecification.content)
}

let mixed = Parse {
  "(".utf8
  Skip {
    Whitespace()
  }
  "#PCDATA".utf8
  allowedNames
  Skip {
    Whitespace()
  }
  ")*".utf8
}

let allowedNames = Many {
  Skip {
    Whitespace()
  }
  "|".utf8
  Skip {
    Whitespace()
  }
  name
}

var contentParticle: AnyParser<Substring.UTF8View, ContentParticle> {
  Parse {
    particleType
    particleCount
  }
  .map(ContentParticle.init)
  .eraseToAnyParser()
}

let particleType = OneOf {
  name.map(ContentParticle.ParticleType.named)
  oneOfContent.map(ContentParticle.ParticleType.oneOf)
  orderedContent.map(ContentParticle.ParticleType.ordered)
}

let oneOfContent = Parse {
  "(".utf8
  Many(atLeast: 2) {
    Skip {
      Whitespace()
    }
    Lazy {
      contentParticle
    }
    Skip {
      Whitespace()
    }
  } separatedBy: {
    "|".utf8
  }
  ")".utf8
}

let orderedContent = Parse {
  "(".utf8
  Many(atLeast: 1) {
    Skip {
      Whitespace()
    }
    Lazy {
      contentParticle
    }
    Skip {
      Whitespace()
    }
  } separatedBy: {
    ",".utf8
  }
  ")".utf8
}

let particleCount = OneOf {
  "?".utf8.map { ContentParticle.Count.zeroOrOne }
  "*".utf8.map { ContentParticle.Count.zeroOrMore }
  "+".utf8.map { ContentParticle.Count.oneOrMore }
  Always(ContentParticle.Count.one)
}
