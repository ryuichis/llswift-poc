import PackageDescription

let package = Package(name: "llswift",
  targets: [
    Target(
      name: "CodeGen"
    ),
    Target(
      name: "llswift",
      dependencies: [
        "CodeGen",
      ]
    ),
  ],
  dependencies: [
    .Package(url: "https://github.com/trill-lang/cllvm.git", majorVersion: 0),
    .Package(url: "https://github.com/trill-lang/LLVMSwift.git", majorVersion: 0),
    .Package(url: "https://github.com/yanagiba/swift-ast.git", majorVersion: 0),
  ]
)
