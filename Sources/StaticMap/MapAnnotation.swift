import Geodesy
import Graphics
import Utils

/// A marker to be drawn on a static map.
public indirect enum MapAnnotation {
    case circle(coords: Coordinates, radius: Double)
    case pin(coords: Coordinates)

    case label(annotation: MapAnnotation, text: String, padding: Double)
    case fontSize(annotation: MapAnnotation, size: Double)
    case color(annotation: MapAnnotation, color: Color)

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
