import XCTest
import XMLParsing

final class LookaheadPrefixTests: XCTestCase {
  func testPrefixWhile() {
    var input = "42 Hello, world!"[...]
    XCTAssertEqual("42", try LookaheadPrefix(while: { $0.first?.isNumber ?? false }).parse(&input))
    XCTAssertEqual(" Hello, world!", input)
  }

  func testPrefixWhileAlwaysSucceeds() {
    var input = "Hello, world!"[...]
    XCTAssertEqual("", try LookaheadPrefix(while: { $0.first?.isNumber ?? false }).parse(&input))
    XCTAssertEqual("Hello, world!", input)
  }

//

  func testPrefixRangeFromFailure() {
    var input = "42 Hello, world!"[...]
    XCTAssertThrowsError(try LookaheadPrefix(100...) { _ in true }.parse(&input))

    XCTAssertEqual("42 Hello, world!", input)
  }

  func testPrefixRangeFromWhileSuccess() {
    var input = "42 Hello, world!"[...]
    XCTAssertEqual(
      "42",
      try LookaheadPrefix(1..., while: { $0.first?.isNumber ?? false }).parse(&input)
    )
    XCTAssertEqual(" Hello, world!", input)
  }

  func testPrefixRangeThroughWhileSuccess() {
    var input = "42 Hello, world!"[...]
    XCTAssertEqual(
      "42",
      try LookaheadPrefix(...10, while: { $0.first?.isNumber ?? false }).parse(&input)
    )
    XCTAssertEqual(" Hello, world!", input)
  }

  func testPrefixLengthFromWhileSuccess() {
    var input = "42 Hello, world!"[...]
    XCTAssertEqual("4", try LookaheadPrefix(1, while: { $0.first?.isNumber ?? false }).parse(&input))
    XCTAssertEqual("2 Hello, world!", input)
  }
}
