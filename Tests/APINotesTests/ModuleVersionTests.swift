import XCTest

@testable import APINotes

final class ModuleVersionTests: XCTestCase {

  func testDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Version" : "1.2.3",
      "Tags" : [{ "Name" : "tag" }],
      "Typedefs" : [{ "Name" : "typedef" }],
      "Globals" : [{ "Name" : "global", "Type" : "char *" }],
      "Functions" : [{ "Name" : "function" }],
      "Enumerators" : [{ "Name" : "enumerator" }]
    }
    """.data(using: .utf8))
    let version = try JSONDecoder().decode(Module.Version.self, from: json)
    XCTAssertEqual(version.version, .init(major: 1, minor: 2, patch: 3))
    XCTAssertEqual(version.items.tags, [Tag(name: "tag")])
    XCTAssertEqual(version.items.typedefs, [Typedef(name: "typedef")])
    XCTAssertEqual(version.items.functions, [Function(name: "function")])
    XCTAssertEqual(version.items.enumerators, [Enumerator(name: "enumerator")])
    XCTAssertEqual(version.items.globals, [
      Variable(name: "global", type: "char *")
    ])
  }

  func testEncoding() throws {
    let version = Module.Version(
      version: .init(major: 1, minor: 2),
      items: Module.TopLevelItems(
        tags: [Tag(name: "tag")],
        typedefs: [Typedef(name: "typedef")],
        globals: [Variable(name: "global", type: "char *")],
        enumerators: [Enumerator(name: "enumerator")],
        functions: [Function(name: "function")]
    ))
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let json = try String(data: encoder.encode(version), encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Enumerators" : [
        {
          "Name" : "enumerator"
        }
      ],
      "Functions" : [
        {
          "Name" : "function"
        }
      ],
      "Globals" : [
        {
          "Name" : "global",
          "Type" : "char *"
        }
      ],
      "Tags" : [
        {
          "Name" : "tag"
        }
      ],
      "Typedefs" : [
        {
          "Name" : "typedef"
        }
      ],
      "Version" : "1.2"
    }
    """)
  }
}
