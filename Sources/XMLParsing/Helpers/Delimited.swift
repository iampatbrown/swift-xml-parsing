import Parsing

public struct Delimited<Content: Parser, Initiator: Parser, Terminator: Parser>: Parser
  where
  Initiator.Input == Content.Input,
  Terminator.Input == Content.Input
{
  public let parser: Parsers.ZipVOV<Skip<Initiator>, Content, Skip<Terminator>>

  @inlinable
  public init(
    @ParserBuilder content: () -> Content,
    @ParserBuilder initiator: () -> Initiator,
    @ParserBuilder terminator: () -> Terminator
  ) {
    self.parser = .init(Skip(initiator), content(), Skip(terminator))
  }

  @inlinable
  public init(
    @ParserBuilder content: () -> Content,
    @ParserBuilder delimiter: () -> Initiator
  ) where Initiator == Terminator {
    self.init(
      content: content,
      initiator: delimiter,
      terminator: delimiter
    )
  }

  @inlinable
  public func parse(_ input: inout Content.Input) rethrows -> Content.Output {
    try self.parser.parse(&input)
  }
}

extension Delimited: Printer
  where
  Content: Printer,
  Initiator: Printer,
  Initiator.Output == Void,
  Terminator: Printer,
  Terminator.Output == Void
{
  @inlinable
  public func print(_ output: Content.Output, to input: inout Content.Input) rethrows {
    try self.parser.print(output, to: &input)
  }
}
