import Foundation
import Geodesy
import StaticMap

guard CommandLine.argc == 2 else {
    print("Usage: \(CommandLine.arguments[0]) <output path>")
    exit(1)
}

let outputPath = CommandLine.arguments[1]

let staticMap = StaticMap(
    center: .init(latitude: 51.5, longitude: 0),
    annotations: [
        .pin(coords: .init(latitude: 51.499, longitude: -0.001)).label("This is a label"),
        .pin(coords: .init(latitude: 51.501, longitude: 0.001)).label("This is another"),
    ]
)
let image = try await staticMap.render()

try image.pngEncoded().write(to: URL(fileURLWithPath: outputPath))
