import CairoGraphics
import Utils

extension StaticMap {
    public enum RenderError: Error {
        case tooManyTiles(Int)
    }

    public func render(maxTiles: Int = 20, log: ((String) -> Void)? = nil) async throws -> CairoImage {
        let mapRegion = MapRegion(self)
        let tileRegion = TileRegion(mapRegion)

        guard tileRegion.count <= maxTiles else {
            throw RenderError.tooManyTiles(tileRegion.count)
        }

        let image = try CairoImage(width: size.x, height: size.y)
        let ctx = CairoContext(image: image)

        try await withThrowingTaskGroup(of: (Tile, CairoImage).self) { group in
            for (i, tile) in tileRegion.enumerated() {
                let url = tileProvider.url(for: tile)
                log?("Downloading tile \(i) from \(url)...")
                group.addTask {
                    // TODO: Are these guaranteed to be PNGs?
                    (tile, try await HTTPRequest(url: url).fetchPNG())
                }
            }

            for try await (tile, tileImage) in group {
                ctx.draw(
                    image: tileImage,
                    at: pixelPos(for: TileVec<Double>(tile.pos), in: tileRegion)
                )
            }
        }

        return image
    }

    private func pixelPos(for pos: TileVec<Double>, in region: TileRegion) -> Vec2<Double> {
        Vec2(pos - region.center) * Double(tileSize) + size.asDouble / 2
    }
}
