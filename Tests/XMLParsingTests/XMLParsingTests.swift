import Parsing
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

  func testSVG() {
    let input = #"""
    <svg height="100" width="100">
      <circle cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="red" />
      Sorry, your browser does not support inline SVG.
    </svg>
    """#

    let svg = Element(
      name: "svg",
      attributes: [
        .init(name: "height", value: "100"),
        .init(name: "width", value: "100"),
      ],
      content: [
        .element(
          .init(
            name: "circle",
            attributes: [
              .init(name: "cx", value: "50"),
              .init(name: "cy", value: "50"),
              .init(name: "r", value: "40"),
              .init(name: "stroke", value: "black"),
              .init(name: "stroke-width", value: "3"),
              .init(name: "fill", value: "red"),
            ]
          )
        ),
        .string("Sorry, your browser does not support inline SVG."),
      ]
    )

    let document = Document.parser().parse(input)
    XCTAssertEqual(svg, document?.root)
  }

  func testMapElement() {
    let input = #"""
    <note>
    <to>Tove</to>
    <from>Jani</from>
    <heading>Reminder</heading>
    <body>Don't forget me this weekend!</body>
    </note>
    """#

    struct Note: Equatable {
      var to: String
      var from: String
      var heading: String
      var body: String
    }

    let noteParser = MapElement(named: "note") {
      Note(
        to: $0.to,
        from: $0.from,
        heading: $0.heading,
        body: $0.body
      )
    }

    let note = Note(
      to: "Tove",
      from: "Jani",
      heading: "Reminder",
      body: "Don't forget me this weekend!"
    )

    let output = noteParser.parse(input)
    XCTAssertEqual(note, output)
  }

  func testSkipUpToElement() {
    var input = #"""
    <head/>
    <note>
    <to>Tove</to>
    <from>Jani</from>
    <heading>Reminder</heading>
    <body>Don't forget me this weekend!</body>
    </note>
    <tail/>
    """#[...].utf8

    struct Note: Equatable {
      var to: String
      var from: String
      var heading: String
      var body: String
    }

    let noteParser = Parse {
      SkipUpToElement(named: "note")
      MapElement(named: "note") {
        Note(
          to: $0.to,
          from: $0.from,
          heading: $0.heading,
          body: $0.body
        )
      }
    }

    let note = Note(
      to: "Tove",
      from: "Jani",
      heading: "Reminder",
      body: "Don't forget me this weekend!"
    )

    let output = noteParser.parse(&input)
    XCTAssertEqual(note, output)
    XCTAssertTrue(input.starts(with: "\n<tail/>".utf8))
  }
}
