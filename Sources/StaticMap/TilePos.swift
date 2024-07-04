import Foundation
import Utils

/// The xy coordinates of a tile.
struct TilePos: Hashable {
    /// The x coordinate of a tile.
    var x: Int
    /// The y coordinate of a tile.
    var y: Int
}

extension TilePos {
    init(_ coords: GeoCoordinates, zoom: UInt8) {
        self.init(
            x: Int(longitudeToX(coords.longitude, zoom: zoom).rounded(.down)),
            y: Int(latitudeToY(coords.latitude, zoom: zoom).rounded(.up))
        )
    }
}

// Based on https://github.com/danielalvsaaker/staticmap/blob/df88e254be2d929e83ff356c40f9d034a1ed26eb/src/lib.rs

func longitudeToX(_ longitude: Double, zoom: UInt8) -> Double {
    var longitude = longitude
    if !(-180..<180).contains(longitude) {
        longitude = (longitude + 180).truncatingRemainder(dividingBy: 360) - 180
    }
    return ((longitude + 180) / 360) * pow(2, Double(zoom))
}

func latitudeToY(_ latitude: Double, zoom: UInt8) -> Double {
    var latitude = latitude
    if !(-90..<90).contains(latitude) {
        latitude = (latitude + 90).truncatingRemainder(dividingBy: 180) - 90
    }
    return ((1 - log(tan(latitude * .pi / 180) + 1 / cos(latitude * .pi / 180)) / .pi) / 2) * pow(2, Double(zoom))
}
