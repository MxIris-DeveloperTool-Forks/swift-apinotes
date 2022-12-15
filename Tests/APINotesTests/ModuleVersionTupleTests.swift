import XCTest

@testable import APINotes

final class ModuleVersionTupleTests: XCTestCase {

  func testEquatable() throws {
    XCTAssertEqual(
      Module.Version.VersionTuple(major: 1, minor: nil, patch: nil),
      Module.Version.VersionTuple(major: 1, minor:   0, patch:   0)
    )
    XCTAssertEqual(
      Module.Version.VersionTuple(major: 1, minor: 2, patch: nil),
      Module.Version.VersionTuple(major: 1, minor: 2, patch:   0)
    )
    XCTAssertEqual(
      Module.Version.VersionTuple(major: 1, minor: 2, patch: 3),
      Module.Version.VersionTuple(major: 1, minor: 2, patch: 3)
    )
  }

  func testComparable() throws {
    XCTAssert(
      Module.Version.VersionTuple(major: 1, minor: nil, patch: nil)
      < Module.Version.VersionTuple(major: 2, minor: 0, patch:   0)
    )
    XCTAssert(
      Module.Version.VersionTuple(major: 1, minor: nil, patch: nil)
      < Module.Version.VersionTuple(major: 1, minor: 1, patch:   0)
    )
    XCTAssert(
      Module.Version.VersionTuple(major: 1, minor: 1, patch: nil)
      < Module.Version.VersionTuple(major: 1, minor: 2, patch: 0)
    )
    XCTAssert(
      Module.Version.VersionTuple(major: 1, minor: 2, patch: nil)
      < Module.Version.VersionTuple(major: 1, minor: 2, patch: 1)
    )
    XCTAssert(
      Module.Version.VersionTuple(major: 1, minor: 2, patch: 3)
      < Module.Version.VersionTuple(major: 1, minor: 2, patch: 4)
    )
  }

  // MARK: Major

  func testMajorDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Version" : "1"
    }
    """.data(using: .utf8))
    let test = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(test.version, .init(major: 1))
  }

  func testMajorEncoding() throws {
    let test = Test(.init(major: 1))
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let json = try String(data: encoder.encode(test), encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Version" : "1"
    }
    """)
  }

  // MARK: Minor

  func testMinorDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Version" : "1.2"
    }
    """.data(using: .utf8))
    let test = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(test.version, .init(major: 1, minor: 2))
  }

  func testMinorEncoding() throws {
    let test = Test(.init(major: 1, minor: 2))
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let json = try String(data: encoder.encode(test), encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Version" : "1.2"
    }
    """)
  }

  // MARK: Patch

  func testPatchDecoding() throws {
    let json = try XCTUnwrap("""
    {
      "Version" : "1.2.3"
    }
    """.data(using: .utf8))
    let test = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(test.version, .init(major: 1, minor: 2, patch: 3))
  }

  func testPatchEncoding() throws {
    let test = Test(.init(major: 1, minor: 2, patch: 3))
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let json = try String(data: encoder.encode(test), encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Version" : "1.2.3"
    }
    """)
  }
}

extension ModuleVersionTupleTests {
  fileprivate struct Test: Codable {
    enum CodingKeys: String, CodingKey {
      case version = "Version"
    }
    var version: Module.Version.VersionTuple
    init(_ version: Module.Version.VersionTuple) {
      self.version = version
    }
  }
}
