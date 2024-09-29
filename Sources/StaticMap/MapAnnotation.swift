import Geodesy
import Graphics
import Utils

/// A marker to be drawn on a static map.
public indirect enum MapAnnotation {
    /// A circle of the given radius.
    case circle(coords: Coordinates, radius: Double)
    /// A pin marker.
    case pin(coords: Coordinates)

    /// A modifier attaching the given label.
    case label(annotation: MapAnnotation, text: String, padding: Double)
    /// A modifier setting the font size.
    case fontSize(annotation: MapAnnotation, size: Double)
    /// A modifier setting the color.
    case color(annotation: MapAnnotation, color: Color)

    /// The center coordinates of the marked location.
    var coords: Coordinates {
        switch self {
        case let .circle(coords: coords, radius: _): return coords
        case let .pin(coords: coords): return coords
        case let .label(annotation: annotation, text: _, padding: _): return annotation.coords
        case let .fontSize(annotation: annotation, size: _): return annotation.coords
        case let .color(annotation: annotation, color: _): return annotation.coords
        }
    }

    /// Labels this annotation with the given text.
    public func label(_ text: String, padding: Double = 10) -> Self {
        .label(annotation: self, text: text, padding: padding)
    }

    /// Sets the font size of this annotation.
    public func fontSize(_ size: Double) -> Self {
        .fontSize(annotation: self, size: size)
    }

    /// Sets the foreground color of this annotation.
    public func color(_ color: Color) -> Self {
        .color(annotation: self, color: color)
    }
}
