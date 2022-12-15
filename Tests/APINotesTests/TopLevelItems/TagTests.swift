import XCTest

@testable import APINotes

final class TagTests: XCTestCase {

  // MARK: open

  func testOpenIsFlagDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "EnumExtensibility" : "open",
      "FlagEnum" : true,
      "Name" : "origin_name"
    }
    """.data(using: .utf8))
    let tag = try JSONDecoder().decode(Tag.self, from: json)
    XCTAssertEqual(tag.name, "origin_name")
    XCTAssertEqual(tag.enumerationKind, .open(isFlagEnum: true))
    XCTAssertNil(tag.swiftBridge)
    XCTAssertNil(tag.errorDomain)
    XCTAssertNil(tag.swiftName)
    XCTAssertNil(tag.isSwiftPrivate)
    XCTAssertNil(tag.availability)
  }

  func testOpenIsFlagEncoding() throws {
    let tag = Tag(
      name: "origin_name",
      enumerationKind: .open(isFlagEnum: true)
    )
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let json = try String(data: encoder.encode(tag), encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "EnumExtensibility" : "open",
      "FlagEnum" : true,
      "Name" : "origin_name"
    }
    """)
  }

  func testOpenIsNotFlagDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "EnumExtensibility" : "open",
      "FlagEnum" : false,
      "Name" : "origin_name"
    }
    """.data(using: .utf8))
    let tag = try JSONDecoder().decode(Tag.self, from: json)
    XCTAssertEqual(tag.name, "origin_name")
    XCTAssertEqual(tag.enumerationKind, .open(isFlagEnum: false))
    XCTAssertNil(tag.swiftBridge)
    XCTAssertNil(tag.errorDomain)
    XCTAssertNil(tag.swiftName)
    XCTAssertNil(tag.isSwiftPrivate)
    XCTAssertNil(tag.availability)
  }

  func testOpenIsNotFlagEncoding() throws {
    let tag = Tag(
      name: "origin_name",
      enumerationKind: .open(isFlagEnum: false)
    )
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let json = try String(data: encoder.encode(tag), encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "EnumExtensibility" : "open",
      "FlagEnum" : false,
      "Name" : "origin_name"
    }
    """)
  }

  // MARK: closed

  func testClosedIsFlagDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "EnumExtensibility" : "closed",
      "FlagEnum" : true,
      "Name" : "origin_name"
    }
    """.data(using: .utf8))
    let tag = try JSONDecoder().decode(Tag.self, from: json)
    XCTAssertEqual(tag.name, "origin_name")
    XCTAssertEqual(tag.enumerationKind, .closed(isFlagEnum: true))
    XCTAssertNil(tag.swiftBridge)
    XCTAssertNil(tag.errorDomain)
    XCTAssertNil(tag.swiftName)
    XCTAssertNil(tag.isSwiftPrivate)
    XCTAssertNil(tag.availability)
  }

  func testClosedIsFlagEncoding() throws {
    let tag = Tag(
      name: "origin_name",
      enumerationKind: .closed(isFlagEnum: true)
    )
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let json = try String(data: encoder.encode(tag), encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "EnumExtensibility" : "closed",
      "FlagEnum" : true,
      "Name" : "origin_name"
    }
    """)
  }

  func testClosedIsNotFlagDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "EnumExtensibility" : "closed",
      "FlagEnum" : false,
      "Name" : "origin_name"
    }
    """.data(using: .utf8))
    let tag = try JSONDecoder().decode(Tag.self, from: json)
    XCTAssertEqual(tag.name, "origin_name")
    XCTAssertEqual(tag.enumerationKind, .closed(isFlagEnum: false))
    XCTAssertNil(tag.swiftBridge)
    XCTAssertNil(tag.errorDomain)
    XCTAssertNil(tag.swiftName)
    XCTAssertNil(tag.isSwiftPrivate)
    XCTAssertNil(tag.availability)
  }

  func testClosedIsNotFlagEncoding() throws {
    let tag = Tag(
      name: "origin_name",
      enumerationKind: .closed(isFlagEnum: false)
    )
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let json = try String(data: encoder.encode(tag), encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "EnumExtensibility" : "closed",
      "FlagEnum" : false,
      "Name" : "origin_name"
    }
    """)
  }

  // MARK: none

  func testNoneDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "EnumExtensibility" : "none",
      "FlagEnum" : true,
      "Name" : "origin_name"
    }
    """.data(using: .utf8))
    let tag = try JSONDecoder().decode(Tag.self, from: json)
    XCTAssertEqual(tag.name, "origin_name")
    XCTAssertEqual(tag.enumerationKind, .some(.none))
    XCTAssertNil(tag.swiftBridge)
    XCTAssertNil(tag.errorDomain)
    XCTAssertNil(tag.swiftName)
    XCTAssertNil(tag.isSwiftPrivate)
    XCTAssertNil(tag.availability)
  }

  func testNoneEncoding() throws {
    let tag = Tag(
      name: "origin_name",
      enumerationKind: .some(.none)
    )
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let json = try String(data: encoder.encode(tag), encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "EnumExtensibility" : "none",
      "Name" : "origin_name"
    }
    """)
  }

  // MARK: convenience

  func testCFEnumDecoding() throws {
    let json = """
    {
      "Name" : "origin_name",
      "EnumKind" : "CFEnum"
    }
    """
    let data = try XCTUnwrap(json.data(using: .utf8))
    let decoder = JSONDecoder()
    let tag = try decoder.decode(Tag.self, from: data)
    XCTAssertEqual(tag.name, "origin_name")
    XCTAssertEqual(tag.enumerationKind, .open(isFlagEnum: false))
    XCTAssertNil(tag.swiftBridge)
    XCTAssertNil(tag.errorDomain)
    XCTAssertNil(tag.swiftName)
    XCTAssertNil(tag.isSwiftPrivate)
    XCTAssertNil(tag.availability)
  }

  func testNSEnumDecoding() throws {
    let json = """
    {
      "Name" : "origin_name",
      "EnumKind" : "NSEnum"
    }
    """
    let data = try XCTUnwrap(json.data(using: .utf8))
    let decoder = JSONDecoder()
    let tag = try decoder.decode(Tag.self, from: data)
    XCTAssertEqual(tag.name, "origin_name")
    XCTAssertEqual(tag.enumerationKind, .open(isFlagEnum: false))
    XCTAssertNil(tag.swiftBridge)
    XCTAssertNil(tag.errorDomain)
    XCTAssertNil(tag.swiftName)
    XCTAssertNil(tag.isSwiftPrivate)
    XCTAssertNil(tag.availability)
  }

  func testCFClosedEnumDecoding() throws {
    let json = """
    {
      "Name" : "origin_name",
      "EnumKind" : "CFClosedEnum"
    }
    """
    let data = try XCTUnwrap(json.data(using: .utf8))
    let decoder = JSONDecoder()
    let tag = try decoder.decode(Tag.self, from: data)
    XCTAssertEqual(tag.name, "origin_name")
    XCTAssertEqual(tag.enumerationKind, .closed(isFlagEnum: false))
    XCTAssertNil(tag.swiftBridge)
    XCTAssertNil(tag.errorDomain)
    XCTAssertNil(tag.swiftName)
    XCTAssertNil(tag.isSwiftPrivate)
    XCTAssertNil(tag.availability)
  }

  func testNSClosedEnumDecoding() throws {
    let json = """
    {
      "Name" : "origin_name",
      "EnumKind" : "NSClosedEnum"
    }
    """
    let data = try XCTUnwrap(json.data(using: .utf8))
    let decoder = JSONDecoder()
    let tag = try decoder.decode(Tag.self, from: data)
    XCTAssertEqual(tag.name, "origin_name")
    XCTAssertEqual(tag.enumerationKind, .closed(isFlagEnum: false))
    XCTAssertNil(tag.swiftBridge)
    XCTAssertNil(tag.errorDomain)
    XCTAssertNil(tag.swiftName)
    XCTAssertNil(tag.isSwiftPrivate)
    XCTAssertNil(tag.availability)
  }

  func testCFOptionsDecoding() throws {
    let json = """
    {
      "Name" : "origin_name",
      "EnumKind" : "CFOptions"
    }
    """
    let data = try XCTUnwrap(json.data(using: .utf8))
    let decoder = JSONDecoder()
    let tag = try decoder.decode(Tag.self, from: data)
    XCTAssertEqual(tag.name, "origin_name")
    XCTAssertEqual(tag.enumerationKind, .open(isFlagEnum: true))
    XCTAssertNil(tag.swiftBridge)
    XCTAssertNil(tag.errorDomain)
    XCTAssertNil(tag.swiftName)
    XCTAssertNil(tag.isSwiftPrivate)
    XCTAssertNil(tag.availability)
  }

  func testNSOptionsDecoding() throws {
    let json = """
    {
      "Name" : "origin_name",
      "EnumKind" : "NSOptions"
    }
    """
    let data = try XCTUnwrap(json.data(using: .utf8))
    let decoder = JSONDecoder()
    let tag = try decoder.decode(Tag.self, from: data)
    XCTAssertEqual(tag.name, "origin_name")
    XCTAssertEqual(tag.enumerationKind, .open(isFlagEnum: true))
    XCTAssertNil(tag.swiftBridge)
    XCTAssertNil(tag.errorDomain)
    XCTAssertNil(tag.swiftName)
    XCTAssertNil(tag.isSwiftPrivate)
    XCTAssertNil(tag.availability)
  }

  // MARK: Decoding Priority

  func testPrioritizeFullDefinitionDecoding() throws {
    let json = """
    {
      "EnumExtensibility" : "closed",
      "FlagEnum" : true,
      "EnumKind" : "CFEnum",
      "Name" : "origin_name"
    }
    """
    let data = try XCTUnwrap(json.data(using: .utf8))
    let decoder = JSONDecoder()
    let tag = try decoder.decode(Tag.self, from: data)
    XCTAssertEqual(tag.name, "origin_name")
    XCTAssertEqual(tag.enumerationKind, .closed(isFlagEnum: true))
    XCTAssertNil(tag.swiftBridge)
    XCTAssertNil(tag.errorDomain)
    XCTAssertNil(tag.swiftName)
    XCTAssertNil(tag.isSwiftPrivate)
    XCTAssertNil(tag.availability)
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
      "Name" : "origin_name",
      "NSErrorDomain" : "ErrorDomain",
      "SwiftBridge" : "NonNSSwiftBridge"
    }
    """)
  }
}


