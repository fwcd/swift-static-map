import Utils

extension TileVec {
    init(_ vec: Vec2<Element>) {
        self.init(
            x: vec.x,
            y: vec.y
        )
    }
}

extension Vec2 {
    init(_ pos: TileVec<T>) {
        self.init(
            x: pos.x,
            y: pos.y
        )
    }
}
