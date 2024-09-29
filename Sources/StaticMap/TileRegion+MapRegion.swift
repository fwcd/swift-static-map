import Geodesy

extension TileRegion {
    init(_ region: MapRegion) {
        self.init(
            minPos: TileVec(region.coords.minCorner, zoom: region.zoom).rounded,
            maxPos: TileVec(region.coords.maxCorner, zoom: region.zoom).rounded,
            zoom: region.zoom
        )
    }
}
