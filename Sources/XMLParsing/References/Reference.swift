import Parsing

public enum Reference: Equatable {
  case entity(EntityReference)
  case character(CharacterReference)
}

let reference = OneOf {
  entityReference.map(Reference.entity)
  characterReference.map(Reference.character)
}
