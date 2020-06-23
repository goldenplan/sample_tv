import XCTest
@testable import Cartography

final class CartographyTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Cartography().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
