//
//  NSDate+Hashing.swift
//  EPICHashing
//
//  Created by Danny Bravo on 02/08/2015.
//  Copyright © 2015 EPIC. All rights reserved.
//  See LICENSE.txt for this sample’s licensing information
//

import Foundation

/*
NOTE: this class was imported from snippets belonging to the project EPICHashing that can be found here: https://github.com/EPICAPPSLTD/EPICHashing
Only the relevants sections of the original class were mantained in order to keep the focus on the main classes of the tutorial. For a full explanation of the class plus other niceties, feel free to read our tutorial @ http://epic-apps.uk/2015/08/10/just-saying/
*/

enum HashAlgorithm {
    case SHA512
    
    private func digestLength() -> Int {
        switch(self) {
        case .SHA512:
            return Int(CC_SHA512_DIGEST_LENGTH)
        }
    }
    
    private func hashData(data:NSData, inout digest:[UInt8]) {
        switch(self) {
        case .SHA512:
            CC_SHA512(data.bytes, CC_LONG(data.length), &digest)
        }
    }
    
}

extension NSData {

    func hashUsingAlgorithm(algorithm: HashAlgorithm) -> String {
        let hashLength = algorithm.digestLength()
        var digest = [UInt8](count:hashLength, repeatedValue: 0)
        algorithm.hashData(self, digest: &digest)
        let output = NSMutableString(capacity: hashLength)
        for byte in digest {
            output.appendFormat("%02x", byte)
        }
        return output as String
    }
    
}