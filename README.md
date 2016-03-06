# EPICKeychain

EPICKeychain is a utility wrapper class that manages a simplified interface for storage, retrieval, deletion and checks for passwords against the iOS Keychain, as well as added support for iCloud keychain sharing. 

#### Usage:
```swift
let created1 = EPICKeychainManager.storePassword("your password", forKey: "your key") //stores your password in the keychain for the key specified, returns true if password was succesfully stored. Can also be used to update you password in the keychain.
let created2 = EPICKeychainManager.storePassword("your password", forKey: "your key", iCloudAccessGroup: "com.yourcompany.yourapp") //stores your password in the icloud keychain for the key specified, returns true if password was succesfully stored. Can also be used to update you password in the keychain.

let isRightPassword = EPICKeychainManager.checkPassword("your password", forKey: "your key") //returns true if the key exists in the keychain and the passwords are equivalent
let password = EPICKeychainManager.passwordForKey("your key") //returns the stored password for your key, or nil if the key does not exist in the keychain

let deleted = EPICKeychainManager.removePasswordForKey(KEY) //returns true if the key/password combination was removed or not present in the keychain
```

This class serves as an extension to the tutorial of the blog article: ["Simplify Your Keychain Access"](http://epic-apps.uk/2016/03/06/simplify-your-keychain-access/). Usage is free for all based on the attached license details, if you find this code useful, please consider [letting me know](http://epic-apps.uk/contact/)! :)

Copyright (c) EPIC 
[www.epic-apps.uk](www.epic-apps.uk)