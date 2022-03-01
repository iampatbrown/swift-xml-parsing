//import Benchmark
//import Foundation
//import Parsing
//import XMLParsing
//
//let noteXml = #"""
//<note>
//<to>Tove</to>
//<from>Jani</from>
//<heading>Reminder</heading>
//<body>Don't forget me this weekend!</body>
//</note>
//"""#
//
//benchmark("XMLParsing") {
//  let document = Document.parser().parse(noteXml)
//  precondition(document!.root.name == "note")
//}
//
//benchmark("XMLDocument(xmlString:)") {
//  let document = try! XMLDocument(xmlString: noteXml)
//  precondition(document.rootElement()!.name == "note")
//}
//
//benchmark("XMLParsing") {
//  let document = Document.parser().parse(xmlInput)
//  precondition(document!.root.name == "edmx:Edmx")
//}
//
//benchmark("XMLDocument(xmlString:)") {
//  let document = try! XMLDocument(xmlString: xmlInput)
//  precondition(document.rootElement()!.name == "edmx:Edmx")
//}
//
//Benchmark.main()

