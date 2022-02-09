extension Unicode.UTF8 {
  static func decodeOne<Bytes: Sequence>(_ bytes: Bytes) -> Unicode.Scalar?
  where Bytes.Element == UTF8.CodeUnit {
    var utf8Decoder = Unicode.UTF8()
    var bytesIterator = bytes.makeIterator()

    switch utf8Decoder.decode(&bytesIterator) {
    case let .scalarValue(scalar):
      return scalar
    default:
      return nil
    }
  }
}
