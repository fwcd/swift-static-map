import Foundation
import Geodesy
import StaticMap

guard CommandLine.argc == 2 else {
    print("Usage: \(CommandLine.arguments[0]) <output path>")
    exit(1)
}

let outputPath = CommandLine.arguments[1]

let staticMap = StaticMap(zoom: 5, center: .init(latitude: 51.5, longitude: 0))
let image = try await staticMap.render { print($0) }

try image.pngEncoded().write(to: URL(fileURLWithPath: outputPath))
