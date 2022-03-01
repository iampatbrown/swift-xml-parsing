import Parsing

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

extension Substring.UTF8View {
  var firstScalar: UnicodeScalar? { UTF8.decodeOne(self) }

  func startsWithScalar(where predicate: (UnicodeScalar) -> Bool) -> Bool {
    self.firstScalar.map(predicate) ?? false
  }
}

extension Conversions {
  struct UInt32ToUnicodeScalar: Conversion {
    func apply(_ input: UInt32) throws -> UnicodeScalar {
      guard let output = UnicodeScalar(input)
      else { throw ConvertingError.failed() }
      return output
    }

    func unapply(_ output: UnicodeScalar) -> UInt32 {
      output.value
    }
  }
}

extension Conversion where Self == Conversions.UInt32ToUnicodeScalar {
  static var unicodeScalar: Self { .init() }
}
