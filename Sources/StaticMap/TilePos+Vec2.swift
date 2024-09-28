import Utils

extension TilePos {
    init(_ vec: Vec2<Double>) {
        self.init(
            x: Int(vec.x.rounded(.down)),
            y: Int(vec.y.rounded(.up))
        )
    }
}

extension Vec2 where T == Double {
    init(_ pos: TilePos) {
        self.init(
            x: Double(pos.x),
            y: Double(pos.y)
        )
    }
}
