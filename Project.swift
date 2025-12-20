import ProjectDescription

// MARK: - Project Settings
let deploymentTargets: DeploymentTargets = .iOS("17.0")
let destinations: Destinations = [.iPhone]
let organizationName = "FinnChristoffer"
let bundleIdPrefix = "com.finnchristoffer.rawg"

// MARK: - Project
let project = Project(
    name: "RAWG",
    organizationName: organizationName,
    settings: .settings(
        base: [
            "SWIFT_VERSION": "6.0",
            "ENABLE_MODULE_VERIFIER": "YES",
            "MODULE_VERIFIER_SUPPORTED_LANGUAGE_STANDARDS": "gnu17 gnu++20"
        ],
        configurations: [
            .debug(name: "Debug"),
            .release(name: "Release")
        ]
    ),
    targets: [
        // MARK: - Main App
        .target(
            name: "RAWGApp",
            destinations: destinations,
            product: .app,
            bundleId: "\(bundleIdPrefix).app",
            deploymentTargets: deploymentTargets,
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": [:],
                "CFBundleDisplayName": "RAWG"
            ]),
            sources: ["RAWGApp/Sources/**"],
            resources: ["RAWGApp/Resources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "CoreUI"),
                .target(name: "CoreNetwork"),
                .target(name: "GamesFeature"),
                .target(name: "SearchFeature"),
                .target(name: "FavoritesFeature")
            ]
        ),
        
        // MARK: - Core Module
        .target(
            name: "Core",
            destinations: destinations,
            product: .staticFramework,
            bundleId: "\(bundleIdPrefix).core",
            deploymentTargets: deploymentTargets,
            sources: ["Modules/Core/Sources/**"],
            dependencies: [
                .external(name: "Factory")
            ]
        ),
        .target(
            name: "CoreTests",
            destinations: destinations,
            product: .unitTests,
            bundleId: "\(bundleIdPrefix).core.tests",
            deploymentTargets: deploymentTargets,
            sources: ["Modules/Core/Tests/**"],
            dependencies: [
                .target(name: "Core")
            ]
        ),
        
        // MARK: - CoreUI Module
        .target(
            name: "CoreUI",
            destinations: destinations,
            product: .staticFramework,
            bundleId: "\(bundleIdPrefix).coreui",
            deploymentTargets: deploymentTargets,
            sources: ["Modules/CoreUI/Sources/**"],
            resources: ["Modules/CoreUI/Resources/**"],
            dependencies: [
                .target(name: "Core")
            ]
        ),
        .target(
            name: "CoreUITests",
            destinations: destinations,
            product: .unitTests,
            bundleId: "\(bundleIdPrefix).coreui.tests",
            deploymentTargets: deploymentTargets,
            sources: ["Modules/CoreUI/Tests/**"],
            dependencies: [
                .target(name: "CoreUI"),
                .external(name: "SnapshotTesting")
            ]
        ),
        
        // MARK: - CoreNetwork Module
        .target(
            name: "CoreNetwork",
            destinations: destinations,
            product: .staticFramework,
            bundleId: "\(bundleIdPrefix).corenetwork",
            deploymentTargets: deploymentTargets,
            sources: ["Modules/CoreNetwork/Sources/**"],
            dependencies: [
                .target(name: "Core")
            ]
        ),
        .target(
            name: "CoreNetworkTests",
            destinations: destinations,
            product: .unitTests,
            bundleId: "\(bundleIdPrefix).corenetwork.tests",
            deploymentTargets: deploymentTargets,
            sources: ["Modules/CoreNetwork/Tests/**"],
            dependencies: [
                .target(name: "CoreNetwork")
            ]
        ),
        
        // MARK: - Games Feature
        .target(
            name: "GamesFeature",
            destinations: destinations,
            product: .staticFramework,
            bundleId: "\(bundleIdPrefix).features.games",
            deploymentTargets: deploymentTargets,
            sources: ["Modules/GamesFeature/Sources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "CoreUI"),
                .target(name: "CoreNetwork")
            ]
        ),
        .target(
            name: "GamesFeatureTests",
            destinations: destinations,
            product: .unitTests,
            bundleId: "\(bundleIdPrefix).features.games.tests",
            deploymentTargets: deploymentTargets,
            sources: ["Modules/GamesFeature/Tests/**"],
            dependencies: [
                .target(name: "GamesFeature"),
                .external(name: "SnapshotTesting")
            ]
        ),
        
        // MARK: - Search Feature
        .target(
            name: "SearchFeature",
            destinations: destinations,
            product: .staticFramework,
            bundleId: "\(bundleIdPrefix).features.search",
            deploymentTargets: deploymentTargets,
            sources: ["Modules/SearchFeature/Sources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "CoreUI"),
                .target(name: "CoreNetwork")
            ]
        ),
        .target(
            name: "SearchFeatureTests",
            destinations: destinations,
            product: .unitTests,
            bundleId: "\(bundleIdPrefix).features.search.tests",
            deploymentTargets: deploymentTargets,
            sources: ["Modules/SearchFeature/Tests/**"],
            dependencies: [
                .target(name: "SearchFeature"),
                .external(name: "SnapshotTesting")
            ]
        ),
        
        // MARK: - Favorites Feature
        .target(
            name: "FavoritesFeature",
            destinations: destinations,
            product: .staticFramework,
            bundleId: "\(bundleIdPrefix).features.favorites",
            deploymentTargets: deploymentTargets,
            sources: ["Modules/FavoritesFeature/Sources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "CoreUI"),
                .target(name: "CoreNetwork")
            ]
        ),
        .target(
            name: "FavoritesFeatureTests",
            destinations: destinations,
            product: .unitTests,
            bundleId: "\(bundleIdPrefix).features.favorites.tests",
            deploymentTargets: deploymentTargets,
            sources: ["Modules/FavoritesFeature/Tests/**"],
            dependencies: [
                .target(name: "FavoritesFeature"),
                .external(name: "SnapshotTesting")
            ]
        ),
        
        // MARK: - UI Tests
        .target(
            name: "RAWGAppUITests",
            destinations: destinations,
            product: .uiTests,
            bundleId: "\(bundleIdPrefix).app.uitests",
            deploymentTargets: deploymentTargets,
            sources: ["RAWGApp/UITests/**"],
            dependencies: [
                .target(name: "RAWGApp")
            ]
        ),
    ],
    schemes: [
        .scheme(
            name: "RAWGApp",
            shared: true,
            buildAction: .buildAction(targets: ["RAWGApp"]),
            testAction: .targets(
                [
                    "CoreTests",
                    "CoreUITests",
                    "CoreNetworkTests",
                    "GamesFeatureTests",
                    "SearchFeatureTests",
                    "FavoritesFeatureTests"
                ],
                options: .options(coverage: true)
            ),
            runAction: .runAction(configuration: "Debug"),
            archiveAction: .archiveAction(configuration: "Release")
        )
    ]
)