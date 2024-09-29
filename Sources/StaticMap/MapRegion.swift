import Geodesy
import Utils

/// A zoomed coordinate region.
struct MapRegion: Hashable {
    /// The coordinate region.
    var coords: CoordinateRegion
    /// The map zoom.
    var zoom: UInt8

    func pixelSize(tileSize: Int) -> Vec2<Double> {
        let minCorner = TileVec(coords.minCorner, zoom: zoom)
        let maxCorner = TileVec(coords.maxCorner, zoom: zoom)
        // TODO: Is this the right way around or do we have to flip the latitude like in
        // https://github.com/danielalvsaaker/staticmap/blob/master/src/bounds.rs#L154 ?
        return Vec2((maxCorner - minCorner) * Double(tileSize))
    }
}
