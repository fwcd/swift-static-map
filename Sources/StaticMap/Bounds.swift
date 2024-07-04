import Utils

/// Helper struct for converting to pixels.
struct Bounds {
    /// Height of the map in pixels.
    var height: Int
    /// Width of the map in pixels.
    var width: Int
    /// XY coordinates of the map's center.
    var center: Vec2<Double>
    /// Tiles on the X axis.
    var xRange: Range<Int>
    /// Tiles on the Y axis.
    var yRange: Range<Int>
    /// Tile size in pixels.
    var tileSize: Int
    /// Map zoom.
    var zoom: UInt8
}
