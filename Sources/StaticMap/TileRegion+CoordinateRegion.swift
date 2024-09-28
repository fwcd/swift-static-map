import Geodesy

extension TileRegion {
    init(_ region: CoordinateRegion, zoom: UInt8) {
        self.init(
            minPos: TilePos(region.minCorner, zoom: zoom),
            maxPos: TilePos(region.maxCorner, zoom: zoom),
            zoom: zoom
        )
    }
}
