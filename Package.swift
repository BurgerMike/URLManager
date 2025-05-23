// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "URLManager",
    platforms: [
         .iOS(.v16),
         .macOS(.v13),
         .watchOS(.v10),
         .tvOS(.v16)
     ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "URLManager",
            targets: ["URLManager"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "URLManager"),
        .testTarget(
            name: "URLManagerTests",
            dependencies: ["URLManager"]
        ),
    ]
)
