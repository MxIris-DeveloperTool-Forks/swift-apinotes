import XCTest
import Foundation // JSON(DE|EN)coder

@testable import APINotes

final class FunctionParameterTests: XCTestCase {
  func testDecoding() throws {
    let json = """
    {
      "Name" : "origin_name",
      "NoEscape" : true,
      "Type" : "char *"
    }
    """
    let data = try XCTUnwrap(json.data(using: .utf8))
    let decoder = JSONDecoder()
    let testStruct = try decoder.decode(Function.Parameter.self, from: data)
    XCTAssertEqual(testStruct.name, "origin_name")
    XCTAssertEqual(testStruct.type, "char *")
    XCTAssertEqual(testStruct.isNoneEscaping, true)
    XCTAssertNil(testStruct.swiftName)
    XCTAssertNil(testStruct.isSwiftPrivate)
    XCTAssertNil(testStruct.availability)
    XCTAssertNil(testStruct.nullability)
  }

  func testEncoding() throws {
    let testStruct = Function.Parameter(
      name: "origin_name",
      type: "char *",
      isNoneEscaping: true
    )

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let data = try encoder.encode(testStruct)
    let json = String(data: data, encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Name" : "origin_name",
      "NoEscape" : true,
      "Type" : "char *"
    }
    """)
  }
}
