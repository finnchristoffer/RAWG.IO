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
                .target(name: "FavoritesFeature"),
                .target(name: "DetailFeature")
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
                .target(name: "Core"),
                .external(name: "SnapshotTesting")
            ]
        ),
        
        // MARK: - CoreNavigation Module
        .target(
            name: "CoreNavigation",
            destinations: destinations,
            product: .staticFramework,
            bundleId: "\(bundleIdPrefix).corenavigation",
            deploymentTargets: deploymentTargets,
            sources: ["Modules/CoreNavigation/Sources/**"],
            dependencies: []
        ),
        .target(
            name: "CoreNavigationTests",
            destinations: destinations,
            product: .unitTests,
            bundleId: "\(bundleIdPrefix).corenavigation.tests",
            deploymentTargets: deploymentTargets,
            sources: ["Modules/CoreNavigation/Tests/**"],
            dependencies: [
                .target(name: "CoreNavigation")
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
        
        // MARK: - Common Module (App-Specific Shared)
        .target(
            name: "Common",
            destinations: destinations,
            product: .staticFramework,
            bundleId: "\(bundleIdPrefix).common",
            deploymentTargets: deploymentTargets,
            sources: ["Modules/Common/Sources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "CoreNetwork"),
                .target(name: "CoreNavigation")
            ]
        ),
        .target(
            name: "CommonTests",
            destinations: destinations,
            product: .unitTests,
            bundleId: "\(bundleIdPrefix).common.tests",
            deploymentTargets: deploymentTargets,
            sources: ["Modules/Common/Tests/**"],
            dependencies: [
                .target(name: "Common")
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
                .target(name: "Common"),
                .target(name: "CoreUI")
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
                .target(name: "Common"),
                .target(name: "CoreUI")
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
                .target(name: "Common"),
                .target(name: "CoreUI")
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
        
        // MARK: - Detail Feature
        .target(
            name: "DetailFeature",
            destinations: destinations,
            product: .staticFramework,
            bundleId: "\(bundleIdPrefix).features.detail",
            deploymentTargets: deploymentTargets,
            sources: ["Modules/DetailFeature/Sources/**"],
            dependencies: [
                .target(name: "Common"),
                .target(name: "CoreUI"),
                .external(name: "Factory")
            ]
        ),
        .target(
            name: "DetailFeatureTests",
            destinations: destinations,
            product: .unitTests,
            bundleId: "\(bundleIdPrefix).features.detail.tests",
            deploymentTargets: deploymentTargets,
            sources: ["Modules/DetailFeature/Tests/**"],
            dependencies: [
                .target(name: "DetailFeature"),
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
        )
    ],
    schemes: [
        .scheme(
            name: "RAWGApp",
            shared: true,
            buildAction: .buildAction(targets: ["RAWGApp"]),
            testAction: .targets(
                [
                    "CoreTests",
                    "CoreNavigationTests",
                    "CommonTests",
                    "CoreUITests",
                    "CoreNetworkTests",
                    "GamesFeatureTests",
                    "SearchFeatureTests",
                    "FavoritesFeatureTests",
                    "DetailFeatureTests"
                ],
                options: .options(coverage: true)
            ),
            runAction: .runAction(configuration: "Debug"),
            archiveAction: .archiveAction(configuration: "Release")
        ),
        .scheme(
            name: "CoreUI",
            shared: true,
            buildAction: .buildAction(targets: ["CoreUI"]),
            testAction: .targets(["CoreUITests"]),
            runAction: .runAction(configuration: "Debug")
        ),
        .scheme(
            name: "GamesFeature",
            shared: true,
            buildAction: .buildAction(targets: ["GamesFeature"]),
            testAction: .targets(["GamesFeatureTests"]),
            runAction: .runAction(configuration: "Debug")
        ),
        .scheme(
            name: "Core",
            shared: true,
            buildAction: .buildAction(targets: ["Core"]),
            testAction: .targets(["CoreTests"]),
            runAction: .runAction(configuration: "Debug")
        ),
        .scheme(
            name: "CoreNavigation",
            shared: true,
            buildAction: .buildAction(targets: ["CoreNavigation"]),
            testAction: .targets(["CoreNavigationTests"]),
            runAction: .runAction(configuration: "Debug")
        ),
        .scheme(
            name: "CoreNetwork",
            shared: true,
            buildAction: .buildAction(targets: ["CoreNetwork"]),
            testAction: .targets(["CoreNetworkTests"]),
            runAction: .runAction(configuration: "Debug")
        ),
        .scheme(
            name: "Common",
            shared: true,
            buildAction: .buildAction(targets: ["Common"]),
            testAction: .targets(["CommonTests"]),
            runAction: .runAction(configuration: "Debug")
        )
    ]
)
