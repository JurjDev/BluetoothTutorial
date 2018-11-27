// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "Tutorials",
    dependencies: [
    	.Package(url: "https://github.com/uraimo/SwiftyGPIO.git", majorVersion: 1),
    	.Package(url: "https://github.com/PureSwift/GATT.git", "1.7.0")
    ]
)

#if os(macOS)
let dependency: Package.Dependency = .Package(url: "https://github.com/PureSwift/BluetoothDarwin.git", majorVersion: 1)
package.dependencies.append(dependency)
#elseif os(Linux)
let dependency: Package.Dependency = .Package(url: "https://github.com/PureSwift/BluetoothLinux.git", majorVersion: 3)
package.dependencies.append(dependency)
#endif

