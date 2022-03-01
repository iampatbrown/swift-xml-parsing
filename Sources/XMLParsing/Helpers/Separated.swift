import Parsing

public struct Separated<Parsers: Parser>: Parser {
  public let parsers: Parsers

  @inlinable
  public init<P0: Parser, P1: Parser, Separator: Parser>(
    @ParserBuilder _ unseparated: () -> Parsing.Parsers.ZipOO<P0, P1>,
    @ParserBuilder separator: () -> Separator
  ) where Parsers == Parsing.Parsers.ZipOO<Parsing.Parsers.ZipOV<P0, Skip<Separator>>, P1> {
    let unseparated = unseparated()
    let separator = Skip { separator() }
    self.parsers = .init(.init(unseparated.p0, separator), unseparated.p1)
  }

  @inlinable
  public init<P0: Parser, P1: Parser, Separator: Parser>(
    @ParserBuilder _ unseparated: () -> Parsing.Parsers.ZipOO<P0, P1>,
    @ParserBuilder separator: () -> Separator
  ) where Parsers == Parsing.Parsers.ZipOV<Parsing.Parsers.ZipOV<P0, Skip<Separator>>, P1> {
    let unseparated = unseparated()
    let separator = Skip { separator() }
    self.parsers = .init(.init(unseparated.p0, separator), unseparated.p1)
  }

//  @inlinable
//  public init<Upstream, NewOutput>(
//    _ transform: @escaping (Upstream.Output) -> NewOutput,
//    @ParserBuilder with build: () -> Upstream
//  ) where Parsers == Parsing.Parsers.Map<Upstream, NewOutput> {
//    self.parsers = build().map(transform)
//  }
//
//  @inlinable
//  public init<Upstream, Downstream>(
//    _ conversion: Downstream,
//    @ParserBuilder with build: () -> Upstream
//  ) where Parsers == Parsing.Parsers.MapConversion<Upstream, Downstream> {
//    self.parsers = build().map(conversion)
//  }
//
//  @inlinable
//  public init<Upstream, NewOutput>(
//    _ output: NewOutput,
//    @ParserBuilder with build: () -> Upstream
//  ) where Upstream.Output == Void, Parsers == Parsing.Parsers.Map<Upstream, NewOutput> {
//    self.parsers = build().map { output }
//  }

  @inlinable
  public func parse(_ input: inout Parsers.Input) rethrows -> Parsers.Output {
    try self.parsers.parse(&input)
  }
}

extension Separated: Printer where Parsers: Printer {
  @inlinable
  public func print(
    _ output: Parsers.Output,
    to input: inout Parsers.Input
  ) rethrows {
    try self.parsers.print(output, to: &input)
  }
}
