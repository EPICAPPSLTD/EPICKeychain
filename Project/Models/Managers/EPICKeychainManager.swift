//
//  EPICKeychainManager.swift
//  EPICKeychain
//
//  Created by Danny Bravo on 25/09/2015.
//  Copyright © 2015 EPIC. All rights reserved.
//

import Foundation

final class EPICKeychainManager {
    
    //MARK: - utitilites
    /**
    Use this method to store, or update a password previously saved into the keychain
    - parameter password: the password to store in the keychain
    - parameter key: the key to associate the password in the keychain, if a password already exists for this key in the keychain, the password will be overriden.
    - parameter hash: a boolean value specifying if the password should be hashed before storing itself in the keychain. The hash will be a one way SHA-512 encryption, adding an extra layer of security to the keychain item. Setting this value to true is recommended, but if you will need retrieve the original representation of the password without the hash then you should set this value to false.
    - returns: a boolean indicating that the `password` parameter was successfully stored in the keychain.
    */
    class func storePassword(password:String, forKey key:String, hash: Bool, iCloudAccessGroup: String?) -> Bool {
        let password = hash ? encryptPassword(password) : password
        if checkIfKeyExists(key) {
            return updatePassword(password, forKey: key, iCloudAccessGroup: iCloudAccessGroup)
        }
        return createNewPassword(password, forKey: key, iCloudAccessGroup: iCloudAccessGroup)
    }
    
    /**
     A convenience method for validating a password against values stored in the keychain
     - warning: If your keychain item is shared accross multiple devices, removing an item from the keychain will remove the password from all devices
     - parameter password: the password to compare against a stored value in the keychain
     - parameter key: the key for the password that is already stored in the keychain, which will be compared against the `password` parameter
     - parameter hash: a boolean value specifying if the password to be compared needs to be hashed in order to successfully compare against the one stored in the keychain. This value should reflect what you set when originally storing the password in the keychain.
     - returns: a boolean indicating that the `password` parameter matches the password stored previously in the keychain. If no password was found in the keychain this method will return `false`
     */
    class func checkPassword(password:String, forKey key:String, hash: Bool) -> Bool {
        let password = hash ? encryptPassword(password) : password
        if let storedPassword = passwordForKey(key) {
            return storedPassword == password
        }
        return false
    }
    
    /**
     Returns the password data, if found, for a given key in the keychain
     - warning: If your keychain item is shared accross multiple devices, removing an item from the keychain will remove the password from all devices
     - parameter key: the key for password you want to remove from the keychain
     - returns: the string representation of the password as it was originally stored in the keychain, if found.
     */
    class func passwordForKey(key:String) -> String? {
        var attributes = baseDictionaryForKey(key)
        attributes[String(kSecReturnData)] = NSNumber(bool: true)
        var data : AnyObject?
        if SecItemCopyMatching(attributes, &data) == errSecSuccess {
            if let data = data as? NSData {
                return String(data: data, encoding: NSUTF8StringEncoding)
            }
        }
        return nil
    }
    
    /**
     Use this function to remove a password item from the keychain
     - warning: If your keychain item is shared accross multiple devices, removing an item from the keychain will remove the password from all devices
     - parameter key: the key for password you want to remove from the keychain
     - returns: a boolean verifying that the password was effectively removed from the keychain. If the password was not present in the keychain when this method gets called, the method will return `true`
    */
    class func removePasswordForKey(key:String) -> Bool {
        if checkIfKeyExists(key) {
            let attributes = baseDictionaryForKey(key)
            return SecItemDelete(attributes) == errSecSuccess
        }
        return true
    }
    
    //MARK: - private utilties
    private class func encryptPassword(password:String) -> String {
        if let password = password.hashUsingAlgorithm(.SHA512) {
            return password
        }
        return password
    }
    
    private class func createNewPassword(password:String, forKey key:String, iCloudAccessGroup: String?) -> Bool {
        let data = password.dataUsingEncoding(NSUTF8StringEncoding)
        var attributes = baseDictionaryForKey(key)
        attributes[String(kSecValueData)] = data
        if let iCloudAccessGroup = iCloudAccessGroup {
            attributes[String(kSecAttrSynchronizable)] = kCFBooleanTrue
            attributes[String(kSecAttrAccessGroup)] = iCloudAccessGroup
        }
        return SecItemAdd(attributes, nil) == errSecSuccess
    }
    
    private class func updatePassword(password:String, forKey key:String, iCloudAccessGroup: String?) -> Bool {
        let attributes = baseDictionaryForKey(key)
        let data = password.dataUsingEncoding(NSUTF8StringEncoding)
        var changes = [String: AnyObject]()
        changes[String(kSecValueData)] = data
        if let iCloudAccessGroup = iCloudAccessGroup {
            changes[String(kSecAttrSynchronizable)] = kCFBooleanTrue
            changes[String(kSecAttrAccessGroup)] = iCloudAccessGroup
        }
        return SecItemUpdate(attributes, changes) == errSecSuccess
    }
    
    private class func checkIfKeyExists(key:String) -> Bool {
        if let _ = passwordForKey(key) {
            return true
        }
        return false
    }
    
    private class func baseDictionaryForKey(key:String) -> [String: AnyObject] {
        var attributes = [String: AnyObject]()
        attributes[String(kSecClass)] = String(kSecClassGenericPassword)
        attributes[String(kSecAttrService)] = "EPICKeychainManager"
        attributes[String(kSecAttrAccount)] = key
        return attributes
    }

}