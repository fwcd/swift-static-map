/// The xy coordinates and zoom level, which uniquely identify a tile.
struct Tile: Hashable {
    /// The xy coordinates of the tile.
    var pos: TileVec<Int>
    /// The map zoom.
    var zoom: UInt8
}
