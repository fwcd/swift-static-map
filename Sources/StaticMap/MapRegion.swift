import Geodesy
import Utils

/// A zoomed coordinate region.
struct MapRegion: Hashable {
    /// The coordinate region.
    var coords: CoordinateRegion
    /// The map zoom.
    var zoom: UInt8

    func pixelSize(tileSize: Int) -> Vec2<Double> {
        let minCorner = Vec2(coords.minCorner, zoom: zoom)
        let maxCorner = Vec2(coords.maxCorner, zoom: zoom)
        // TODO: Is this the right way around or do we have to flip the latitude like in
        // https://github.com/danielalvsaaker/staticmap/blob/master/src/bounds.rs#L154 ?
        return (maxCorner - minCorner) * Double(tileSize)
    }
}
