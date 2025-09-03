import Foundation
import Testing
@testable import APINotes

struct Tests {
    @Test func equal() async throws {
        let searchPaths = [
            "usr/include",
            "System/Library/Frameworks",
            "System/Library/PrivateFrameworks",
        ]
        let sdkRoot = "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
        var files: [URL] = []
        for searchPath in searchPaths {
            let fullSearchPath = sdkRoot.nsString.appendingPathComponent(searchPath)
            let fileManager = FileManager.default
            guard fileManager.fileExists(atPath: fullSearchPath) else {
                continue
            }
            let enumerator = fileManager.enumerator(atPath: fullSearchPath)
            while let element = enumerator?.nextObject() as? String {
                let fullPath = fullSearchPath.nsString.appendingPathComponent(element)
                if element.hasSuffix(".apinotes") {
                    files.append(.init(filePath: fullPath))
                }
            }
        }
        let testDir = URL.desktopDirectory.appending(component: "APINotesTests")
        if !FileManager.default.fileExists(atPath: testDir.path) {
            try FileManager.default.createDirectory(at: testDir, withIntermediateDirectories: true)
        }
        for file in files {
            let module = try Module(contentsOf: file)
            let originalFile = try String(contentsOf: file, encoding: .utf8)
            let reencodedFile = try module.stringValue
            try originalFile.write(to: testDir.appending(component: "\(file.lastPathComponent) Original.apinotes"), atomically: true, encoding: .utf8)
            try reencodedFile.write(to: testDir.appending(component: "\(file.lastPathComponent) Reencoded.apinotes"), atomically: true, encoding: .utf8)
        }
    }
}

extension String {
    var nsString: NSString { self as NSString }
}
