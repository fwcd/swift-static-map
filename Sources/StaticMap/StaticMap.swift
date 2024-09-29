import CairoGraphics
import Geodesy
import Utils

/// A parameterized representation of a static map.
public struct StaticMap {
    let size: Vec2<Int>
    let padding: Vec2<Int>
    let zoom: UInt8?
    let center: Coordinates?
    let tileProvider: TileProvider
    let tileSize: Int

    var unpaddedSize: Vec2<Int> {
        size - (2 * padding)
    }

    /// Creates a new static map using the given parameters.
    /// 
    /// - Parameters:
    ///   - size: The size of the static map in pixels
    ///   - padding: The padding on the x and y axis in pixels
    ///   - zoom: The zoom level
    ///   - center: The center of the map as a geographical location
    ///   - tileProvider: The OpenStreetMap tile provider to use
    ///   - tileSize: The tile size in pixels
    public init(
        size: Vec2<Int> = .init(both: 300),
        padding: Vec2<Int> = .zero(),
        zoom: UInt8? = nil,
        center: Coordinates? = nil,
        tileProvider: TileProvider = .standard,
        tileSize: Int = 256
    ) {
        self.size = size
        self.padding = padding
        self.zoom = zoom
        self.center = center
        self.tileProvider = tileProvider
        self.tileSize = tileSize
    }
}
