//
//  BTKInjectorDuckTypingTests.swift
//  BTKInjector
//
//  Created by mono on 1/14/15.
//  Copyright (c) 2015 Tomohisa Ota. All rights reserved.
//

import XCTest

/**
*  Swiftでは、XCTAssertThrowsSpecificNamed相当のassertionや、try-catchが無いのでtestWithoutDuckTypingが記述出来ない
*/
class BTKInjectorDuckTypingTests: XCTestCase {

    func testWithDuckTyping() {
        let injector = BTKGlobalInjector.injectorWithBlock { mInjector in
            mInjector.bindProtocol(BTKTestProtocol4.self, forceConform: true) { injector in
                return BTKTestProtocol1Impl()
            }
        }
        let proxy = injector.proxyFor(BTKTestProtocol4.self) as BTKTestProtocol1
        XCTAssertTrue(proxy.isKindOfClass(BTKTestProtocol1Impl.self))
        let obj = proxy as BTKTestProtocol1Impl
        XCTAssertEqual(obj.test1(), "test1")
    }
}
