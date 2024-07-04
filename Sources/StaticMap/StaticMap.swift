import CairoGraphics
import Utils

public struct StaticMap {
    private let width: Int
    private let height: Int
    private let padding: (Int, Int)
    private let zoom: UInt8?
    private let center: GeoCoordinates?
    private let tileProvider: TileProvider
    private let tileSize: Int

    public init(
        width: Int = 300,
        height: Int = 300,
        padding: (Int, Int) = (0, 0),
        zoom: UInt8? = nil,
        center: GeoCoordinates? = nil,
        tileProvider: TileProvider = .standard,
        tileSize: Int = 256
    ) {
        self.width = width
        self.height = height
        self.padding = padding
        self.zoom = zoom
        self.center = center
        self.tileProvider = tileProvider
        self.tileSize = tileSize
    }
}
