import XCTest
import WebP

final class WebPTests: XCTestCase {
  func testDecode() throws {
    let data = try Data(contentsOf: URL(string: "https://raw.githubusercontent.com/webmproject/libwebp-test-data/master/test.webp")!)
    let img = CGImageCreateWithWebPData(data)
    XCTAssertNotNil(img)
  }
}
