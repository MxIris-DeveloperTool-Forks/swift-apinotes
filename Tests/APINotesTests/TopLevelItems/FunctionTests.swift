import XCTest

@testable import APINotes

final class FunctionTests: XCTestCase {
  func testDecoding() throws {
    let json = """
    {
      "Name" : "function_name",
      "Nullability" : [
        "O",
        "N"
      ],
      "NullabilityOfRet" : "N",
      "Parameters" : [
        {
          "Name" : "input_param1",
          "NoEscape" : true,
          "Position" : 0,
          "Type" : "size_t"
        },
        {
          "NoEscape" : false,
          "Nullability" : "N",
          "Position" : 1
        }
      ],
      "ResultType" : "char *"
    }
    """
    let data = try XCTUnwrap(json.data(using: .utf8))
    let decoder = JSONDecoder()
    let testStruct = try decoder.decode(Function.self, from: data)
    XCTAssertEqual(testStruct.name, "function_name")
    XCTAssertEqual(
      testStruct.nullabilityOfParameters, [.optional, .nonnull]
    )
    XCTAssertEqual(testStruct.resultType, "char *")
    XCTAssertEqual(testStruct.nullabilityOfResult, .nonnull)
    XCTAssertEqual(testStruct.parameters, [
      Function.IndexedParameter(
        position: 0,
        specification: .parameter(Variable(
          name: "input_param1",
          type: "size_t"
        ), isNoneEscaping: true)
      ),
      Function.IndexedParameter(
        position: 1,
        specification: .nullability(.nonnull, isNoneEscaping: false)
      )
    ])
    XCTAssertNil(testStruct.swiftName)
    XCTAssertNil(testStruct.isSwiftPrivate)
    XCTAssertNil(testStruct.availability)
  }

  func testEncoding() throws {
    let testStruct = Function(
      name: "function_name",
      parameters: [
        Function.IndexedParameter(
          position: 0,
          specification: .parameter(Variable(
            name: "input_param1",
            type: "size_t"
          ), isNoneEscaping: true)
        ),
        Function.IndexedParameter(
          position: 1,
          specification: .nullability(.nonnull, isNoneEscaping: false)
        )
      ],
      nullabilityOfParameters: [.optional, .nonnull],
      resultType: "char *",
      nullabilityOfResult: .nonnull
    )

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    let data = try encoder.encode(testStruct)
    let json = String(data: data, encoding: .utf8)
    XCTAssertEqual(json, """
    {
      "Name" : "function_name",
      "Nullability" : [
        "Optional",
        "Nonnull"
      ],
      "NullabilityOfRet" : "Nonnull",
      "Parameters" : [
        {
          "Name" : "input_param1",
          "NoEscape" : true,
          "Position" : 0,
          "Type" : "size_t"
        },
        {
          "NoEscape" : false,
          "Nullability" : "Nonnull",
          "Position" : 1
        }
      ],
      "ResultType" : "char *"
    }
    """)
  }
}
