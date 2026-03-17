// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "WalletCore",
    platforms: [.iOS(.v17), .macOS(.v15)],
    products: [
        .library(name: "WalletCore", targets: ["WalletCore"]),
        .library(name: "WalletCoreSwiftProtobuf", targets: ["WalletCoreSwiftProtobuf"]),
        .library(name: "WalletCorePrimitives", targets: ["WalletCorePrimitives"])
    ],
    dependencies: [
        .package(name: "Primitives", path: "../Primitives")
    ],
    targets: [
        .binaryTarget(
            name: "WalletCore",
            url: "https://github.com/trustwallet/wallet-core/releases/download/4.6.0/WalletCore.xcframework.zip",
            checksum: "689935aff413004b18c7b32ee955716868ebcd38328c5159c69f0d5f5bcfddf0"
        ),
        .binaryTarget(
            name: "WalletCoreSwiftProtobuf",
            url: "https://github.com/trustwallet/wallet-core/releases/download/4.6.0/WalletCoreSwiftProtobuf.xcframework.zip",
            checksum: "719b1ebc7ad174017e399cdd7fc60372b369d9712d646ebb8b4e264c4881d1d8"
        ),
        .target(
            name: "WalletCorePrimitives",
            dependencies: [
                "Primitives",
                "WalletCore",
                "WalletCoreSwiftProtobuf"
            ]
        ),
        .testTarget(
            name: "WalletCorePrimitivesTests",
            dependencies: [
                "WalletCorePrimitives",
                .product(name: "PrimitivesTestKit", package: "Primitives")
            ]
        )
    ]
)
