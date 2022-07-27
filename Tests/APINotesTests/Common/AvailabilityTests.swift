import XCTest
import Foundation // JSON(DE|EN)coder

@testable import APINotes

final class AvailabilityTests: XCTestCase {

  // MARK: macOS

  func testMacOSDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Availability" : "OSX",
      "AvailabilityMsg" : "Message must be ignored"
    }
    """.data(using: .utf8))
    let entity = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(entity.availability, .macOS)
  }

  func testMacOSEncoding() throws {
    let entity = Test(.macOS)

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let json = try String(data: encoder.encode(entity), encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Availability" : "OSX"
    }
    """)
  }

  // MARK: iOS

  func testiOSDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Availability" : "iOS",
      "AvailabilityMsg" : "Message must be ignored"
    }
    """.data(using: .utf8))
    let entity = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(entity.availability, .iOS)
  }

  func testiOSEncoding() throws {
    let entity = Test(.iOS)

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let json = try String(data: encoder.encode(entity), encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Availability" : "iOS"
    }
    """)
  }

  // MARK: available

  func testAvailableDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Availability" : "available",
      "AvailabilityMsg" : "Message must be ignored"
    }
    """.data(using: .utf8))
    let entity = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(entity.availability, .available)
  }

  func testAvailableEncoding() throws {
    let entity = Test(.available)

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let json = try String(data: encoder.encode(entity), encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Availability" : "available"
    }
    """)
  }

  // MARK: none

  func testNoneWithMessageDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Availability" : "none",
      "AvailabilityMsg" : "Not available to any sources"
    }
    """.data(using: .utf8))
    let entity = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(entity.availability, .none(
      message: "Not available to any sources")
    )
  }

  func testNoneWithMessageEncoding() throws {
    let entity = Test(.none(
        message: "Not available to any sources"
    ))

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let json = try String(data: encoder.encode(entity), encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Availability" : "none",
      "AvailabilityMsg" : "Not available to any sources"
    }
    """)
  }

  func testNoneWithoutMessageDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Availability" : "none"
    }
    """.data(using: .utf8))
    let entity = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(entity.availability, .none(message: nil))
  }

  func testNoneWithoutEncoding() throws {
    let entity = Test(.none(message: nil))

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let json = try String(data: encoder.encode(entity), encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Availability" : "none"
    }
    """)
  }

  // MARK: nonswift

  func testNonSwiftWithMessageDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Availability" : "nonswift",
      "AvailabilityMsg" : "Not available to Swift sources"
    }
    """.data(using: .utf8))
    let entity = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(entity.availability, .nonswift(
      message: "Not available to Swift sources")
    )
  }

  func testNonSwiftWithMessageEncoding() throws {
    let entity = Test(.nonswift(
      message: "Not available to Swift sources"
    ))

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let json = try String(data: encoder.encode(entity), encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Availability" : "nonswift",
      "AvailabilityMsg" : "Not available to Swift sources"
    }
    """)
  }

  func testNonSwiftWithoutMessageDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Availability" : "nonswift"
    }
    """.data(using: .utf8))
    let entity = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(entity.availability, .nonswift(message: nil))
  }

  func testNonSwiftWithoutEncoding() throws {
    let entity = Test(.nonswift(message: nil))

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let json = try String(data: encoder.encode(entity), encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Availability" : "nonswift"
    }
    """)
  }
}

extension AvailabilityTests {
  fileprivate struct Test: Codable {
    var availability: Availability
    init(_ availability: Availability) { self.availability = availability }
    init(from decoder: Decoder) throws {
      availability = try XCTUnwrap(Availability.decodeAvailabilityIfPresent(
        from: decoder
      ))
    }
    func encode(to encoder: Encoder) throws {
      try availability.encode(to: encoder)
    }
  }
}
