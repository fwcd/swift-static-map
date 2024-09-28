import Geodesy

extension TileRegion {
    init(_ region: MapRegion) {
        self.init(
            minPos: TilePos(region.coords.minCorner, zoom: region.zoom),
            maxPos: TilePos(region.coords.maxCorner, zoom: region.zoom),
            zoom: region.zoom
        )
    }
}
