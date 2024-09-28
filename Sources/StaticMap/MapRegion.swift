import Geodesy

/// A zoomed coordinate region.
struct MapRegion: Hashable {
    /// The coordinate region.
    var coords: CoordinateRegion
    /// The map zoom.
    var zoom: UInt8
}
