import CairoGraphics
import Foundation
import Geodesy
import Utils

extension StaticMap {
    /// An error during rendering of a static map.
    public enum RenderError: Error {
        case invalidTileProvider(String)
        case tooManyTiles(Int)
    }

    /// Renders the static map to an in-memory image.
    /// 
    /// - Parameters:
    ///   - maxTiles: The maximum number of tiles to allow.
    ///   - log: Optionally a logging function.
    /// - Throws: ``RenderError`` if the static map cannot be rendered from this configuration
    /// - Returns: The rendered image
    public func render(
        maxTiles: Int = 20,
        log: ((String) -> Void)? = nil,
        isolation: isolated (any Actor)? = #isolation
    ) async throws -> CairoImage {
        guard tileProvider.urlTemplate.hasSuffix(".png") else {
            throw RenderError.invalidTileProvider("Only PNG tile providers are currently supported")
        }

        let mapRegion = try MapRegion(self)
        let tileRegion = TileRegion(mapRegion)

        func pixelPosFor(tilePos: TileVec<Double>) -> Vec2<Double> {
            let tileVecFromCenter = tilePos - TileVec(mapRegion.coords.center, zoom: mapRegion.zoom)
            return (Vec2(tileVecFromCenter) * Double(tileSize) + size.asDouble / 2).map { $0.rounded(.down) }
        }

        func pixelPosFor(coords: Coordinates) -> Vec2<Double> {
            let tilePos = TileVec(coords, zoom: mapRegion.zoom)
            return pixelPosFor(tilePos: tilePos)
        }

        guard tileRegion.count <= maxTiles else {
            throw RenderError.tooManyTiles(tileRegion.count)
        }

        let image = try CairoImage(width: size.x, height: size.y)
        let ctx = CairoContext(image: image)

        try await withThrowingTaskGroup(of: (Tile, Data).self) { group in
            for (i, tile) in tileRegion.enumerated() {
                let url = tileProvider.url(for: tile)
                log?("Downloading tile \(i) from \(url)...")
                group.addTask {
                    // TODO: Are these guaranteed to be PNGs?
                    (tile, try await HTTPRequest(url: url).run())
                }
            }

            for try await (tile, rawTileImage) in group {
                ctx.draw(
                    image: try CairoImage(pngData: rawTileImage),
                    at: pixelPosFor(tilePos: TileVec<Double>(tile.pos))
                )
            }
        }

        for annotation in annotations {
            annotation.render(to: ctx, with: MapAnnotation.RenderParams(
                pixelPosForCoords: pixelPosFor(coords:)
            ))
        }

        return image
    }
}
