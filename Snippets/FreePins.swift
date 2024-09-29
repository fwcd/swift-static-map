import Foundation
import Geodesy
import StaticMap

guard CommandLine.argc == 2 else {
    print("Usage: \(CommandLine.arguments[0]) <output path>")
    exit(1)
}

let outputPath = CommandLine.arguments[1]

let staticMap = StaticMap(
    annotations: [
        .pin(coords: .init(latitude: 58.8, longitude: -3.3)),
        .pin(coords: .init(latitude: 54.2, longitude: -4.5)),
        .pin(coords: .init(latitude: 52.5, longitude: -1.9)),
        .pin(coords: .init(latitude: 51.1, longitude: -2.3)),
        .pin(coords: .init(latitude: 51.5, longitude: 0.0)),
    ]
)
let image = try await staticMap.render()

try image.pngEncoded().write(to: URL(fileURLWithPath: outputPath))
