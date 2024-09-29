import Geodesy

extension TileRegion {
    init(_ region: MapRegion) {
        self.init(
            minPos: TileVec(region.coords.topLeft, zoom: region.zoom).rounded,
            maxPos: TileVec(region.coords.bottomRight, zoom: region.zoom).rounded,
            zoom: region.zoom
        )
    }
}
