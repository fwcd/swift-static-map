import Geodesy
import Utils

extension MapRegion {
    init(_ staticMap: StaticMap) throws {
        let coords = try CoordinateRegion(staticMap)
        let zoom = staticMap.zoom
            ?? inferZoomLevel(
                coords: coords,
                targetSize: staticMap.unpaddedSize.asDouble,
                tileSize: staticMap.tileSize
            )
        self.init(coords: coords, zoom: zoom)
    }
}

// Based on https://github.com/danielalvsaaker/staticmap/blob/df88e254be2d929e83ff356c40f9d034a1ed26eb/src/bounds.rs#L152-L205

/// Infers a zoom level.
private func inferZoomLevel(coords: CoordinateRegion, targetSize: Vec2<Double>, tileSize: Int) -> UInt8 {
    for zoom in (UInt8(0)...17).reversed() {
        let region = MapRegion(coords: coords, zoom: zoom)
        let size = region.pixelSize(tileSize: tileSize)
        guard size.x <= targetSize.x,
              size.y <= targetSize.y else { continue }
        return zoom
    }

    return 1
}
