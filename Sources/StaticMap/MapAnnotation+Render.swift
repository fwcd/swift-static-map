import Geodesy
import Graphics
import Utils

extension MapAnnotation {
    struct RenderParams {
        let pixelPosForCoords: (Coordinates) -> Vec2<Double>
    }

    struct RenderStyle {
        var color: Color = .black
        var fontSize: Double = 12
    }

    @discardableResult
    func render(to ctx: some GraphicsContext, with params: RenderParams, style: RenderStyle = .init()) -> Rectangle<Double> {
        var style = style

        switch self {
        case let .circle(coords: coords, radius: radius):
            let center = params.pixelPosForCoords(coords)
            ctx.draw(ellipse: Ellipse(center: center, radius: Vec2(both: radius), color: style.color, isFilled: true))
            let bounds = Rectangle(topLeft: center - Vec2(both: radius), size: Vec2(both: 2 * radius))
            return bounds

        case let .pin(coords: coords):
            // TODO: Make these customizable via RenderStyle and modifiers in the MapAnnotation API
            let pinHeadRadius = 10.0
            let pinHeight = 20.0

            let pinTargetPos = params.pixelPosForCoords(coords)
            let pinHeadPos = pinTargetPos - Vec2(x: 0, y: pinHeight)

            ctx.draw(line: LineSegment(from: pinHeadPos, to: pinTargetPos, color: .gray))
            ctx.draw(ellipse: Ellipse(center: pinHeadPos, radius: Vec2(both: pinHeadRadius), color: style.color, isFilled: true))

            let bounds = Rectangle(topLeft: pinTargetPos - Vec2(x: pinHeadRadius, y: 0), size: Vec2(x: 2 * pinHeadRadius, y: pinHeadRadius + pinHeight))
            return bounds
        
        case let .label(annotation: annotation, text: text, padding: padding):
            var bounds = annotation.render(to: ctx, with: params, style: style)
            let textPos = bounds.bottomRight + Vec2(x: 0, y: padding)
            ctx.draw(text: Text(text, withSize: style.fontSize, at: textPos, color: style.color))
            // TODO: This is a very crude approximation of the text bounds, can we do better here?
            bounds.size.y += padding + style.fontSize
            return bounds

        case let .fontSize(annotation: annotation, size: size):
            style.fontSize = size
            return annotation.render(to: ctx, with: params, style: style)

        case let .color(annotation: annotation, color: color):
            style.color = color
            return annotation.render(to: ctx, with: params, style: style)
        }
    }
}
