import Geodesy
import Utils

/// A zoomed coordinate region.
struct MapRegion: Hashable {
    /// The coordinate region.
    var coords: CoordinateRegion
    /// The map zoom.
    var zoom: UInt8

    func pixelSize(tileSize: Int) -> Vec2<Double> {
        let minCorner = TileVec(coords.topLeft, zoom: zoom)
        let maxCorner = TileVec(coords.bottomRight, zoom: zoom)
        assert(minCorner.x <= maxCorner.x)
        assert(minCorner.y <= maxCorner.y)
        return Vec2((maxCorner - minCorner) * Double(tileSize))
    }
}
