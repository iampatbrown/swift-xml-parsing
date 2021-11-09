// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-xml-parsing",
  products: [
    .library(
      name: "XMLParsing",
      targets: ["XMLParsing"]
    ),
  ],
  dependencies: [
    .package(name: "Benchmark", url: "https://github.com/google/swift-benchmark", from: "0.1.1"),
    .package(url: "https://github.com/pointfreeco/swift-parsing", .branch("parser-builder")),
    .package(url: "https://github.com/MaxDesiatov/XMLCoder.git", from: "0.13.0"),
  ],
  targets: [
    .target(
      name: "XMLParsing",
      dependencies: [
        .product(name: "Parsing", package: "swift-parsing"),
      ]
    ),
    .testTarget(
      name: "XMLParsingTests",
      dependencies: [
        "XMLParsing",
        .product(name: "Parsing", package: "swift-parsing"),
      ]
    ),
    .executableTarget(
      name: "swift-xml-parsing-benchmark",
      dependencies: [
        "XMLParsing",
        .product(name: "Benchmark", package: "Benchmark"),
        .product(name: "Parsing", package: "swift-parsing"),
        .product(name: "XMLCoder", package: "XMLCoder"),
      ]
    ),
  ]
)
