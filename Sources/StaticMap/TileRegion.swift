import Utils

/// A region on the tile grid.
struct TileRegion: Hashable {
    /// The minimum tile position of the region.
    var minPos: TileVec<Int>
    /// The maximum tile position of the region.
    var maxPos: TileVec<Int>
    /// The map zoom.
    var zoom: UInt8

    /// The center in (possibly fractional) tile coordinates.
    var center: TileVec<Double> {
        TileVec<Double>(minPos + maxPos) / 2
    }

    /// The number of tiles in the region.
    var count: Int {
        (abs(maxPos.x - minPos.x) + 1) * (abs(maxPos.y - minPos.y) + 1)
    }
}
