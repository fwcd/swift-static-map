#if os(macOS)

// A simple GUI that interactively renders a static map onto a MapKit view.

import Combine
import Geodesy
import StaticMap
import SwiftUI
import MapKit

private let mapSize = 256

@available(macOS 15, *)
struct DemoGUI: App {
    @State private var region = MKCoordinateRegion(
        center: .init(latitude: 51.5, longitude: 0.0),
        span: .init(latitudeDelta: 2, longitudeDelta: 2)
    )

    @State private var staticMapImage: NSImage?
    @State private var staticMapOutdated = false
    @State private var staticMapOpacity = 1.0
    @State private var errorMessage: String?

    private let staticMapUpdatePublisher = PassthroughSubject<Void, Never>()

    var body: some Scene {
        WindowGroup {
            let clipShape = RoundedRectangle(cornerRadius: 10)
                .size(width: CGFloat(mapSize), height: CGFloat(mapSize), anchor: .center)

            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    Map(initialPosition: .region(region))
                        .onMapCameraChange(frequency: .continuous) { context in
                            let totalRegion = context.region
                            staticMapOutdated = true
                            region = MKCoordinateRegion(
                                center: totalRegion.center,
                                span: MKCoordinateSpan(
                                    latitudeDelta: totalRegion.span.latitudeDelta * CGFloat(mapSize) / geometry.size.height,
                                    longitudeDelta: totalRegion.span.longitudeDelta * CGFloat(mapSize) / geometry.size.width
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
                        }
                    HStack {
                        Slider(value: $staticMapOpacity)
                            .frame(width: 100)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(.regularMaterial))
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
                    center: Coordinates(region.center),
                    span: CoordinateSpan(region.span)
                )
                let pngData = try await staticMap.render().pngEncoded()
                staticMapImage = NSImage(data: pngData)
                staticMapOutdated = false
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
