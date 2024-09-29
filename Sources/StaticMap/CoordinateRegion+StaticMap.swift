import Geodesy
import Utils

private let defaultSpan = CoordinateSpan(
    latitudeDelta: .init(degrees: 0.01),
    longitudeDelta: .init(degrees: 0.01)
)

extension CoordinateRegion {
    init(_ staticMap: StaticMap) {
        if let center = staticMap.center {
            self.init(center: center, span: staticMap.span ?? defaultSpan)
        } else if !staticMap.annotations.isEmpty {
            let positions = staticMap.annotations.map(\.coords)
            let padding = Coordinates(latitude: 0.001, longitude: 0.001)
            let minPos = positions.reduce1 { $0.min($1) }! - padding
            let maxPos = positions.reduce1 { $0.max($1) }! + padding
            self.init(minCorner: minPos, maxCorner: maxPos)
        } else {
            fatalError("Either a center or annotations are required for a static map")
        }
    }
}
