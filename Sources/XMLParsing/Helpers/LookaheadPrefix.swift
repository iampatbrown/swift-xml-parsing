import Foundation
import Parsing

public struct LookaheadPrefix<Input: Collection>: Parser where Input.SubSequence == Input {
  public let maxLength: Int?
  public let minLength: Int
  public let predicate: (Input) -> Bool

  /// Initializes a parser that consumes a subsequence from the beginning of its input.
  ///
  /// - Parameters:
  ///   - minLength: The minimum number of elements to consume for parsing to be considered
  ///     successful.
  ///   - maxLength: The maximum number of elements to consume before the parser will return its
  ///     output.
  ///   - predicate: A closure that takes an element of the input sequence as its argument and
  ///     returns `true` if the element should be included or `false` if it should be excluded. Once
  ///     the predicate returns `false` it will not be called again.

  @inlinable
  public init(
    minLength: Int = 0,
    maxLength: Int? = nil,
    while predicate: @escaping (Input) -> Bool
  ) {
    self.minLength = minLength
    self.maxLength = maxLength
    self.predicate = predicate
  }

  /// Initializes a parser that consumes a subsequence from the beginning of its input.
  ///
  /// ```swift
  /// try Prefix(2...4, while: \.isNumber).parse("123456")  // "1234"
  /// try Prefix(2...4, while: \.isNumber).parse("123")     // "123"
  ///
  /// try Prefix(2...4, while: \.isNumber).parse("1")
  /// // error: unexpected input
  /// //  --> input:1:1
  /// // 1 | 1
  /// //   |  ^ expected 1 more element satisfying predicate
  /// ```
  ///
  /// - Parameters:
  ///   - length: A closed range that provides a minimum number and maximum of elements to consume
  ///     for parsing to be considered successful.
  ///   - predicate: An optional closure that takes an element of the input sequence as its argument
  ///     and returns `true` if the element should be included or `false` if it should be excluded.
  ///     Once the predicate returns `false` it will not be called again.
  @inlinable
  public init(
    _ length: ClosedRange<Int>,
    while predicate: @escaping (Input) -> Bool
  ) {
    self.minLength = length.lowerBound
    self.maxLength = length.upperBound
    self.predicate = predicate
  }

  /// Initializes a parser that consumes a subsequence from the beginning of its input.
  ///
  /// ```swift
  /// try Prefix(4, while: \.isNumber).parse("123456")  // "1234"
  ///
  /// try Prefix(4, while: \.isNumber).parse("123")
  /// // error: unexpected input
  /// //  --> input:1:1
  /// // 1 | 123
  /// //   |    ^ expected 1 more element satisfying predicate
  /// ```
  ///
  /// - Parameters:
  ///   - length: An exact number of elements to consume for parsing to be considered successful.
  ///   - predicate: An optional closure that takes an element of the input sequence as its argument
  ///     and returns `true` if the element should be included or `false` if it should be excluded.
  ///     Once the predicate returns `false` it will not be called again.
  @inlinable
  public init(
    _ length: Int,
    while predicate: @escaping (Input) -> Bool
  ) {
    self.minLength = length
    self.maxLength = length
    self.predicate = predicate
  }

  /// Initializes a parser that consumes a subsequence from the beginning of its input.
  ///
  /// ``` swift
  /// try Prefix(4..., while: \.isNumber).parse("123456")  // "123456"
  ///
  /// try Prefix(4..., while: \.isNumber).parse("123")
  /// // error: unexpected input
  /// //  --> input:1:1
  /// // 1 | 123
  /// //   |    ^ expected 1 more element satisfying predicate
  /// ```
  ///
  /// - Parameters:
  ///   - length: A partial range that provides a minimum number of elements to consume for
  ///     parsing to be considered successful.
  ///   - predicate: An optional closure that takes an element of the input sequence as its argument
  ///     and returns `true` if the element should be included or `false` if it should be excluded.
  ///     Once the predicate returns `false` it will not be called again.
  @inlinable
  public init(
    _ length: PartialRangeFrom<Int>,
    while predicate: @escaping (Input) -> Bool
  ) {
    self.minLength = length.lowerBound
    self.maxLength = nil
    self.predicate = predicate
  }

  /// Initializes a parser that consumes a subsequence from the beginning of its input.
  ///
  /// ```swift
  /// try Prefix(...4, while: \.isNumber).parse("123456")  // "1234"
  /// try Prefix(...4, while: \.isNumber).parse("123")     // "123"
  /// ```
  ///
  /// - Parameters:
  ///   - length: A partial, inclusive range that provides a maximum number of elements to consume.
  ///   - predicate: An optional closure that takes an element of the input sequence as its argument
  ///     and returns `true` if the element should be included or `false` if it should be excluded.
  ///     Once the predicate returns `false` it will not be called again.
  @inlinable
  public init(
    _ length: PartialRangeThrough<Int>,
    while predicate: @escaping (Input) -> Bool
  ) {
    self.minLength = 0
    self.maxLength = length.upperBound
    self.predicate = predicate
  }

  @inlinable
  @inline(__always)
  public func parse(_ input: inout Input) throws -> Input {
    var prefix = self.maxLength.map(input.prefix) ?? input
    let endIndex = prefix.endOfPrefix(while: self.predicate)
    prefix = prefix[..<endIndex]
    let count = prefix.count
    guard count >= self.minLength
    else { throw ParsingError.failed() }
    input.removeFirst(count)
    return prefix
  }
}

extension LookaheadPrefix: Printer where Input: AppendableCollection {
  @inlinable
  public func print(_ output: Input, to input: inout Input) throws {
    let count = output.count
    guard
      count >= self.minLength,
      self.maxLength.map({ count <= $0 }) ?? true,
      output.endOfPrefix(while: self.predicate) == output.endIndex
    else { throw PrintingError.failed() }

    input.append(contentsOf: output)
  }
}

//
// extension Prefix where Input == Substring {
//  @_disfavoredOverload
//  @inlinable
//  public init(
//    minLength: Int = 0,
//    maxLength: Int? = nil,
//    while predicate: @escaping (Input.Element) -> Bool
//  ) {
//    self.init(minLength: minLength, maxLength: maxLength, while: predicate)
//  }
//
//  @_disfavoredOverload
//  @inlinable
//  public init(
//    _ length: ClosedRange<Int>,
//    while predicate: ((Input.Element) -> Bool)? = nil
//  ) {
//    self.init(length, while: predicate)
//  }
//
//  @_disfavoredOverload
//  @inlinable
//  public init(
//    _ length: Int,
//    while predicate: ((Input.Element) -> Bool)? = nil
//  ) {
//    self.init(length, while: predicate)
//  }
//
//  @_disfavoredOverload
//  @inlinable
//  public init(
//    _ length: PartialRangeFrom<Int>,
//    while predicate: ((Input.Element) -> Bool)? = nil
//  ) {
//    self.init(length, while: predicate)
//  }
//
//  @_disfavoredOverload
//  @inlinable
//  public init(
//    _ length: PartialRangeThrough<Int>,
//    while predicate: ((Input.Element) -> Bool)? = nil
//  ) {
//    self.init(length, while: predicate)
//  }
// }
//
// extension Prefix where Input == Substring.UTF8View {
//  @_disfavoredOverload
//  @inlinable
//  public init(
//    minLength: Int = 0,
//    maxLength: Int? = nil,
//    while predicate: @escaping (Input.Element) -> Bool
//  ) {
//    self.init(minLength: minLength, maxLength: maxLength, while: predicate)
//  }
//
//  @_disfavoredOverload
//  @inlinable
//  public init(
//    _ length: ClosedRange<Int>,
//    while predicate: ((Input.Element) -> Bool)? = nil
//  ) {
//    self.init(length, while: predicate)
//  }
//
//  @_disfavoredOverload
//  @inlinable
//  public init(
//    _ length: Int,
//    while predicate: ((Input.Element) -> Bool)? = nil
//  ) {
//    self.init(length, while: predicate)
//  }
//
//  @_disfavoredOverload
//  @inlinable
//  public init(
//    _ length: PartialRangeFrom<Int>,
//    while predicate: ((Input.Element) -> Bool)? = nil
//  ) {
//    self.init(length, while: predicate)
//  }
//
//  @_disfavoredOverload
//  @inlinable
//  public init(
//    _ length: PartialRangeThrough<Int>,
//    while predicate: ((Input.Element) -> Bool)? = nil
//  ) {
//    self.init(length, while: predicate)
//  }
// }
//
// extension Parsers {
//  public typealias Prefix = Parsing.Prefix  // NB: Convenience type alias for discovery
// }

extension Collection where Self.SubSequence == Self {
  @usableFromInline
  func endOfPrefix(
    while predicate: (Self) -> Bool
  ) -> Self.Index {
    var index = self.startIndex
    while index != self.endIndex, predicate(self[index...]) {
      self.formIndex(after: &index)
    }
    return index
  }
}
