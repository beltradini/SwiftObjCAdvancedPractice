import Vapor
import SwiftObjCAdvancedPractice

struct HealthResponse: Content {
    let status: String
    let service: String
}

struct ExampleIndexResponse: Content {
    let service: String
    let modules: [String]
    let routes: [String]
}

@main
struct SwiftObjCAdvancedPracticeServer {
    static func main() async throws {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)

        let app = try await Application.make(env)
        do {
            app.logger.info("Booting SwiftObjCAdvancedPracticeServer")

            app.get("health") { _ in
                HealthResponse(status: "ok", service: "SwiftObjCAdvancedPracticeServer")
            }

            app.get("examples") { _ in
                ExampleIndexResponse(
                    service: "SwiftObjCAdvancedPracticeServer",
                    modules: [
                        "Swift concurrency",
                        "Objective-C runtime bridging",
                        "Memory management",
                        "Advanced language patterns"
                    ],
                    routes: [
                        "GET /health",
                        "GET /examples"
                    ]
                )
            }

            try await app.execute()
            try await app.asyncShutdown()
        } catch {
            try await app.asyncShutdown()
            throw error
        }
    }
}
