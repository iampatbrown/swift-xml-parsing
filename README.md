# XMLParsing
Demo project to test the result builder syntax for [swift-parsing](https://github.com/pointfreeco/swift-parsing).

## Usage
A valid XML string can be parsed into a `Document` using `Document.parser()`:

```swift
var input = #"""
<note>
  <to>Tove</to>
  <from>Jani</from>
  <heading>Reminder</heading>
  <body>Don't forget me this weekend!</body>
</note>
"""#[...].utf8

Document.parser().parse(&input) // Document(root: Element(name: "note", content: [...]))
input // => ""
```

XML can also be partially parsed and transformed. Suppose you have the following XML and want to return a `Note`:

```swift
var input = #"""
<body>
  <note>
    <to>Tove</to>
    <from>Jani</from>
    <heading>Reminder</heading>
    <body>Don't forget me this weekend!</body>
  </note>
</body>
"""#[...].utf8

struct Note: Equatable {
  var to: String
  var from: String
  var heading: String
  var body: String
}
```

A custom parser can be made like so:

```swift
let noteParser = Parse {
  SkipUpToElement(named: "note")
  MapElement(named: "note") { element in
    Note(
      to: element.to,
      from: element.from,
      heading: element.heading,
      body: element.body
    )
  }
}
```

And then the input can be parsed to create a new `Note`:

```swift
let note = noteParser.parse(&input)

note // => Note(to: "Tove", ..., body: "Don't forget me this weekend!")
input // => "\n</body>"
```

## Benchmarks
Benchmarks have been included to give a rough comparison to Foundations `XMLDocument(xmlString:)`. They can be run using the `swift-xml-parsing-benchmark` scheme. The following is an example output:

```
running Simple XML - XMLParsing... done! (1608.43 ms)
running Simple XML - Foundation XMLDocument(xmlString:)... done! (1561.32 ms)
running ~2 MB XML - XMLParsing... done! (1518.91 ms)
running ~2 MB XML - Foundation XMLDocument(xmlString:)... done! (2354.01 ms)

name                                            time             std        iterations
--------------------------------------------------------------------------------------
Simple XML - XMLParsing                             17378.000 ns ±  32.51 %      76488
Simple XML - Foundation XMLDocument(xmlString:)     16292.000 ns ±  28.97 %      80040
~2 MB XML - XMLParsing                          126425459.000 ns ±   1.05 %         11
~2 MB XML - Foundation XMLDocument(xmlString:)   85920687.500 ns ±   1.33 %         16
```

## Notes
This was created with a developmental branch of swift-parsing. Changes have been made to the official release and are not reflected in this library. You can see an earlier version of this parser [here](https://github.com/iampatbrown/swift-parsing/blob/parser-builder-pat/Sources/swift-parsing-benchmark/XML/XMLBenchmarks.swift). It has some notes regarding the XML spec and includes Extended Backus-Naur Form (EBNF) notation.
