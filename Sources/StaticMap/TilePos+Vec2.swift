import Utils

extension TilePos {
    init(_ vec: Vec2<Double>) {
        self.init(
            x: Int(vec.x.rounded(.down)),
            y: Int(vec.y.rounded(.up))
        )
    }
}
