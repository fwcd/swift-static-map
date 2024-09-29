extension TileRegion: Sequence {
    func makeIterator() -> Iterator {
        Iterator(self)
    }

    struct Iterator: IteratorProtocol {
        private let region: TileRegion
        private var pos: TileVec<Int>
        private var done = false

        init(_ region: TileRegion) {
            self.region = region
            pos = region.minPos

            precondition(region.minPos.x <= region.maxPos.x, "region.minPos.x (\(region.minPos.x)) should be less than or equal to region.maxPos.x \(region.maxPos.x)")
            precondition(region.minPos.y <= region.maxPos.y, "region.minPos.y (\(region.minPos.y)) should be less than or equal to region.maxPos.y \(region.maxPos.y)")
        }

        mutating func next() -> Tile? {
            guard !done else { return nil }
            let tile = Tile(pos: pos, zoom: region.zoom)
            if pos.x == region.maxPos.x {
                if pos.y == region.maxPos.y {
                    done = true
                } else {
                    pos.y += 1
                    pos.x = region.minPos.x
                }
            } else {
                pos.x += 1
            }
            return tile
        }
    }
}
