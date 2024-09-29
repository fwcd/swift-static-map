import Geodesy

extension TileRegion {
    init(_ region: MapRegion) {
        self.init(
            minPos: TileVec(region.coords.topLeft, zoom: region.zoom).rounded(.down),
            maxPos: TileVec(region.coords.bottomRight, zoom: region.zoom).rounded(.up),
            zoom: region.zoom
        )
    }
}
