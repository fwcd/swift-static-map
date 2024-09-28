import Foundation
import Geodesy
import Utils

extension Vec2 where T == Double {
    init(_ coordinates: Coordinates, zoom: UInt8) {
        self.init(
            x: longitudeToX(coordinates.longitude, zoom: zoom),
            y: latitudeToY(coordinates.latitude, zoom: zoom)
        )
    }
}

// Based on https://github.com/danielalvsaaker/staticmap/blob/df88e254be2d929e83ff356c40f9d034a1ed26eb/src/lib.rs

private func longitudeToX(_ longitude: Degrees, zoom: UInt8) -> Double {
    var longitude = longitude.totalDegrees
    if !(-180..<180).contains(longitude) {
        longitude = (longitude + 180).truncatingRemainder(dividingBy: 360) - 180
    }
    return ((longitude + 180) / 360) * pow(2, Double(zoom))
}

private func latitudeToY(_ latitude: Degrees, zoom: UInt8) -> Double {
    var latitude = latitude.totalDegrees
    if !(-90..<90).contains(latitude) {
        latitude = (latitude + 90).truncatingRemainder(dividingBy: 180) - 90
    }
    return ((1 - log(tan(latitude * .pi / 180) + 1 / cos(latitude * .pi / 180)) / .pi) / 2) * pow(2, Double(zoom))
}
