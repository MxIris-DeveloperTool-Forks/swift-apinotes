import XCTest
import Foundation // JSON(DE|EN)coder

@testable import APINotes

final class TypeInfoTests: XCTestCase {
  func testDecoding() throws {
    let json = """
    {
      "Name" : "origin_name",
      "NSErrorDomain" : "ErrorDomain",
      "SwiftBridge" : "NonNSSwiftBridge"
    }
    """
    let data = try XCTUnwrap(json.data(using: .utf8))
    let decoder = JSONDecoder()
    let testStruct = try decoder.decode(TypeInfo.self, from: data)
    XCTAssertEqual(testStruct.name, "origin_name")
    XCTAssertEqual(testStruct.swiftBridge, "NonNSSwiftBridge")
    XCTAssertEqual(testStruct.errorDomain, "ErrorDomain")
    XCTAssertNil(testStruct.swiftName)
    XCTAssertNil(testStruct.isSwiftPrivate)
    XCTAssertNil(testStruct.availability)
  }

  func testEncoding() throws {
    let testStruct = TypeInfo(
      name: "origin_name",
      swiftBridge: "NonNSSwiftBridge",
      errorDomain: "ErrorDomain"
    )

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let data = try encoder.encode(testStruct)
    let json = String(data: data, encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Name" : "origin_name",
      "NSErrorDomain" : "ErrorDomain",
      "SwiftBridge" : "NonNSSwiftBridge"
    }
    """)
  }
}
