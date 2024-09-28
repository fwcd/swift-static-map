import Utils

/// A region on the tile grid.
struct TileRegion: Hashable {
    /// The minimum tile position of the region.
    var minPos: TilePos
    /// The maximum tile position of the region.
    var maxPos: TilePos
    /// The map zoom.
    var zoom: UInt8

    /// The center in (possibly fractional) tile coordinates.
    var center: Vec2<Double> {
        (Vec2(minPos) + Vec2(maxPos)) / 2
    }
}
