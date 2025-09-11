
import XCTest
@testable import URLManager
final class URLManagerTests:XCTestCase{
    func testBuild() throws{
        let u=try URLBuilder(base:URL(string:"https://api.com")!).adding(path:"/v1").build()
        XCTAssertEqual(u.absoluteString,"https://api.com/v1")
    }
}
