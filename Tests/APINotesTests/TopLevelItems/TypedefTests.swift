import XCTest

@testable import APINotes

final class TypedefTests: XCTestCase {

  // MARK: struct

  func testStructDecoding() throws {
    let json = """
    {
      "Name" : "origin_name",
      "SwiftWrapper" : "struct"
    }
    """
    let data = try XCTUnwrap(json.data(using: .utf8))
    let decoder = JSONDecoder()
    let typedef = try decoder.decode(Typedef.self, from: data)
    XCTAssertEqual(typedef.name, "origin_name")
    XCTAssertEqual(typedef.swiftType, .struct)
    XCTAssertNil(typedef.swiftBridge)
    XCTAssertNil(typedef.errorDomain)
    XCTAssertNil(typedef.swiftName)
    XCTAssertNil(typedef.isSwiftPrivate)
    XCTAssertNil(typedef.availability)
  }

  func testStructEncoding() throws {
    let typedef = Typedef(
      name: "origin_name",
      swiftType: .struct
    )
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let data = try encoder.encode(typedef)
    let json = String(data: data, encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Name" : "origin_name",
      "SwiftWrapper" : "struct"
    }
    """)
  }

  // MARK: enum

  func testEnumDecoding() throws {
    let json = """
    {
      "Name" : "origin_name",
      "SwiftWrapper" : "enum"
    }
    """
    let data = try XCTUnwrap(json.data(using: .utf8))
    let decoder = JSONDecoder()
    let typedef = try decoder.decode(Typedef.self, from: data)
    XCTAssertEqual(typedef.name, "origin_name")
    XCTAssertEqual(typedef.swiftType, .enum)
    XCTAssertNil(typedef.swiftBridge)
    XCTAssertNil(typedef.errorDomain)
    XCTAssertNil(typedef.swiftName)
    XCTAssertNil(typedef.isSwiftPrivate)
    XCTAssertNil(typedef.availability)
  }

  func testEnumEncoding() throws {
    let typedef = Typedef(
      name: "origin_name",
      swiftType: .enum
    )
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let data = try encoder.encode(typedef)
    let json = String(data: data, encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Name" : "origin_name",
      "SwiftWrapper" : "enum"
    }
    """)
  }

  // MARK: none

  func testNoneDecoding() throws {
    let json = """
    {
      "Name" : "origin_name",
      "SwiftWrapper" : "none"
    }
    """
    let data = try XCTUnwrap(json.data(using: .utf8))
    let decoder = JSONDecoder()
    let typedef = try decoder.decode(Typedef.self, from: data)
    XCTAssertEqual(typedef.name, "origin_name")
    XCTAssertEqual(typedef.swiftType, .some(.none))
    XCTAssertNil(typedef.swiftBridge)
    XCTAssertNil(typedef.errorDomain)
    XCTAssertNil(typedef.swiftName)
    XCTAssertNil(typedef.isSwiftPrivate)
    XCTAssertNil(typedef.availability)
  }

  func testNoneEncoding() throws {
    let typedef = Typedef(
      name: "origin_name",
      swiftType: .some(.none)
    )
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let data = try encoder.encode(typedef)
    let json = String(data: data, encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Name" : "origin_name",
      "SwiftWrapper" : "none"
    }
    """)
  }

  // MARK: TypeInfo Coding

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
    let testStruct = try decoder.decode(Tag.self, from: data)
    XCTAssertEqual(testStruct.name, "origin_name")
    XCTAssertEqual(testStruct.swiftBridge, "NonNSSwiftBridge")
    XCTAssertEqual(testStruct.errorDomain, "ErrorDomain")
    XCTAssertNil(testStruct.swiftName)
    XCTAssertNil(testStruct.isSwiftPrivate)
    XCTAssertNil(testStruct.availability)
  }

  func testEncoding() throws {
    let testStruct = Tag(
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
      "NSErrorDomain" : "ErrorDomain",
      "Name" : "origin_name",
      "SwiftBridge" : "NonNSSwiftBridge"
    }
    """)
  }
}
