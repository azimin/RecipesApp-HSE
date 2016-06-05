//
//  SwiftCommonHelpers.swift
//  Uberchord
//
//  Created by Alex Zimin on 11/01/16.
//  Copyright © 2016 Uberchord Engineering. All rights reserved.
//

import Foundation

func dispatchAfter(time: NSTimeInterval, executionBlock: () -> ()) {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
		executionBlock()
	})
}

func dispatchInMainQueue(executionBlock: () -> ()) {
  dispatch_async(dispatch_get_main_queue(), { () -> Void in
    executionBlock()
  })
}

func dispatchInMainQueueIfNeeded(executionBlock: () -> ()) {
  if NSThread.currentThread().isMainThread {
    executionBlock()
  } else {
    dispatch_async(dispatch_get_main_queue()) {
      executionBlock()
    }
  }
}

class DispatchHelper: NSObject {
  static func dispatchInMainQueueIfNeededFunction(executionBlock: () -> ()) {
    dispatchInMainQueueIfNeeded(executionBlock)
  }
}
