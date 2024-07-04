import Foundation

/// The URL template for a raster tile provider.
/// 
/// See https://wiki.openstreetmap.org/wiki/Raster_tile_providers
struct TileProvider {
    static let osm = Self(urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png")

    /// The template URL for each tile. May use `{x}`, `{y}` and `{z}` as placeholders.
    let urlTemplate: String

    /// The URL for the given tile.
    func url(for tile: Tile) -> URL {
        URL(
            string: urlTemplate
                .replacingOccurrences(of: "{x}", with: String(tile.pos.x))
                .replacingOccurrences(of: "{y}", with: String(tile.pos.y))
                .replacingOccurrences(of: "{z}", with: String(tile.zoom))
        )!
    }
}
