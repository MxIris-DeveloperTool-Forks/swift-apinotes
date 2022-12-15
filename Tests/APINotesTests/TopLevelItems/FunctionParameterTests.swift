import XCTest

@testable import APINotes

final class FunctionParameterTests: XCTestCase {
  func testDecoding() throws {
    let json = """
    {
      "Name" : "origin_name",
      "NoEscape" : true,
      "Position" : 0,
      "Type" : "char *"
    }
    """
    let data = try XCTUnwrap(json.data(using: .utf8))
    let decoder = JSONDecoder()
    let testStruct = try decoder.decode(Function.IndexedParameter.self, from: data)
    XCTAssertEqual(testStruct.position, 0)
    switch testStruct.specification {
    case let .parameter(variable, isNoneEscaping):
      XCTAssertEqual(variable.name, "origin_name")
      XCTAssertEqual(variable.type, "char *")
      XCTAssertNil(variable.swiftName)
      XCTAssertNil(variable.isSwiftPrivate)
      XCTAssertNil(variable.availability)
      XCTAssertNil(variable.nullability)
      XCTAssertEqual(isNoneEscaping, true)
    default:
      XCTFail("Variable decoding must succeed")
    }
  }

  func testEncoding() throws {
    let testStruct = Function.IndexedParameter(
      position: 0,
      specification: .parameter(Variable(
        name: "origin_name",
        type: "char *"
      ), isNoneEscaping: true)
    )

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let data = try encoder.encode(testStruct)
    let json = String(data: data, encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Name" : "origin_name",
      "NoEscape" : true,
      "Position" : 0,
      "Type" : "char *"
    }
    """)
  }
}
