import Foundation
import Geodesy
import StaticMap

guard CommandLine.argc == 2 else {
    print("Usage: \(CommandLine.arguments[0]) <output path>")
    exit(1)
}

let outputPath = CommandLine.arguments[1]

let staticMap = StaticMap(
    zoom: 5,
    annotations: [
        .pin(coords: .init(latitude: 53, longitude: -7)).label("Ireland"),
        .pin(coords: .init(latitude: 51.5, longitude: -2)).label("Britain"),
    ]
)
let image = try await staticMap.render()

try image.pngEncoded().write(to: URL(fileURLWithPath: outputPath))
