import Foundation
import Parsing

struct PrefixBy: ParserPrinter  {
  let maxLength: Int?
  let minLength: Int
  let computeDistance: (Substring.UTF8View, Substring.UTF8View) throws -> Int

  init(
    minLength: Int = 0,
    maxLength: Int? = nil,
    computeDistance: @escaping (Substring.UTF8View, Substring.UTF8View) throws -> Int
  ) {
    self.minLength = minLength
    self.maxLength = maxLength
    self.computeDistance = computeDistance
  }

  init(
    _ length: ClosedRange<Int>,
    computeDistance: @escaping (Substring.UTF8View, Substring.UTF8View) throws -> Int
  ) {
    self.minLength = length.lowerBound
    self.maxLength = length.upperBound
    self.computeDistance = computeDistance
  }

  init(
    _ length: Int,
    computeDistance: @escaping (Substring.UTF8View, Substring.UTF8View) throws -> Int
  ) {
    self.minLength = length
    self.maxLength = length
    self.computeDistance = computeDistance
  }

  init(
    _ length: PartialRangeFrom<Int>,
    computeDistance: @escaping (Substring.UTF8View, Substring.UTF8View) throws -> Int
  ) {
    self.minLength = length.lowerBound
    self.maxLength = nil
    self.computeDistance = computeDistance
  }

  init(
    _ length: PartialRangeThrough<Int>,
    computeDistance: @escaping (Substring.UTF8View, Substring.UTF8View) throws -> Int
  ) {
    self.minLength = 0
    self.maxLength = length.upperBound
    self.computeDistance = computeDistance
  }

  @inlinable
  @inline(__always)
  public func parse(_ input: inout Substring.UTF8View) throws -> Substring.UTF8View {
    var prefix = self.maxLength.map(input.prefix) ?? input

    var endIndex = prefix.startIndex
    while endIndex != prefix.endIndex {
      let distance = try self.computeDistance(prefix[endIndex...], prefix[..<endIndex])
      guard
        distance > 0,
        prefix.formIndex(&endIndex, offsetBy: distance, limitedBy: prefix.endIndex)
      else { break }
    }

    prefix = prefix[..<endIndex]
    let count = prefix.count
    guard count >= self.minLength
    else {
      let atLeast = self.minLength - count
      throw ParsingError.failed(
        """
        \(self.minLength - count) \(count == 0 ? "" : "more ")element\(atLeast == 1 ? "" : "s")\
        satisfying predicate
        """
      )
    }
    input.removeFirst(count)
    return prefix
  }
  
  func print(_ output: Substring.UTF8View, to input: inout Substring.UTF8View) throws {
    var output = output
    let appended = try self.parse(&output)
    guard output.isEmpty else { throw PrintingError.failed() }
    input.append(contentsOf: appended)
  }
  
}
