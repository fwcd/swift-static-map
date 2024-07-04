import Foundation

/// The URL template for a raster tile provider.
/// 
/// See https://wiki.openstreetmap.org/wiki/Raster_tile_providers
struct TileProvider {
    /// OpenStreetMap's standard tile layer.
    static let standard = Self(urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png")
    /// CyclOSM
    static let cyclOSM = Self(urlTemplate: "https://a.tile-cyclosm.openstreetmap.fr/[cyclosm|cyclosm-lite]/{z}/{x}/{y}.png")
    /// OSM Germany
    static let osmDE = Self(urlTemplate: "https://tile.openstreetmap.de/{z}/{x}/{y}.png")
    /// OSM France, priority given to French names and symbols
    static let osmFR = Self(urlTemplate: "https://a.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png")
    /// Humanitarian map style.
    static let humanitarian = Self(urlTemplate: "https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png")
    /// Artistic black and white map. Seems to require authentication.
    static let stamenToner = Self(urlTemplate: "https://tiles.stadiamaps.com/tiles/stamen_toner/{z}/{x}/{y}.png")
    /// Artistic watercolor-style map. Seems to require authentication.
    static let stamenWatercolor = Self(urlTemplate: "https://tiles.stadiamaps.com/tiles/stamen_watercolor/{z}/{x}/{y}.jpg")

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
