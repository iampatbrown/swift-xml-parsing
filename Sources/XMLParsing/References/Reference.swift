import Parsing

public enum Reference: Equatable {
  case entity(EntityReference)
  case character(CharacterReference)
}

let reference = OneOf {
  entityReference
    .map(toReferenceEntity)
  CharacterReferenceParser()
    .map(toReferenceCharacter)
}

private let toReferenceEntity = /Reference.entity
private let toReferenceCharacter = /Reference.character
