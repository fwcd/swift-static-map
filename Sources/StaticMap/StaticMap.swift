import Utils

public struct StaticMap {
    public var width: Int
    public var height: Int
    public var padding: (Int, Int)
    public var zoom: UInt8?
    public var center: GeoCoordinates?
    public var urlTemplate: String
    public var tileSize: Int

    public init(
        width: Int = 300,
        height: Int = 300,
        padding: (Int, Int) = (0, 0),
        zoom: UInt8? = nil,
        center: GeoCoordinates? = nil,
        urlTemplate: String = "https://a.tile.osm.org/{z}/{x}/{y}.png",
        tileSize: Int = 256
    ) {
        self.width = width
        self.height = height
        self.padding = padding
        self.zoom = zoom
        self.center = center
        self.urlTemplate = urlTemplate
        self.tileSize = tileSize
    }
}
