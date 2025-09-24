// swift-tools-version:6.2
import PackageDescription

let package = Package(
  name: "swift-nonempty",
  products: [
    .library(name: "NonEmpty", targets: ["NonEmpty"])
  ],
  targets: [
    .target(name: "NonEmpty", dependencies: []),
    .testTarget(name: "NonEmptyTests", dependencies: ["NonEmpty"]),
  ],
  swiftLanguageModes: [.v6],
)

for target: PackageDescription.Target in package.targets {
  {
    var settings: [PackageDescription.SwiftSetting] = $0 ?? []
    settings.append(.enableExperimentalFeature("CoroutineAccessors"))
    $0 = settings
  }(&target.swiftSettings)
}
