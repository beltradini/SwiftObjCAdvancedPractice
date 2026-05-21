import SwiftUI
import SwiftObjCAdvancedPractice

// MARK: - Main App Entry Point
@main
struct SwiftObjCAdvancedPracticeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - Main Content View
struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ActorDemoView()
            .tabItem {
                Label("Actors", systemImage: "cpu")
            }
        }
    }
}

// MARK: - Actor Demo
struct ActorDemoView: View {
    @State private var summary = "Tap the button to store sample data."

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Swift Concurrency Demo")
                .font(.largeTitle.bold())

            Text(summary)
                .font(.body)
                .foregroundStyle(.secondary)

            Button("Store Sample Value") {
                Task {
                    let actor = DataManagerActor.shared
                    await actor.store(Data("Hello from SwiftUI".utf8), forKey: "swiftui-demo")
                    let stats = await actor.getStatistics()
                    summary = "Stored \(stats.count) item(s) with \(stats.accessCount) access(es)."
                }
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
    }
}
