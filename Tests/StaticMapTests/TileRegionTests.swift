import XCTest
@testable import StaticMap

final class TileRegionTests: XCTestCase {
    func testSequenceConformance() throws {
        let zoom: UInt8 = 3
        let region = TileRegion(
            minPos: TilePos(x: 2, y: 5),
            maxPos: TilePos(x: 4, y: 6),
            zoom: zoom
        )

        XCTAssertEqual(Array(region), [
            TilePos(x: 2, y: 5),
            TilePos(x: 3, y: 5),
            TilePos(x: 4, y: 5),

            TilePos(x: 2, y: 6),
            TilePos(x: 3, y: 6),
            TilePos(x: 4, y: 6),
        ].map { Tile(pos: $0, zoom: zoom) })
    }
}
