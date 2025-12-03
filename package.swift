import PackageDescription

let package = Package(
    name: "RecipeEngine",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "RecipeManagerLib",
            targets: ["Presentation", "Application", "Domain", "Infrastructure"]
        ),
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
        .testTarget(
            name: "Tests",
            dependencies: ["Application", "Domain", "Infrastructure"]
        ),
    ]
)
