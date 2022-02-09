import Parsing

struct SingleQuoted<Content: Parser>: Parser
  where
  Content.Input: Collection,
  Content.Input.SubSequence == Content.Input,
  Content.Input.Element == UTF8.CodeUnit
{
  let parser: Delimited<Content, StartsWith<Content.Input>, StartsWith<Content.Input>>

  init(@ParserBuilder _ content: () -> Content) {
    self.parser = .init(
      content: content,
      delimiter: { StartsWith<Content.Input>("'".utf8) }
    )
  }

  func parse(_ input: inout Content.Input) rethrows -> Content.Output {
    try self.parser.parse(&input)
  }
}

extension SingleQuoted: Printer where Content: Printer, Content.Input: AppendableCollection {
  func print(_ output: Content.Output, to input: inout Content.Input) rethrows {
    try self.parser.print(output, to: &input)
  }
}
