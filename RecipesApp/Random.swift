//
//  Random.swift
//  RareAvis
//
//  Created by Alex Zimin on 04/10/15.
//  Copyright © 2015 Triangle Glow. All rights reserved.
//

import Foundation
import Darwin

extension Int {
  static func random() -> Int {
    return Int(arc4random())
  }
  
  static func random(range: Range<Int>) -> Int {
    return Int(arc4random_uniform(UInt32(range.endIndex - range.startIndex))) + range.startIndex
  }
}

extension Double {
  static func random() -> Double {
    return drand48()
  }
}