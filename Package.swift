// swift-tools-version: 6.0

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Purine Help",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .iOSApplication(
            name: "Purine Help",
            targets: ["AppModule"],
            bundleIdentifier: "petertu.Purine-Help",
            teamIdentifier: "VZK3VCF454",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .gamepad),
            accentColor: .presetColor(.cyan),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            capabilities: [
                .camera(purposeString: "Camera Needed"),
                .photoLibrary(purposeString: "Unknown Usage Description")
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/dkk/WrappingHStack", "2.0.0"..<"3.0.0")
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            dependencies: [
                .product(name: "WrappingHStack", package: "wrappinghstack")
            ],
            path: ".",
            resources: [
                .process("Resources"),
                .copy("MLModel/Food101.mlmodelc")
            ]
        )
    ]
)