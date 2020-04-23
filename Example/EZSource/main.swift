//
//  main.swift
//  mFind
//
//  Created by Alex Hmelevski on 2017-02-24.
//  Copyright © 2017 Aldo Group Inc. All rights reserved.
//

import Foundation
import UIKit

private func delegateClassName() -> String? {
    return NSClassFromString("XCTestCase") == nil ? NSStringFromClass(AppDelegate.self) : NSStringFromClass(AppDelegateTests.self)
}

let unsafeMutablePointer = UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory( to: UnsafeMutablePointer<Int8>?.self,
                                                                                       capacity: Int(CommandLine.argc))

UIApplicationMain(CommandLine.argc, unsafeMutablePointer, nil, delegateClassName())
