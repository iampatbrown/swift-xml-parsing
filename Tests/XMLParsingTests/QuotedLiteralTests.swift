import XCTest
@testable import XMLParsing

final class QuotedLiteralTests: XCTestCase {
  func testSingleQuotes() {
    var input = "'Hello', world!"[...].utf8
    XCTAssertEqual("Hello", try QuotedLiteral().parse(&input))
    XCTAssertEqual(", world!", Substring(input))
  }
  
  func testDoubleQuotes() {
    var input = "\"Hello\", world!"[...].utf8
    XCTAssertEqual("Hello", try QuotedLiteral().parse(&input))
    XCTAssertEqual(", world!", Substring(input))
  }
  
  
  func testSingleQuotesFail() {
    var input = "'Hello, world!"[...].utf8
    XCTAssertThrowsError(try QuotedLiteral().parse(&input))
    XCTAssertEqual("'Hello, world!", Substring(input))
  }
  
  
  func testDoubleQuotesFail() {
    var input = "\"Hello, world!"[...].utf8
    XCTAssertThrowsError(try QuotedLiteral().parse(&input))
    XCTAssertEqual("\"Hello, world!", Substring(input))
  }
  
  func testSingleQuotesIsLiteral() {
    var input = "'Hello', world!"[...].utf8
    XCTAssertEqual("Hello", try QuotedLiteral { $0.isASCII }.parse(&input))
    XCTAssertEqual(", world!", Substring(input))
  }
  
  func testDoubleQuotesIsLiteral() {
    var input = "\"Hello\", world!"[...].utf8
    XCTAssertEqual("Hello", try QuotedLiteral { $0.isASCII }.parse(&input))
    XCTAssertEqual(", world!", Substring(input))
  }
  
  func testSingleQuotesIsLiteralFail() {
    var input = "'Hello', world!"[...].utf8
    XCTAssertThrowsError(try QuotedLiteral { _ in false }.parse(&input))
    XCTAssertEqual("'Hello', world!", Substring(input))
  }
  
  
  func testDoubleQuotesIsLiteralFail() {
    var input = "\"Hello\", world!"[...].utf8
    XCTAssertThrowsError(try QuotedLiteral { _ in false }.parse(&input))
    XCTAssertEqual("\"Hello\", world!", Substring(input))
  }
  
  
}
