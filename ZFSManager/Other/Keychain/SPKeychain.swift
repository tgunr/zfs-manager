//
//  SPKeychain.swift
//  sequel-pro
//
//  Created by Lorenz Textor (lorenz@textor.ch) on December 25, 2002.
//  Copyright (c) 2002-2003 Lorenz Textor. All rights reserved.
//  Copyright (c) 2012 Sequel Pro Team. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  More info at <https://github.com/sequelpro/sequelpro>

import Cocoa
import Security

class SPKeychain: NSObject {

    var myAlerts = SPAlertSheets()
    let mainWindow = NSApplication.shared.windows.first

    func findGenericPassword(forName name: String?, account: String?) -> (success: OSStatus, result: CFTypeRef?)  {

        var status: OSStatus = -1
        
        let search = passwordSearch(forName: name, account: account)
        if search.success == errSecSuccess {
            
            let searchName = name ?? ""
            let accountName = account ?? ""
            var searchNameLength: UInt32 = UInt32(searchName.count)
            //            var keyVal: UnsafeMutableRawPointer? = nil
//            let keyItem = search.result! as AnyObject as? UnsafeMutablePointer<SecKeychainItem?>
            
            status = SecKeychainFindGenericPassword(
                nil,
                UInt32(searchName.utf8.count), searchName, //### Use `utf8.count`
                UInt32(accountName.utf8.count), accountName, //### Use `utf8.count`
                //### to pass `UnsafeMutablePointer<UInt32>?`, declare a variable of `UInt32`.
                &searchNameLength,
                //### to pass `UnsafeMutablePointer<UnsafeMutableRawPointer?>?`,
                // declare a variable of `UnsafeMutableRawPointer?`.
                search.result! as AnyObject as? UnsafeMutablePointer<UnsafeMutableRawPointer?>,
                nil
            )
        }
        return (status, search.result)
    }
    
    func addPassword(_ password: String?, forName name: String?, account: String?) {
        addPassword(password, forName: name, account: account, withLabel: name)
    }

    func addPassword(_ password: String?, forName name: String?, account: String?, withLabel label: String?) {
        var status: OSStatus
        var sequelProRef: SecTrustedApplication?
        var sequelProHelperRef: SecTrustedApplication?
        var passwordAccessRef: SecAccess? = nil
        var attributes = [SecKeychainAttribute]()
        var attList = SecKeychainAttributeList()

        // If a nil password was supplied, do nothing.
        if password == nil {
            return
        }

        // Check if password already exists before adding
        if !passwordExists(forName: name, account: account) {

            // Create a trusted access list with two items - ourselves and the SSH pass app
            let helperPath = URL(fileURLWithPath: Bundle.main.resourcePath ?? "").appendingPathComponent("SequelProTunnelAssistant").absoluteString

            if (SecTrustedApplicationCreateFromPath(nil, &sequelProRef) == errSecSuccess) && (SecTrustedApplicationCreateFromPath(helperPath, &sequelProHelperRef) == errSecSuccess) {

                let trustedApps = [sequelProRef, sequelProHelperRef]

                let searchName = name ?? ""
//                let accountName = account ?? ""
                status = SecAccessCreate(searchName as CFString, trustedApps as CFArray, &passwordAccessRef)

                if status != errSecSuccess {
                    print(String(format: "Error (%i) while trying to create access list for name: %@ account: %@", Int(status), name ?? "", account ?? ""))
                    passwordAccessRef = nil
                }
            }

            // Set up the item attributes
            var dataString = "application password"
            let dataStringP = UnsafeMutableRawPointer(&dataString)
            var attrString: ContiguousArray<CChar>?
            var attrStringP = UnsafeMutableRawPointer(&attrString)
            let attrStringS = attrString?.count ?? 0

            attributes[0].tag = SecItemAttr.genericItemAttr.rawValue
            attributes[0].data = dataStringP
            attributes[0].length = UInt32(truncating: dataString.count as NSNumber)

            attrString = label?.utf8CString
            attrStringP = UnsafeMutableRawPointer(&attrString)
            attributes[1].tag = SecItemAttr.labelItemAttr.rawValue
            attributes[1].data = attrStringP
            attributes[1].length = UInt32(truncating: attrStringS as NSNumber)

            attrString = account?.utf8CString
            attrStringP = UnsafeMutableRawPointer(&attrString)
            attributes[2].tag = SecItemAttr.accountItemAttr.rawValue
            attributes[2].data = attrStringP
            attributes[2].length = UInt32(truncating: attrStringS as NSNumber)

            attrString = name?.utf8CString
            attrStringP = UnsafeMutableRawPointer(&attrString)
            attributes[3].tag = SecItemAttr.serviceItemAttr.rawValue
            attributes[3].data = attrStringP
            attributes[2].length = UInt32(truncating: attrStringS as NSNumber)

            attList.count = 4
            let attributesP = UnsafeMutablePointer(&attributes)
            attList.attr = attributesP

            // Create the keychain item
            var newPassword = password
            let newPasswordS = newPassword?.count ?? 0
//            password?.withCString({ cstrptr in
//                let newPasswordP = UnsafeRawPointer(cstrptr)
//                status = SecKeychainItemCreateFromContent(
//                    SecItemClass.genericPasswordItemClass,  // Generic password type */
//                    &attList,  /* The attribute list created for the keychain item */
//                    UInt32(truncating: newPasswordS as NSNumber),  /* Length of password */
//                    newPasswordP,  /* Password data */
//                    nil,  /* Default keychain */
//                    passwordAccessRef,  /* Access list for this keychain */
//                    nil) /* The item reference */
//            })
            status = errSecSuccess
            withUnsafePointer(to: &newPassword) { ptr in
                let newPasswordP = UnsafeRawPointer(ptr)
                status = SecKeychainItemCreateFromContent(
                    SecItemClass.genericPasswordItemClass,  // Generic password type */
                    &attList,  /* The attribute list created for the keychain item */
                    UInt32(truncating: newPasswordS as NSNumber),  /* Length of password */
                    newPasswordP,  /* Password data */
                    nil,  /* Default keychain */
                    passwordAccessRef,  /* Access list for this keychain */
                    nil) /* The item reference */
            }


            if passwordAccessRef != nil {
            }

            if status != errSecSuccess {
                print(String(format: "Error (%i) while trying to add password for name: %@ account: %@", Int(status), name ?? "", account ?? ""))
                
                myAlerts.SPOnewayAlertSheet(title: NSLocalizedString("Error adding password to Keychain", comment: "error adding password to keychain message"), docWindow: mainWindow, msg: String(format: NSLocalizedString("An error occured while trying to add the password to your Keychain. Repairing your Keychain might resolve this, but if it doesn't please report it to the Sequel Pro team, supplying the error code %i.", comment: "error adding password to keychain informative message"), status))
            }
        }
    }

    func getPasswordForName(_ name: String?, account: String?) -> String? {
        var status: OSStatus

//        let passwordData: Void?
        var passwordLength: UInt32 = 0
        var itemRef: SecKeychainItem?
//        let password: String? = nil
        let searchName = name ?? ""
        let accountName = account ?? ""
        var searchNameLength: UInt32 = UInt32(searchName.count)
        //            var keyVal: UnsafeMutableRawPointer? = nil

        let found = findGenericPassword(forName: searchName, account: accountName)
//        let keyItem = found.result! as AnyObject as? UnsafeMutablePointer<SecKeychainItem?>

        status = SecKeychainFindGenericPassword(
            nil,
            UInt32(searchName.utf8.count), searchName, //### Use `utf8.count`
            UInt32(accountName.utf8.count), accountName, //### Use `utf8.count`
            //### to pass `UnsafeMutablePointer<UInt32>?`, declare a variable of `UInt32`.
            &searchNameLength,
            //### to pass `UnsafeMutablePointer<UnsafeMutableRawPointer?>?`,
            // declare a variable of `UnsafeMutableRawPointer?`.
            found.result! as AnyObject as? UnsafeMutablePointer<UnsafeMutableRawPointer?>,
            nil
        )
//        var item = found.result! as AnyObject as? UnsafeMutableRawPointer
        var password1: UnsafeMutableRawPointer? = nil
        var passwordString: String? = nil
        status = SecKeychainFindGenericPassword(
            nil,  /* default keychain */
            UInt32(searchName.utf8.count), searchName, //### Use `utf8.count`
            UInt32(accountName.utf8.count), accountName, //### Use `utf8.count`
            &passwordLength,  /* length of password */
            &password1,  /* pointer to password data */
            &itemRef /* the item reference */)

        if status == errSecSuccess {

            // Create a \0 terminated cString out of passwordData
            /*
            var passwordLength: char passwordBuf
            +1
            strncpy(passwordBuf, passwordData, size_t(passwordLength))
            passwordBuf[passwordLength] = "\0"
            */
            /*
            let ump = UnsafeMutablePointer<Any>.allocate(capacity: 1)
            // `up` now contains an UnsafePointer initialized with `ump`
            var up = password1?.bindMemory(to: UnsafePointer<CChar>.self, capacity: 1)
            */

            // password retuned needs to be a String
            passwordString = NSString(bytes: password1!, length: Int(passwordLength), encoding: String.Encoding.utf8.rawValue) as String?

            /*
            let pB = passwordStuff.toType(String.self)

            let passwordBufP: UnsafePointer<CChar> = up
            let passwordBuf = String(utf8String: passwordBufP)

            password = String(cString: &passwordBuf, encoding: .utf8)

             */

            // Free the data allocated by SecKeychainFindGenericPassword:
            SecKeychainItemFreeContent(
                nil,  /* No attribute data to release */
                password1 /* Release data */)
        }

        return passwordString
    }

    func deletePassword(forName name: String?, account: String?) {
        var status: OSStatus
//        var itemRef: SecKeychainItem? = nil

        // Check if password already exists before deleting
        let search = passwordSearch(forName: name, account: account)
        if search.success == errSecSuccess {
            
            let searchName = name ?? ""
            let accountName = account ?? ""
            var searchNameLength: UInt32 = UInt32(searchName.count)
//            var keyVal: UnsafeMutableRawPointer? = nil
            let keyItem = search.result! as AnyObject as? UnsafeMutablePointer<SecKeychainItem?>

            status = SecKeychainFindGenericPassword(
                nil,
                UInt32(searchName.utf8.count), searchName, //### Use `utf8.count`
                UInt32(accountName.utf8.count), accountName, //### Use `utf8.count`
                //### to pass `UnsafeMutablePointer<UInt32>?`, declare a variable of `UInt32`.
                &searchNameLength,
                //### to pass `UnsafeMutablePointer<UnsafeMutableRawPointer?>?`,
                // declare a variable of `UnsafeMutableRawPointer?`.
                search.result! as AnyObject as? UnsafeMutablePointer<UnsafeMutableRawPointer?>,
                nil
            )

            status = SecKeychainFindGenericPassword(
                nil,  /* default keychain */
                UInt32(searchName.utf8.count), searchName, //### Use `utf8.count`
                UInt32(accountName.utf8.count), accountName, //### Use `utf8.count`
                nil,  /* length of password */
                nil,  /* pointer to password data */
                search.result! as AnyObject as? UnsafeMutablePointer<SecKeychainItem?>
            )

            if status == errSecSuccess {
                status = SecKeychainItemDelete(keyItem as! SecKeychainItem)

                if status != errSecSuccess {
                    print(String(format: "Error (%i) while trying to delete password for name: %@ account: %@", Int(status), name ?? "", account ?? ""))
                }
            }
        }
    }

    
    func passwordSearch(forName name: String?, account: String?) -> (success: OSStatus, result: CFTypeRef?)  {
        // "kSecClassGenericPassword" was introduced with the 10.7 SDK.
        // It won't work on 10.6 either (meaning this code never matches properly there).
        var status: OSStatus = errSecSuccess
        var result: CFTypeRef? = nil
        if OSInfo.isOSVersion(atLeastMajor: 10, minor: 7, patch: 0) {
            var query: [AnyHashable : Any] = [:]

            query[kSecClass] = kSecClassGenericPassword
            query[kSecReturnAttributes] = kCFBooleanTrue
            query[kSecMatchLimit] = kSecMatchLimitOne

            query[kSecAttrAccount] = account ?? ""
            query[kSecAttrService] = name ?? ""

            status = SecItemCopyMatching(query as CFDictionary, &result)
            return (status, result)
        }
        return (status, result)
    }
    
    func passwordExists(forName name: String?, account: String?) -> Bool {
        let search = passwordSearch(forName: name, account: account)
        fatalError("Keychain unsupported for MacOS < 10.7")
        return search.success == errSecSuccess
        

        /*
        //Version for 10.6

        var item: SecKeychainItem?
        var search: SecKeychainSearch? = nil
        let numberOfItemsFound: Int = 0
        var list: SecKeychainAttributeList
        var attributes = [SecKeychainAttribute](repeating: SecKeychainAttribute(), count: 2)

        // Check supplied variables and replaces nils with empty strings
        /*
        if name == nil {
            name = ""
        }
        if account == nil {
            account = ""
        }
        */

        attributes[0].tag = SecItemAttr.accountItemAttr.rawValue
        let rawptr = allocate()
        let ptrA = rawPtr.bindMemory(to: account?.utf8CString.self, capacity: 1)

        var ad: UnsafeMutableRawPointer? = account?.utf8CString
        let threadResultPtr = threadResultRawPtr!.assumingMemoryBound(to: ad)

        var accountData: UnsafeMutableRawPointer = account?.utf8CString
        attributes[0].data = &accountData // Account name
        attributes[0].length = UInt32(strlen(account?.utf8CString)) // Length of account name (bytes)

        attributes[1].tag = SecItemAttr.serviceItemAttr.rawValue
        attributes[1].data = name?.utf8CString // Service name
        attributes[1].length = UInt32(strlen(name?.utf8CString)) // Length of service name (bytes)

        list.count = 2
        list.attr = attributes

        if SecKeychainSearchCreateFromAttributes(nil, SecItemClass.genericPasswordItemClass, &list, &search) == [] {
            while SecKeychainSearchCopyNext(search, &item) == [] {
                numberOfItemsFound += 1
            }
        }

        if search != nil {
        }

        return numberOfItemsFound > 0
        */
    }

    func updateItem(withName name: String?, account: String?, toPassword password: String?) {
        updateItem(withName: name, account: account, toName: password, account: name, password: account)
    }

    func updateItem(withName name: String?, account: String?, toName newName: String?, account newAccount: String?, password: String?) {
        var status: OSStatus
        var itemRef: SecKeychainItem?
        var attributes = [SecKeychainAttribute]()
        var attList = SecKeychainAttributeList()
        let searchName = name ?? ""
        let accountName = account ?? ""
        var sequelProRef: SecTrustedApplication?
        var sequelProHelperRef: SecTrustedApplication?
        var passwordAccessRef: SecAccess? = nil

        let helperPath = URL(fileURLWithPath: Bundle.main.resourcePath ?? "").appendingPathComponent("SequelProTunnelAssistant").absoluteString

        if (SecTrustedApplicationCreateFromPath(nil, &sequelProRef) == errSecSuccess) && (SecTrustedApplicationCreateFromPath(helperPath, &sequelProHelperRef) == errSecSuccess) {
            
            let trustedApps = [sequelProRef, sequelProHelperRef]
            
            status = SecAccessCreate(searchName as CFString, trustedApps as CFArray, &passwordAccessRef)
            if status != errSecSuccess {
                print(String(format: "Error (%i) while trying to create access list for name: %@ account: %@", Int(status), name ?? "", account ?? ""))
                passwordAccessRef = nil
            }
        }

        // Retrieve a reference to the keychain item
        status = SecKeychainFindGenericPassword(
            nil,  // Default keychain */
            UInt32(searchName.utf8.count), searchName, //### Use `utf8.count`
            UInt32(accountName.utf8.count), accountName, //### Use `utf8.count`
            nil,
            nil,  /* No password retrieval required */
            &itemRef) /* The item reference */

        if status != errSecSuccess {
            print(String(format: "Error (%i) while trying to find keychain item to edit for name: %@ account: %@", Int(status), searchName, accountName))

            myAlerts.SPOnewayAlertSheet(title: NSLocalizedString("Error retrieving Keychain item to edit", comment: "error finding keychain item to edit message"), docWindow: mainWindow, msg: String(format: NSLocalizedString("An error occured while trying to retrieve the Keychain item you're trying to edit. Repairing your Keychain might resolve this, but if it doesn't please report it to the Sequel Pro team, supplying the error code %i.", comment: "error finding keychain item to edit informative message"), status))
            return
        }

        // Set up the attributes to modify
        var attrString: ContiguousArray<CChar>?
        var attrStringP = UnsafeMutableRawPointer(&attrString)
        var attrStringS = attrString?.count ?? 0

        attrString = newAccount?.utf8CString
        attrStringP = UnsafeMutableRawPointer(&attrString)
        attrStringS = attrString?.count ?? 0

        attributes[0].tag = SecItemAttr.accountItemAttr.rawValue
        attributes[0].data = attrStringP
        attributes[0].length = UInt32(truncating: attrStringS as NSNumber)
        
        attrString = newName?.utf8CString
        attrStringP = UnsafeMutableRawPointer(&attrString)
        attrStringS = attrString?.count ?? 0
        
        attributes[1].tag = SecItemAttr.serviceItemAttr.rawValue
        attributes[0].data = attrStringP
        attributes[0].length = UInt32(truncating: attrStringS as NSNumber)

        attList.count = 2
        let attributesP = UnsafeMutablePointer(&attributes)
        attList.attr = attributesP

        // Amend the keychain item
        var newPassword = password
        let newPasswordS = newPassword?.count ?? 0
        
        withUnsafePointer(to: &newPassword) { ptr in
            let newPasswordP = UnsafeRawPointer(ptr)
            status = SecKeychainItemModifyAttributesAndData(
                itemRef!,
                &attList,
                UInt32(truncating: newPasswordS as NSNumber),  /* Length of password */
                newPasswordP)  /* Password data */
        }

        if status != errSecSuccess {

            // An error of -25299 indicates that the keychain item is a duplicate.  As connection names include a unique ID,
            // this indicates an issue when previously altering keychain items; delete the old item and try again.
            if Int(status) == -25299 {
                deletePassword(forName: newName, account: newAccount)

                return updateItem(withName: name, account: account, toName: newName, account: newAccount, password: password)
            }

            print(String(format: "Error (%i) while updating keychain item for name: %@ account: %@", Int(status), name ?? "", account ?? ""))

            myAlerts.SPOnewayAlertSheet(title: NSLocalizedString("Error updating Keychain item", comment: "error updating keychain item message"), docWindow: mainWindow, msg: String(format: NSLocalizedString("An error occured while trying to update the Keychain item. Repairing your Keychain might resolve this, but if it doesn't please report it to the Sequel Pro team, supplying the error code %i.", comment: "error updating keychain item informative message"), status))
        }
    }

    func name(forFavoriteName favoriteName: String?, id favoriteId: String?) -> String? {
        // Look up the keychain name using long longs to support 64-bit > 32-bit keychain usage
        return String(format: "Sequel Pro : %@ (%lld)", favoriteName != nil ? favoriteName ?? "" : "" , Int64(favoriteId ?? "") ?? 0)
    }

    func account(forUser user: String?, host: String?, database: String?) -> String? {
        let userStr: String? = user ?? ""
        let hostStr: String? = host ?? ""
        let databaseStr: String? = database ?? ""
        return "\(String(describing: userStr))@\(String(describing: hostStr))/\(String(describing: databaseStr))"
    }

    func nameForSSH(forFavoriteName favoriteName: String?, id favoriteId: String?) -> String? {
        // Look up the keychain name using long longs to support 64-bit > 32-bit keychain usage
        let favoriteNameStr: String = favoriteName ?? ""
        let favoriteIdNum = Int64(favoriteId ?? "0")
        return String(format: "Sequel Pro SSHTunnel : %@ (%lld)", favoriteNameStr, favoriteIdNum!)
    }

    func account(forSSHUser theSSHUser: String?, sshHost theSSHHost: String?) -> String? {
        let sshUserStr = theSSHUser ?? ""
        let sshHostStr = theSSHHost ?? ""
        return "\(sshUserStr)@\(sshHostStr)"
    }

    override init() {
        super.init()
        let cleartext = ProcessInfo.processInfo.environment["LIBMYSQL_ENABLE_CLEARTEXT_PLUGIN"]
        if cleartext != nil {
            print("LIBMYSQL_ENABLE_CLEARTEXT_PLUGIN is set. Disabling keychain access. See Issue #2437")
        }
    }
}
