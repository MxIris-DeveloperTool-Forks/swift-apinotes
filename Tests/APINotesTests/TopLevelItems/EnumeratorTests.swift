import XCTest

@testable import APINotes

final class EnumeratorTests: XCTestCase {
  func testDecoding() throws {
    let json = """
    {
      "Availability" : "nonswift",
      "AvailabilityMsg" : "Not available to Swift sources",
      "Name" : "origin_name",
      "SwiftName" : "swiftName",
      "SwiftPrivate" : false
    }
    """
    let data = try XCTUnwrap(json.data(using: .utf8))
    let decoder = JSONDecoder()
    let testStruct = try decoder.decode(Enumerator.self, from: data)
    XCTAssertEqual(testStruct.name, "origin_name")
    XCTAssertEqual(testStruct.swiftName, "swiftName")
    XCTAssertEqual(testStruct.isSwiftPrivate, false)
    XCTAssertEqual(testStruct.availability, .nonswift(
      message: "Not available to Swift sources")
    )
  }

  func testEncoding() throws {
    let testStruct = Enumerator(
      name: "origin_name",
      swiftName: "swiftName",
      isSwiftPrivate: false,
      availability: .nonswift(
        message: "Not available to Swift sources"
      )
    )

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let data = try encoder.encode(testStruct)
    let json = String(data: data, encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Availability" : "nonswift",
      "AvailabilityMsg" : "Not available to Swift sources",
      "Name" : "origin_name",
      "SwiftName" : "swiftName",
      "SwiftPrivate" : false
    }
    """)
  }
}
