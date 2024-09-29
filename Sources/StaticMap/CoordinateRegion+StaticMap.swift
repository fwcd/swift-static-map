import Geodesy
import Utils

private let defaultSpan = CoordinateSpan(
    latitudeDelta: .init(degrees: 0.01),
    longitudeDelta: .init(degrees: 0.01)
)

extension CoordinateRegion {
    init(_ staticMap: StaticMap) {
        guard let center = staticMap.center else {
            // TODO: Relax this condition once we support annotations
            fatalError("A center is currently required for static maps")
        }

        self.init(center: center, span: defaultSpan)
    }
}
