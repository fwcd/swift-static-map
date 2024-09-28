import CairoGraphics
import Utils

extension StaticMap {
    public func render() async throws -> CairoImage {
        let mapRegion = MapRegion(self)
        let tileRegion = TileRegion(mapRegion)

        let image = try CairoImage(width: size.x, height: size.y)
        let ctx = CairoContext(image: image)

        try await withThrowingTaskGroup(of: CairoImage.self) { group in
            for tile in tileRegion {
                let url = tileProvider.url(for: tile)
                group.addTask {
                    // TODO: Are these guaranteed to be PNGs?
                    try await HTTPRequest(url: url).fetchPNG()
                }
            }

            for try await tileImage in group {
                // TODO
            }
        }

        return image
    }
}
