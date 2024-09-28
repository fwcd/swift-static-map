import Foundation
import Geodesy
import Utils

/// The xy coordinates of a tile.
struct TilePos: Hashable {
    /// The x coordinate of a tile.
    var x: Int
    /// The y coordinate of a tile.
    var y: Int
}
