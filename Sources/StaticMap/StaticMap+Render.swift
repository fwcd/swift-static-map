import CairoGraphics
import Utils

extension StaticMap {
    public func render() async throws -> CairoImage {
        let mapRegion = MapRegion(self)
        let tileRegion = TileRegion(mapRegion)

        let image = try CairoImage(width: size.x, height: size.y)
        let ctx = CairoContext(image: image)

        try await withThrowingTaskGroup(of: (Tile, CairoImage).self) { group in
            for tile in tileRegion {
                let url = tileProvider.url(for: tile)
                group.addTask {
                    // TODO: Are these guaranteed to be PNGs?
                    (tile, try await HTTPRequest(url: url).fetchPNG())
                }
            }

            for try await (tile, tileImage) in group {
                ctx.draw(
                    image: tileImage,
                    at: pixelPos(for: tile.pos, in: tileRegion)
                )
            }
        }

        return image
    }

    private func pixelPos(for pos: TilePos, in region: TileRegion) -> Vec2<Double> {
        (Vec2(pos) - region.center) * Double(tileSize) + size.asDouble / 2
    }
}
