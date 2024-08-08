import XCTest

@testable import APINotes

final class ModuleTupleTests: XCTestCase {

  func testEquatable() throws {
    XCTAssertEqual(
      Module.Version.Tuple(major: 1, minor: nil, patch: nil),
      Module.Version.Tuple(major: 1, minor:   0, patch:   0)
    )
    XCTAssertEqual(
      Module.Version.Tuple(major: 1, minor: 2, patch: nil),
      Module.Version.Tuple(major: 1, minor: 2, patch:   0)
    )
    XCTAssertEqual(
      Module.Version.Tuple(major: 1, minor: 2, patch: 3),
      Module.Version.Tuple(major: 1, minor: 2, patch: 3)
    )
  }

  func testComparable() throws {
    XCTAssertLessThan(
      Module.Version.Tuple(major: 1, minor: nil, patch: nil),
      Module.Version.Tuple(major: 2, minor: 0, patch:   0)
    )
    XCTAssertLessThan(
      Module.Version.Tuple(major: 1, minor: nil, patch: nil),
      Module.Version.Tuple(major: 1, minor: 1, patch:   0)
    )
    XCTAssertLessThan(
      Module.Version.Tuple(major: 1, minor: 1, patch: nil),
      Module.Version.Tuple(major: 1, minor: 2, patch: 0)
    )
    XCTAssertLessThan(
      Module.Version.Tuple(major: 1, minor: 2, patch: nil),
      Module.Version.Tuple(major: 1, minor: 2, patch: 1)
    )
    XCTAssertLessThan(
      Module.Version.Tuple(major: 1, minor: 2, patch: 3),
      Module.Version.Tuple(major: 1, minor: 2, patch: 4)
    )
  }

  // MARK: Major

  func testMajorDecoding() throws {
    let json = try XCTUnwrap(#"{"Version":"1"}"#.data(using: .utf8))
    let test = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(test.version, .init(major: 1))
  }

  func testMajorEncoding() throws {
    let test = Test(.init(major: 1))
    let encoder = JSONEncoder()
    let json = try String(data: encoder.encode(test), encoding: .utf8)
    XCTAssertEqual(json, #"{"Version":"1"}"#)
  }

  // MARK: Minor

  func testMinorDecoding() throws {
    let json = try XCTUnwrap(#"{"Version":"1.2"}"#.data(using: .utf8))
    let test = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(test.version, .init(major: 1, minor: 2))
  }

  func testMinorEncoding() throws {
    let test = Test(.init(major: 1, minor: 2))
    let encoder = JSONEncoder()
    let json = try String(data: encoder.encode(test), encoding: .utf8)
    XCTAssertEqual(json,  #"{"Version":"1.2"}"#)
  }

  // MARK: Patch

  func testPatchDecoding() throws {
    let json = try XCTUnwrap(#"{"Version":"1.2.3"}"#.data(using: .utf8))
    let test = try JSONDecoder().decode(Test.self, from: json)
    XCTAssertEqual(test.version, .init(major: 1, minor: 2, patch: 3))
  }

  func testPatchEncoding() throws {
    let test = Test(.init(major: 1, minor: 2, patch: 3))
    let encoder = JSONEncoder()
    let json = try String(data: encoder.encode(test), encoding: .utf8)
    XCTAssertEqual(json, #"{"Version":"1.2.3"}"#)
  }
}

extension ModuleTupleTests {
  fileprivate struct Test: Codable {
    enum CodingKeys: String, CodingKey {
      case version = "Version"
    }
    var version: Module.Version.Tuple
    init(_ version: Module.Version.Tuple) {
      self.version = version
    }
  }
}
