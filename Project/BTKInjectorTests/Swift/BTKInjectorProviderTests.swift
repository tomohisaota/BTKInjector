//
//  BTKInjectorProviderTests.swift
//  BTKInjector
//
//  Created by mono on 1/14/15.
//  Copyright (c) 2015 Tomohisa Ota. All rights reserved.
//

import XCTest

class BTKInjectorProviderTests: XCTestCase {    
    func testCircularReferenceWithInstance() {
        let injector = BTKGlobalInjector.injectorWithBlock { mInjector in
            mInjector.bindProtocol(BTKTestProtocol1.self) { i in
                let o = BTKTestProtocol1Impl()
                o.protocol2 = i.proxyFor(BTKTestProtocol2.self) as BTKTestProtocol2
                return o
            }
            mInjector.bindProtocol(BTKTestProtocol2.self) { i in
                let o = BTKTestProtocol2Impl()
                o.protocol3 = i.proxyFor(BTKTestProtocol3.self) as BTKTestProtocol3
                return o
            }
            mInjector.bindProtocol(BTKTestProtocol3.self) { i in
                let o = BTKTestProtocol3Impl()
                o.protocol1 = i.proxyFor(BTKTestProtocol1.self) as BTKTestProtocol1
                return o
            }
        }
        let o = injector.proxyFor(BTKTestProtocol1.self) as BTKTestProtocol1
        XCTAssertTrue(o.conformsToProtocol(BTKTestProtocol1.self))
        XCTAssertTrue(o.protocol2.conformsToProtocol(BTKTestProtocol2.self))
        XCTAssertTrue(o.protocol2.protocol3.conformsToProtocol(BTKTestProtocol3.self))
        XCTAssertEqual("test1", o.test1())
        XCTAssertEqual("test2", o.protocol2.test2())
        XCTAssertEqual("test3", o.protocol2.protocol3.test3())
        XCTAssertEqual("test1", o.protocol2.protocol3.protocol1.test1())
    }
}
