//import Foundation
//import Parsing
//
//public struct LookaheadPrefix<Input: Collection>: Parser where Input.SubSequence == Input {
//  public let maxLength: Int?
//  public let minLength: Int
//  public let predicate: (Input) -> Bool
//
//  @inlinable
//  public init(
//    minLength: Int = 0,
//    maxLength: Int? = nil,
//    while predicate: @escaping (Input) -> Bool
//  ) {
//    self.minLength = minLength
//    self.maxLength = maxLength
//    self.predicate = predicate
//  }
//
//  @inlinable
//  public init(
//    _ length: ClosedRange<Int>,
//    while predicate: @escaping (Input) -> Bool
//  ) {
//    self.minLength = length.lowerBound
//    self.maxLength = length.upperBound
//    self.predicate = predicate
//  }
//
//  @inlinable
//  public init(
//    _ length: Int,
//    while predicate: @escaping (Input) -> Bool
//  ) {
//    self.minLength = length
//    self.maxLength = length
//    self.predicate = predicate
//  }
//
//  @inlinable
//  public init(
//    _ length: PartialRangeFrom<Int>,
//    while predicate: @escaping (Input) -> Bool
//  ) {
//    self.minLength = length.lowerBound
//    self.maxLength = nil
//    self.predicate = predicate
//  }
//
//  @inlinable
//  public init(
//    _ length: PartialRangeThrough<Int>,
//    while predicate: @escaping (Input) -> Bool
//  ) {
//    self.minLength = 0
//    self.maxLength = length.upperBound
//    self.predicate = predicate
//  }
//
//  @inlinable
//  @inline(__always)
//  public func parse(_ input: inout Input) throws -> Input {
//    var prefix = self.maxLength.map(input.prefix) ?? input
//    let endIndex = prefix.endOfPrefix(while: self.predicate)
//    prefix = prefix[..<endIndex]
//    let count = prefix.count
//    guard count >= self.minLength
//    else { throw ParsingError.failed() }
//    input.removeFirst(count)
//    return prefix
//  }
//}
//
//extension LookaheadPrefix: Printer where Input: AppendableCollection {
//  @inlinable
//  public func print(_ output: Input, to input: inout Input) throws {
//    let count = output.count
//    guard
//      count >= self.minLength,
//      self.maxLength.map({ count <= $0 }) ?? true,
//      output.endOfPrefix(while: self.predicate) == output.endIndex
//    else { throw PrintingError.failed() }
//
//    input.append(contentsOf: output)
//  }
//}
//
//extension LookaheadPrefix where Input == Substring.UTF8View {
//  @_disfavoredOverload
//  @inlinable
//  public init(
//    minLength: Int = 0,
//    maxLength: Int? = nil,
//    while predicate: @escaping (Input) -> Bool
//  ) {
//    self.init(minLength: minLength, maxLength: maxLength, while: predicate)
//  }
//
//  @_disfavoredOverload
//  @inlinable
//  public init(
//    _ length: ClosedRange<Int>,
//    while predicate: @escaping (Input) -> Bool
//  ) {
//    self.init(length, while: predicate)
//  }
//
//  @_disfavoredOverload
//  @inlinable
//  public init(
//    _ length: Int,
//    while predicate: @escaping (Input) -> Bool
//  ) {
//    self.init(length, while: predicate)
//  }
//
//  @_disfavoredOverload
//  @inlinable
//  public init(
//    _ length: PartialRangeFrom<Int>,
//    while predicate: @escaping (Input) -> Bool
//  ) {
//    self.init(length, while: predicate)
//  }
//
//  @_disfavoredOverload
//  @inlinable
//  public init(
//    _ length: PartialRangeThrough<Int>,
//    while predicate: @escaping (Input) -> Bool
//  ) {
//    self.init(length, while: predicate)
//  }
//}
//
//extension LookaheadPrefix where Input == Substring.UTF8View {
//  @_disfavoredOverload
//  init(
//    minLength: Int = 0,
//    maxLength: Int? = nil,
//    whileFirst predicate: @escaping (UnicodeScalar) -> Bool
//  ) {
//    self.init(
//      minLength: minLength,
//      maxLength: maxLength,
//      while: { $0.startsWithScalar(where: predicate) }
//    )
//  }
//
//  @_disfavoredOverload
//  init(
//    _ length: ClosedRange<Int>,
//    whileFirst predicate: @escaping (UnicodeScalar) -> Bool
//  ) {
//    self.init(length, while: { $0.startsWithScalar(where: predicate) })
//  }
//
//  @_disfavoredOverload
//  init(
//    _ length: Int,
//    whileFirst predicate: @escaping (UnicodeScalar) -> Bool
//  ) {
//    self.init(length, while: { $0.startsWithScalar(where: predicate) })
//  }
//
//  @_disfavoredOverload
//  init(
//    _ length: PartialRangeFrom<Int>,
//    whileFirst predicate: @escaping (UnicodeScalar) -> Bool
//  ) {
//    self.init(length, while: { $0.startsWithScalar(where: predicate) })
//  }
//
//  @_disfavoredOverload
//  init(
//    _ length: PartialRangeThrough<Int>,
//    whileFirst predicate: @escaping (UnicodeScalar) -> Bool
//  ) {
//    self.init(length, while: { $0.startsWithScalar(where: predicate) })
//  }
//}
//
//extension Collection where Self.SubSequence == Self {
//  @usableFromInline
//  func endOfPrefix(while predicate: (Self) -> Bool) -> Self.Index {
//    var index = self.startIndex
//    while index != self.endIndex, predicate(self[index...]) {
//      self.formIndex(after: &index)
//    }
//    return index
//  }
//}
