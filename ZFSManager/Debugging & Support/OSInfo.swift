//
//  ZFSOSInfo.swift
//
import Foundation

typealias ZFSOSVersion = (major: Int, minor: Int, patch: Int)

/**
 * Compare two OS versions similar to strcmp()
 * @param left One operand
 * @param right The other operand
 * @return A negative value if left < right, 0 is both are equal, a postive value if left > right
 */
func ZFSOSVersionCompare(`left`: ZFSOSVersion, `right`: ZFSOSVersion) -> Int {
    if `left`.major != `right`.major {
        return (`left`.major < `right`.major) ? -1 : 1
    }
    if `left`.minor != `right`.minor {
        return (`left`.minor < `right`.minor) ? -1 : 1
    }
    if `left`.patch != `right`.patch {
        return (`left`.patch < `right`.patch) ? -1 : 1
    }
    return 0
}

class ZFSOSInfo: NSObject {
    class func osVersion() -> ZFSOSVersion {
        let procInfo = ProcessInfo.processInfo
        if procInfo.responds(to: #selector(getter: ProcessInfo.operatingSystemVersion)) {
            let nsVer: OperatingSystemVersion = procInfo.operatingSystemVersion
            //structs cannot be casted per C standard
            let spVer: ZFSOSVersion = (nsVer.majorVersion, nsVer.minorVersion, nsVer.patchVersion)
            return spVer
        } else {
            let versionMajor: Int = 0
            let versionMinor: Int = 0
            let versionPatch: Int = 0
//            Gestalt([], &versionMajor)
//            Gestalt([], &versionMinor)
//            Gestalt([], &versionPatch)

            let spVer: ZFSOSVersion = (versionMajor, versionMinor, versionPatch)
            return spVer
        }
    }

    class func isOSVersion(atLeastMajor major: Int, minor: Int, patch: Int) -> Bool {
        let procInfo = ProcessInfo.processInfo
        let osMinVersion: OperatingSystemVersion = OperatingSystemVersion(majorVersion: major, minorVersion: minor, patchVersion: patch)
        if procInfo.responds(to: #selector(ProcessInfo.isOperatingSystemAtLeast(_:))) {
                return procInfo.isOperatingSystemAtLeast(osMinVersion)
        } else {
            let runningVersion: ZFSOSVersion = self.osVersion()
            let referenceVersion: ZFSOSVersion = (major, minor, patch)
            return ZFSOSVersionCompare(left: runningVersion.major, right: referenceVersion.major) >= 0
        }
    }
}

// Needed because this class is also compiled with SequelProTunnelAssistant
