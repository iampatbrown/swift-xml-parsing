import Parsing

public enum ExternalID: Equatable {
  case system(SystemLiteral)
  case `public`(PublicIDLiteral, SystemLiteral)
}

private let toExternalSystemId: CasePath<ExternalID, SystemLiteral> = /ExternalID.system
private let toExternalPublicId: CasePath<ExternalID, (PublicIDLiteral, SystemLiteral)> = /ExternalID
  .public

let externalId = OneOf {
  Parse {
    "SYSTEM".utf8
    atLeastOneWhiteSpace
    systemLiteral
  }.map(toExternalSystemId)

  Parse {
    "PUBLIC".utf8
    atLeastOneWhiteSpace
    publicIDLiteral
    atLeastOneWhiteSpace
    systemLiteral
  }.map(toExternalPublicId)
}
