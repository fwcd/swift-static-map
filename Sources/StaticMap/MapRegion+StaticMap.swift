import Geodesy
import Utils

extension MapRegion {
    init(_ staticMap: StaticMap) {
        self = staticMap.mapRegion
    }
}

// Based on https://github.com/danielalvsaaker/staticmap/blob/df88e254be2d929e83ff356c40f9d034a1ed26eb/src/bounds.rs#L152-L205

extension StaticMap {
    fileprivate var mapRegion: MapRegion {
        zoom.map { computeMapRegion(zoom: $0) } ?? inferMapRegion()
    }

    /// Infers a map region by computing a zoom level.
    private func inferMapRegion() -> MapRegion {
        let unpaddedSize = unpaddedSize.asDouble

        for z in (UInt8(0)...17).reversed() {
            let region = computeMapRegion(zoom: z)
            let size = region.pixelSize(tileSize: tileSize)
            guard size.x <= unpaddedSize.x,
                  size.y <= unpaddedSize.y else { continue }
            return region
        }

        return computeMapRegion(zoom: 1)
    }

    /// Computes a map region from the center, zoom and annotations.
    private func computeMapRegion(zoom: UInt8) -> MapRegion {
        let minCorner = Coordinates(latitude: -.infinity, longitude: -.infinity)
        let maxCorner = Coordinates(latitude: .infinity, longitude: .infinity)
        var coords = CoordinateRegion(minCorner: minCorner, maxCorner: maxCorner)

        // TODO: Compute extent of annotations here once added

        guard let center else {
            // TODO: Relax this condition once the support annotations and require either one of them.
            fatalError("Specifying a map center is currently required")
        }

        coords.minCorner = minCorner.min(2 * center - maxCorner)
        coords.maxCorner = maxCorner.max(2 * center - minCorner)

        return MapRegion(coords: coords, zoom: zoom)
    }
}
