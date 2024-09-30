#if os(macOS)

// A simple GUI that interactively renders a static map onto a MapKit view.

import Combine
import Geodesy
import StaticMap
import SwiftUI
import MapKit
import Utils

// Fix a naming conflict with Utils's Binding
private typealias Binding = SwiftUI.Binding

private struct ResizeHandle: View {
    @Binding var offset: Vec2<Double>
    var onSubmit: () -> Void

    var body: some View {
        Image(systemName: "arrowtriangle.left.and.line.vertical.and.arrowtriangle.right.fill")
            .rotationEffect(.degrees(45))
            .offset(x: offset.x, y: offset.y)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = Vec2(x: value.translation.width, y: value.translation.height)
                    }
                    .onEnded { _ in
                        onSubmit()
                        offset = .zero()
                    }
            )
    }
}

private struct MapOptions: Hashable {
    var size: Vec2<Double> = .init(both: 256)
    var opacity: Double = 1.0
    var markOutdated = false
    var resizeOffset: Vec2<Double> = .zero()

    var sizeWithResize: Vec2<Double> {
        size + resizeOffset * 2
    }
}

private struct OverlayPanel: View {
    let errorMessage: String?
    @Binding var mapOptions: MapOptions

    var body: some View {
        VStack {
            if let errorMessage {
                Text("Error while rendering map: \(errorMessage)")
            } else {
                Slider(value: $mapOptions.opacity)
                    .frame(width: 100)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    errorMessage != nil
                        ? AnyShapeStyle(.red.opacity(0.5))
                        : AnyShapeStyle(.regularMaterial)
                )
        )
        .fixedSize()
    }
}

@available(macOS 15.0, *)
private struct ContentView: View {
    @State private var region = MKCoordinateRegion(
        center: .init(latitude: 51.5, longitude: 0.0),
        span: .init(latitudeDelta: 2, longitudeDelta: 2)
    )

    @State private var mapImage: NSImage?
    @State private var mapOptions = MapOptions()
    @State private var errorMessage: String?

    private let mapUpdateSubject = PassthroughSubject<Void, Never>()

    var body: some View {
        GeometryReader { geometry in
            let clipShape = RoundedRectangle(cornerRadius: 10)
                .size(width: mapOptions.sizeWithResize.x, height: mapOptions.sizeWithResize.y, anchor: .center)

            ZStack(alignment: .bottom) {
                Map(initialPosition: .region(region))
                    .onMapCameraChange(frequency: .continuous) { context in
                        let totalRegion = context.region
                        mapOptions.markOutdated = true
                        region = MKCoordinateRegion(
                            center: totalRegion.center,
                            span: MKCoordinateSpan(
                                latitudeDelta: totalRegion.span.latitudeDelta * CGFloat(mapOptions.size.y) / geometry.size.height,
                                longitudeDelta: totalRegion.span.longitudeDelta * CGFloat(mapOptions.size.x) / geometry.size.width
                            )
                        )
                        scheduleStaticMapUpdate()
                    }
                    .overlay {
                        Group {
                            Rectangle()
                                .subtracting(clipShape)
                                .fill(.black.opacity(0.5))
                            if let mapImage {
                                Image(nsImage: mapImage)
                                    .clipShape(clipShape)
                                    .opacity((mapOptions.markOutdated ? 0.3 : 1) * mapOptions.opacity)
                            }
                        }
                        .allowsHitTesting(false)

                        let baseOffset = mapOptions.size / 2 + Vec2(both: 10)
                        ResizeHandle(offset: $mapOptions.resizeOffset) {
                            mapOptions.size += mapOptions.resizeOffset * 2
                        }
                        .offset(x: baseOffset.x, y: baseOffset.y)
                    }
                OverlayPanel(errorMessage: errorMessage, mapOptions: $mapOptions)
                    .padding()
            }
        }
        .task {
            await updateStaticMap()
        }
        .onChange(of: mapOptions.sizeWithResize) {
            scheduleStaticMapUpdate()
        }
        .onReceive(mapUpdateSubject.debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)) {
            Task {
                await updateStaticMap()
            }
        }
    }

    private func scheduleStaticMapUpdate() {
        mapUpdateSubject.send()
    }

    private func updateStaticMap() async {
        do {
            NSLog("Regenerating static map")
            let staticMap = StaticMap(
                size: mapOptions.sizeWithResize.map { Int($0.rounded()) },
                center: Coordinates(region.center),
                span: CoordinateSpan(region.span)
            )
            let cairoImage = try await staticMap.render { logMessage in
                NSLog("%@", logMessage)
            }
            let pngData = try cairoImage.pngEncoded()
            mapImage = NSImage(data: pngData)
            mapOptions.markOutdated = false
            errorMessage = nil
        } catch {
            errorMessage = "\(error)"
        }
    }
}

@available(macOS 15, *)
struct DemoGUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
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
    DemoGUIApp.main()
} else {
    fatalError("The demo GUI requires macOS 15!")
}

#else
fatalError("The demo GUI currently only runs on macOS!")
#endif
