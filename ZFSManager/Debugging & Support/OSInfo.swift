//
//  OSInfo.swift
//
import Foundation

typealias OSVersion = (major: Int, minor: Int, patch: Int)

/**
 * Compare two OS versions similar to strcmp()
 * @param left One operand
 * @param right The other operand
 * @return A negative value if left < right, 0 is both are equal, a postive value if left > right
 */
func OSVersionCompare(old: OSVersion, new: OSVersion) -> Int {
    if old.major != new.major {
        return (old.major < new.major) ? -1 : 1
    }
    if old.minor != new.minor {
        return (old.minor < new.minor) ? -1 : 1
    }
    if old.patch != new.patch {
        return (old.patch < new.patch) ? -1 : 1
    }
    return 0
}

class OSInfo: NSObject {
    class func osVersion() -> OSVersion {
        let procInfo = ProcessInfo.processInfo
        if procInfo.responds(to: #selector(getter: ProcessInfo.operatingSystemVersion)) {
            let nsVer: OperatingSystemVersion = procInfo.operatingSystemVersion
            //structs cannot be casted per C standard
            let spVer: OSVersion = (nsVer.majorVersion, nsVer.minorVersion, nsVer.patchVersion)
            return spVer
        } else {
            let versionMajor: Int = 0
            let versionMinor: Int = 0
            let versionPatch: Int = 0
//            Gestalt([], &versionMajor)
//            Gestalt([], &versionMinor)
//            Gestalt([], &versionPatch)

            let spVer: OSVersion = (versionMajor, versionMinor, versionPatch)
            return spVer
        }
    }

    class func isOSVersion(atLeastMajor major: Int, minor: Int, patch: Int) -> Bool {
        let procInfo = ProcessInfo.processInfo
        let osMinVersion: OperatingSystemVersion = OperatingSystemVersion(majorVersion: major, minorVersion: minor, patchVersion: patch)
        if procInfo.responds(to: #selector(ProcessInfo.isOperatingSystemAtLeast(_:))) {
                return procInfo.isOperatingSystemAtLeast(osMinVersion)
        } else {
            let runningVersion: OSVersion = self.osVersion()
            let referenceVersion: OSVersion = (major, minor, patch)
            return OSVersionCompare(old: runningVersion, new: referenceVersion) >= 0
        }
    }
}

// Needed because this class is also compiled with SequelProTunnelAssistant
