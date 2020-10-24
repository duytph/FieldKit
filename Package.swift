// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "FieldKit",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "ValidatedField",
            targets: [
                "ValidatedField",
            ]),
        .library(
            name: "PickedField",
            targets: [
                "PickedField"
            ]),
    ],
    dependencies: [
        .package(url: "https://github.com/SvenTiigi/ValidatedPropertyKit", from: "0.0.4"),
    ],
    targets: [
        .target(
            name: "ValidatedField",
            dependencies: ["ValidatedPropertyKit"]),
        .testTarget(
            name: "ValidatedFieldtTests",
            dependencies: ["ValidatedField"]),
        .target(
            name: "PickedField"),
        .testTarget(
            name: "PickedFieldTests",
            dependencies: ["PickedField"])
    ]
)
