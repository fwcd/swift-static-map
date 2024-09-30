#if os(macOS)

// A simple GUI that interactively renders a static map onto a MapKit view.

import SwiftUI
import MapKit

let mapSize = 256

@available(macOS 15, *)
struct DemoGUI: App {
    var body: some Scene {
        WindowGroup {
            Map {
                
            }
            .overlay {
                Rectangle()
                    .subtracting(
                        Rectangle()
                            .size(width: CGFloat(mapSize), height: CGFloat(mapSize), anchor: .center)
                    )
                    .allowsHitTesting(false)
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
