// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "RecipeEngine",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "RecipeManagerLib",
            targets: ["Presentation", "Application", "Domain", "Infrastructure", "UI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.7.1")),
    ],
    targets: [
        // Contains: structs (Recipe, Ingredient), protocols, domain rules
        // Depends on nothing
        .target(
            name: "Domain",
            dependencies: []
        ),
        // Contains: Use Cases CreateRecipeUseCase, orchestaring
        // Depends on domain
            .target(
                name: "Application",
                dependencies: ["Domain"]
            ),
        // Contains: repositories, etc
        // Depends on domain protocols
            .target(
                name: "Infrastructure",
                dependencies: ["Domain"]
            ),
        // Contains: ViewModels, State Objects
        // Depends on Application
            .target(
                name: "Presentation",
                dependencies: ["Application"]
            ),
        // Contains: Views
        // Depends on Presentation and SnapKit
            .target(
                name: "UI",
                dependencies: ["Presentation", "SnapKit"]
            ),
        .testTarget(
            name: "Tests",
            dependencies: ["Application", "Domain", "Infrastructure"],
            resources: [
                .process("run_tests.sh")
            ]
        ),
    ]
)
