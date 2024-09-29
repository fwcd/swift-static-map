import XCTest
@testable import StaticMap

final class TileRegionTests: XCTestCase {
    func testSequenceConformance() throws {
        let zoom: UInt8 = 3
        let region = TileRegion(
            minPos: TileVec(x: 2, y: 5),
            maxPos: TileVec(x: 4, y: 6),
            zoom: zoom
        )

        XCTAssertEqual(Array(region), [
            TileVec(x: 2, y: 5),
            TileVec(x: 3, y: 5),
            TileVec(x: 4, y: 5),

            TileVec(x: 2, y: 6),
            TileVec(x: 3, y: 6),
            TileVec(x: 4, y: 6),
        ].map { Tile(pos: $0, zoom: zoom) })

        XCTAssertEqual(Array(region).count, region.count)
    }
}
