import Foundation
import SwiftObjCAdvancedPractice

@main
struct SwiftObjCAdvancedPracticeCLI {
    static func main() async {
        let arguments = Array(CommandLine.arguments.dropFirst())

        if arguments.contains("--help") || arguments.contains("-h") {
            printUsage()
            return
        }

        if arguments.isEmpty || arguments.contains("--all") {
            await ExampleRunner.runAllExamples()
            return
        }

        var ranSection = false

        if arguments.contains("--concurrency") {
            ranSection = true
            await ExampleRunner.runConcurrencyExamples()
        }

        if arguments.contains("--patterns") {
            ranSection = true
            ExampleRunner.runAdvancedPatternsExamples()
        }

        if arguments.contains("--memory") {
            ranSection = true
            ExampleRunner.runMemoryManagementExamples()
        }

        if arguments.contains("--bridge") {
            ranSection = true
            ExampleRunner.runBridgeExamples()
        }

        if !ranSection {
            printUsage()
        }
    }

    private static func printUsage() {
        print("""
        SwiftObjCAdvancedPracticeCLI

        Usage:
          swift run SwiftObjCAdvancedPracticeCLI --all
          swift run SwiftObjCAdvancedPracticeCLI --concurrency
          swift run SwiftObjCAdvancedPracticeCLI --patterns
          swift run SwiftObjCAdvancedPracticeCLI --memory
          swift run SwiftObjCAdvancedPracticeCLI --bridge
        """)
    }
}
