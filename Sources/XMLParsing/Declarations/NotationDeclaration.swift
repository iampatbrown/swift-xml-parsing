import Parsing

public struct NotationDeclaration: Equatable {
  public var name: String
  public var id: ID

  public enum ID: Equatable {
    case external(ExternalID)
    case `public`(PublicIDLiteral)
  }
}

private let notationDeclarationId = OneOf {
  externalId.map(toExternalId)
  publicID.map(toPublicId)
}

let notationDeclaration = Delimited {
  name
  atLeastOneWhiteSpace
  notationDeclarationId
} initiator: {
  "<!NOTATION".utf8
  atLeastOneWhiteSpace
} terminator: {
  ">".utf8
}
.map(toNotationDeclaraton)

private let publicID = Parse {
  "PUBLIC".utf8
  atLeastOneWhiteSpace
  publicIDLiteral
}

private let toExternalId: CasePath<NotationDeclaration.ID, ExternalID> = /NotationDeclaration.ID
  .external
private let toPublicId: CasePath<NotationDeclaration.ID, PublicIDLiteral> = /NotationDeclaration.ID
  .public
private let toNotationDeclaraton: Conversions.Structure<
  (String, NotationDeclaration.ID),
  NotationDeclaration
> = Conversions.struct(NotationDeclaration.init)
