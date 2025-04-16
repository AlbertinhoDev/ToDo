import XCTest
@testable import ToDoList

import Foundation

final class DecoderServiceTests: XCTestCase {
    private let json = """
        {
            "name": "Name",
            "age": 21
        }
        """
    private var data: Data!
    private var decoderService: DecoderService!

    override func setUp() {
        super.setUp()
        data = json.data(using: .utf8)!
        decoderService = DecoderService()
    }

    override func tearDown() {
        decoderService = nil
        data = nil
        super.tearDown()
    }

    func testSuccessfulDecoding() {
        struct Model: Decodable {
            let name: String
            let age: Int
        }

        XCTAssertNoThrow(
            try {
                let model: Model = try decoderService.decode(data: data)
                XCTAssertEqual(model.name, "Name")
                XCTAssertEqual(model.age, 21)
            }(),
            "Decode is successful"
        )
    }

    func testUnsuccessfulDecoding() {
        struct Model: Decodable {
            let title: String
            let subtitle: String
        }

        XCTAssertThrowsError(
            try {
                try decoderService.decode(data: data) as Model
            }(),
            "Decode is unsuccessful"
        )
    }
}
