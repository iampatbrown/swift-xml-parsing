import Parsing

struct SingleQuoted<Content: Parser>: Parser
where Content.Input == Substring.UTF8View {
  let parser: Delimited<Content, StartsWith<Substring.UTF8View>, StartsWith<Substring.UTF8View>>

  init(@ParserBuilder _ content: () -> Content) {
    self.parser = .init(
      content: content,
      delimiter: { StartsWith<Substring.UTF8View>([39] /* "'".utf8 */ ) }
    )
  }

  func parse(_ input: inout Substring.UTF8View) rethrows -> Content.Output {
    try self.parser.parse(&input)
  }
}

extension SingleQuoted: Printer where Content: Printer {
  func print(_ output: Content.Output, to input: inout Substring.UTF8View) rethrows {
    try self.parser.print(output, to: &input)
  }
}
