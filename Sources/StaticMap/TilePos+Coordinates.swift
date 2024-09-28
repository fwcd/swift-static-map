import Geodesy
import Utils

extension TilePos {
    init(_ coords: Coordinates, zoom: UInt8) {
        self.init(Vec2(coords, zoom: zoom))
    }
}
