import XCTest
import Foundation // JSON(DE|EN)coder

@testable import APINotes

final class VariableTests: XCTestCase {
  func testDecoding() throws {
    let json = """
    {
      "Name" : "origin_name",
      "Nullability" : "N",
      "Type" : "char *"
    }
    """
    let data = try XCTUnwrap(json.data(using: .utf8))
    let decoder = JSONDecoder()
    let testStruct = try decoder.decode(Variable.self, from: data)
    XCTAssertEqual(testStruct.name, "origin_name")
    XCTAssertEqual(testStruct.type, "char *")
    XCTAssertEqual(testStruct.nullability, .nonnull)
    XCTAssertNil(testStruct.swiftName)
    XCTAssertNil(testStruct.isSwiftPrivate)
    XCTAssertNil(testStruct.availability)
  }

  func testEncoding() throws {
    let testStruct = Variable(
      name: "origin_name",
      type: "char *",
      nullability: .nonnull
    )

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let data = try encoder.encode(testStruct)
    let json = String(data: data, encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Name" : "origin_name",
      "Nullability" : "Nonnull",
      "Type" : "char *"
    }
    """)
  }
}
