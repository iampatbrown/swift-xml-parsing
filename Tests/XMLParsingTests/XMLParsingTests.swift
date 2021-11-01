import XCTest
import XMLParsing

final class XMLParsingTests: XCTestCase {
  func testNoteXML() {
    let input = #"""
    <note>
    <to>Tove</to>
    <from>Jani</from>
    <heading>Reminder</heading>
    <body>Don't forget me this weekend!</body>
    </note>
    """#

    let note = Element(
      name: "note",
      content: [
        .element(.init(name: "to", content: [.string("Tove")])),
        .element(.init(name: "from", content: [.string("Jani")])),
        .element(.init(name: "heading", content: [.string("Reminder")])),
        .element(.init(name: "body", content: [.string("Don't forget me this weekend!")])),
      ]
    )

    let document = Document.parser().parse(input)
    XCTAssertEqual(note, document?.root)
  }

  func testMixedContent() {
    let input = #"""
    <book category="web">
      <title lang="en">Learning XML</title>
      <author>Erik T. Ray</author>
      <year>2003</year>
      <price>39.95</price>
      <!--There is some CDATA in the element below me-->
      <html>
        <![CDATA[ <a href="https://www.w3schools.com/xml">Learn XML</a> ]]>
      </html>
    </book>
    """#

    let book = Element(
      name: "book",
      attributes: [.init(name: "category", value: "web")],
      content: [
        .element(
          .init(
            name: "title",
            attributes: [.init(name: "lang", value: "en")],
            content: [.string("Learning XML")]
          )
        ),
        .element(.init(name: "author", content: [.string("Erik T. Ray")])),
        .element(.init(name: "year", content: [.string("2003")])),
        .element(.init(name: "price", content: [.string("39.95")])),
        .comment(.init(rawValue: "There is some CDATA in the element below me")),
        .element(
          .init(
            name: "html",
            content: [.cdata(.init(rawValue: #" <a href="https://www.w3schools.com/xml">Learn XML</a> "#))]
          )
        ),
      ]
    )

    let document = Document.parser().parse(input)
    XCTAssertEqual(book, document?.root)
  }
}
