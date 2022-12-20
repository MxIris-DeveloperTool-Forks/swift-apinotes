import XCTest

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
    XCTAssertEqual(entity.nullability, .scalar(representation: .long))
  }

  func testSDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Nullability" : "S"
    }
    """.data(using: .utf8))
    let entity = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(entity.nullability, .scalar(representation: .short))
  }

  func testScalarEncoding() throws {
    let entity = Test(.scalar(representation: .long))

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let json = try String(data: encoder.encode(entity), encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Nullability" : "Scalar"
    }
    """)
  }

  // MARK: Optional

  func testNonnullDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Nullability" : "Nonnull"
    }
    """.data(using: .utf8))
    let entity = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(entity.nullability, .nonnull(representation: .long))
  }

  func testNDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Nullability" : "N"
    }
    """.data(using: .utf8))
    let entity = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(entity.nullability, .nonnull(representation: .short))
  }

  func testNonnullEncoding() throws {
    let entity = Test(.nonnull(representation: .long))

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
    XCTAssertEqual(entity.nullability, .optional(representation: .long))
  }

  func testODecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Nullability" : "O"
    }
    """.data(using: .utf8))
    let entity = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(entity.nullability, .optional(representation: .short))
  }

  func testOptionalEncoding() throws {
    let entity = Test(.optional(representation: .long))

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
    XCTAssertEqual(entity.nullability, .unspecified(representation: .long))
  }

  func testUDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Nullability" : "U"
    }
    """.data(using: .utf8))
    let entity = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(entity.nullability, .unspecified(representation: .short))
  }

  func testUnspecifiedEncoding() throws {
    let entity = Test(.unspecified(representation: .long))

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
