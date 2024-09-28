import CairoGraphics
import Geodesy
import Utils

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
