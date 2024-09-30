#if os(macOS)

// A simple GUI that interactively renders a static map onto a MapKit view.

import Combine
import Geodesy
import StaticMap
import SwiftUI
import MapKit
import Utils

@available(macOS 15, *)
struct DemoGUI: App {
    @State private var region = MKCoordinateRegion(
        center: .init(latitude: 51.5, longitude: 0.0),
        span: .init(latitudeDelta: 2, longitudeDelta: 2)
    )

    @State private var staticMapImage: NSImage?
    @State private var staticMapOutdated = false
    @State private var staticMapOpacity = 1.0
    @State private var mapSize: Vec2<Double> = .init(both: 256)
    @State private var mapResizeOffset: Vec2<Double> = .zero()
    @State private var errorMessage: String?

    private var mapSizeWithResizing: Vec2<Double> {
        mapSize + mapResizeOffset * 2
    }

    private let staticMapUpdatePublisher = PassthroughSubject<Void, Never>()

    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
                let clipShape = RoundedRectangle(cornerRadius: 10)
                    .size(width: mapSizeWithResizing.x, height: mapSizeWithResizing.y, anchor: .center)

                ZStack(alignment: .bottom) {
                    Map(initialPosition: .region(region))
                        .onMapCameraChange(frequency: .continuous) { context in
                            let totalRegion = context.region
                            staticMapOutdated = true
                            region = MKCoordinateRegion(
                                center: totalRegion.center,
                                span: MKCoordinateSpan(
                                    latitudeDelta: totalRegion.span.latitudeDelta * CGFloat(mapSize.y) / geometry.size.height,
                                    longitudeDelta: totalRegion.span.longitudeDelta * CGFloat(mapSize.x) / geometry.size.width
                                )
                            )
                            staticMapUpdatePublisher.send()
                        }
                        .overlay {
                            Group {
                                Rectangle()
                                    .subtracting(clipShape)
                                    .fill(.black.opacity(0.5))
                                if let staticMapImage {
                                    Image(nsImage: staticMapImage)
                                        .clipShape(clipShape)
                                        .opacity((staticMapOutdated ? 0.3 : 1) * staticMapOpacity)
                                }
                            }
                            .allowsHitTesting(false)

                            let resizeHandleOffset = mapSizeWithResizing / 2 + Vec2(both: 10)
                            Image(systemName: "arrowtriangle.left.and.line.vertical.and.arrowtriangle.right.fill")
                                .rotationEffect(.degrees(45))
                                .offset(x: resizeHandleOffset.x, y: resizeHandleOffset.y)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            mapResizeOffset = Vec2(x: value.translation.width, y: value.translation.height)
                                            staticMapUpdatePublisher.send()
                                        }
                                        .onEnded { _ in
                                            mapSize += mapResizeOffset * 2
                                            mapResizeOffset = .zero()
                                        }
                                )
                        }
                    VStack {
                        if let errorMessage {
                            Text("Error while rendering map: \(errorMessage)")
                        } else {
                            Slider(value: $staticMapOpacity)
                                .frame(width: 100)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(errorMessage != nil ? AnyShapeStyle(.red.opacity(0.5)) : AnyShapeStyle(.regularMaterial))
                    )
                    .fixedSize()
                    .padding()
                }
            }
            .onAppear {
                regenerateStaticMap()
            }
            .onReceive(staticMapUpdatePublisher.debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)) {
                regenerateStaticMap()
            }
        }
    }

    private func regenerateStaticMap() {
        Task {
            do {
                NSLog("Regenerating static map")
                let staticMap = StaticMap(
                    size: mapSizeWithResizing.map { Int($0.rounded()) },
                    center: Coordinates(region.center),
                    span: CoordinateSpan(region.span)
                )
                let cairoImage = try await staticMap.render { logMessage in
                    NSLog("%@", logMessage)
                }
                let pngData = try cairoImage.pngEncoded()
                staticMapImage = NSImage(data: pngData)
                staticMapOutdated = false
                errorMessage = nil
            } catch {
                errorMessage = "\(error)"
            }
        }
    }
}

// Some boilerplate to make the app run properly without a bundle
// https://forums.swift.org/t/is-it-possible-to-developer-a-swiftui-app-using-only-swiftpm/71755/2
DispatchQueue.main.async {
    NSApp.setActivationPolicy(.regular)
    NSApp.activate(ignoringOtherApps: true)
    if let window = NSApp.windows.first {
        window.makeKeyAndOrderFront(nil)
        window.collectionBehavior = .canJoinAllSpaces
    }
}

if #available(macOS 15, *) {
    DemoGUI.main()
} else {
    fatalError("The demo GUI requires macOS 15!")
}

#else
fatalError("The demo GUI currently only runs on macOS!")
#endif
