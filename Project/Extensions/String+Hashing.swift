//
//  String+Hashing.swift
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

extension String  {
    
    func hashUsingAlgorithm(algorithm: HashAlgorithm) -> String? {
        if let data = self.dataUsingEncoding(NSUTF8StringEncoding) {
            return data.hashUsingAlgorithm(algorithm)
        }
        return nil;
    }
    
}