import XCTest
import Foundation // JSON(DE|EN)coder

@testable import APINotes

final class NullabilityTests: XCTestCase {

  // MARK: Scalar & Nonnull

  func testScalarDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Nullability" : "Scalar"
    }
    """.data(using: .utf8))
    let entity = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(entity.nullability, .nonnull)
  }

  func testSDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Nullability" : "S"
    }
    """.data(using: .utf8))
    let entity = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(entity.nullability, .nonnull)
  }

  func testNonnullDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Nullability" : "Nonnull"
    }
    """.data(using: .utf8))
    let entity = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(entity.nullability, .nonnull)
  }

  func testNDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Nullability" : "N"
    }
    """.data(using: .utf8))
    let entity = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(entity.nullability, .nonnull)
  }

  func testNonnullEncoding() throws {
    let entity = Test(.nonnull)

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let json = try String(data: encoder.encode(entity), encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Nullability" : "Nonnull"
    }
    """)
  }

  // MARK: Optional

  func testOptionalDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Nullability" : "Optional"
    }
    """.data(using: .utf8))
    let entity = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(entity.nullability, .optional)
  }

  func testODecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Nullability" : "O"
    }
    """.data(using: .utf8))
    let entity = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(entity.nullability, .optional)
  }

  func testOptionalEncoding() throws {
    let entity = Test(.optional)

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let json = try String(data: encoder.encode(entity), encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Nullability" : "Optional"
    }
    """)
  }

  // MARK: Unspecified

  func testUnspecifiedDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Nullability" : "Unspecified"
    }
    """.data(using: .utf8))
    let entity = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(entity.nullability, .unspecified)
  }

  func testUDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Nullability" : "U"
    }
    """.data(using: .utf8))
    let entity = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(entity.nullability, .unspecified)
  }

  func testUnspecifiedEncoding() throws {
    let entity = Test(.unspecified)

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let json = try String(data: encoder.encode(entity), encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Nullability" : "Unspecified"
    }
    """)
  }
}

extension NullabilityTests {
  fileprivate struct Test: Codable {
    enum CodingKeys: String, CodingKey {
      case nullability = "Nullability"
    }
    var nullability: Nullability
    init(_ nullability: Nullability) { self.nullability = nullability }
  }
}
