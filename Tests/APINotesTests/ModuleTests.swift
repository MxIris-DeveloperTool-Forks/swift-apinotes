import XCTest
import Foundation // JSON(DE|EN)coder

@testable import APINotes

final class ModuleTests: XCTestCase {

  func testDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Name" : "ModuleName",
      "Availability" : "none",
      "AvailabilityMsg" : "Module not available",
      "SwiftInferImportAsMember" : true,
      "Tags" : [{"Name" : "tag"}],
      "Typedefs" : [{"Name" : "typedef"}],
      "Globals" : [{"Name" : "global", "Type" : "char *"}],
      "Functions" : [{"Name" : "function"}],
      "Enumerators" : [{"Name" : "enumerator"}],
      "SwiftVersions": [
        { "Version" : "1", "Tags" : [{"Name" : "nested_tag"}] }
      ]
    }
    """.data(using: .utf8))
    let module = try JSONDecoder().decode(Module.self, from: json)
    XCTAssertEqual(module.name, "ModuleName")
    XCTAssertEqual(module.inferImportAsMember, true)
    XCTAssertEqual(module.availability, .none(message: "Module not available"))

    let items = try XCTUnwrap(module.items)
    XCTAssertEqual(items.tags, [Tag(name: "tag")])
    XCTAssertEqual(items.typedefs, [Typedef(name: "typedef")])
    XCTAssertEqual(items.functions, [Function(name: "function")])
    XCTAssertEqual(items.enumerators, [Enumerator(name: "enumerator")])
    XCTAssertEqual(items.globals, [
      Variable(name: "global", type: "char *")
    ])

    XCTAssertEqual(module.versions, [
      .init(
        version: .init(major: 1),
        items: Module.TopLevelItems(tags: [.init(name: "nested_tag")])
      )
    ])
  }

  func testEncoding() throws {
    let module = Module(
      name: "ModuleName",
      availability: .none(message: "Module not available"),
      inferImportAsMember: true,
      items: Module.TopLevelItems(
        tags: [.init(name: "tag")],
        typedefs: [.init(name: "typedefs")],
        globals: [.init(name: "globals", type: "char *")],
        enumerators: [.init(name: "enumerators")],
        functions: [.init(name: "functions")]
      ),
      versions: [.init(
        version: .init(major: 1),
        items: Module.TopLevelItems(tags: [.init(name: "nested_tag")]))
      ])

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let json = try String(data: encoder.encode(module), encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Availability" : "none",
      "AvailabilityMsg" : "Module not available",
      "Enumerators" : [
        {
          "Name" : "enumerators"
        }
      ],
      "Functions" : [
        {
          "Name" : "functions"
        }
      ],
      "Globals" : [
        {
          "Name" : "globals",
          "Type" : "char *"
        }
      ],
      "Name" : "ModuleName",
      "SwiftInferImportAsMember" : true,
      "SwiftVersions" : [
        {
          "Tags" : [
            {
              "Name" : "nested_tag"
            }
          ],
          "Version" : "1"
        }
      ],
      "Tags" : [
        {
          "Name" : "tag"
        }
      ],
      "Typedefs" : [
        {
          "Name" : "typedefs"
        }
      ]
    }
    """)
  }
}
