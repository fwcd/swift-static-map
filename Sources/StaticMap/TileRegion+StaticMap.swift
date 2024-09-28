import Geodesy
import Utils

extension TileRegion {
    init(_ staticMap: StaticMap) {
        let (region, zoom) = staticMap.determineRegionAndZoom()
        self.init(region, zoom: zoom)
    }
}

// Based on https://github.com/danielalvsaaker/staticmap/blob/df88e254be2d929e83ff356c40f9d034a1ed26eb/src/bounds.rs#L152-L205

extension StaticMap {
    fileprivate func determineRegionAndZoom() -> (CoordinateRegion, UInt8) {
        zoom.map { (determineExtent(zoom: $0), $0) } ?? inferRegionAndZoom()
    }

    private func inferRegionAndZoom() -> (CoordinateRegion, UInt8) {
        let unpaddedSize = unpaddedSize.asDouble
        var region: CoordinateRegion!
        var zoom: UInt8 = 1

        for z in (UInt8(0)...17).reversed() {
            region = determineExtent(zoom: z)
            let size = determineSize(region: region, zoom: z)
            guard size.x <= unpaddedSize.x,
                  size.y <= unpaddedSize.y else { continue }
            zoom = z
        }

        return (region, zoom)
    }

    private func determineExtent(zoom: UInt8) -> CoordinateRegion {
        // TODO: Compute extent of annotations here once added

        let minCorner = Coordinates(latitude: -.infinity, longitude: -.infinity)
        let maxCorner = Coordinates(latitude: .infinity, longitude: .infinity)
        var region = CoordinateRegion(minCorner: minCorner, maxCorner: maxCorner)

        if let center {
            region.minCorner = minCorner.min(2 * center - maxCorner)
            region.maxCorner = maxCorner.max(2 * center - minCorner)
        }

        return region
    }

    private func determineSize(region: CoordinateRegion, zoom: UInt8) -> Vec2<Double> {
        let minCorner = Vec2(region.minCorner, zoom: zoom)
        let maxCorner = Vec2(region.maxCorner, zoom: zoom)
        // TODO: Is this the right way around or do we have to flip the latitude like in
        // https://github.com/danielalvsaaker/staticmap/blob/master/src/bounds.rs#L154 ?
        return (maxCorner - minCorner) * Double(tileSize)
    }
}
