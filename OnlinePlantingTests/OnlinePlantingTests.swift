//
//  OnlinePlantingTests.swift
//  OnlinePlantingTests
//
//  Created by Alex on 4/24/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import XCTest

class OnlinePlantingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testSaveLocation() {
        let locationArray: [String: String] = ["countryCode": "111", "country": "China", "province": "Zhe Jiang", "city": "Ningbo", "subLocality": "Yinzhou", "street": "yangfan"]
        let dataJson: NSData! = try? JSONSerialization.data(withJSONObject: locationArray, options: []) as NSData!
        let JSONString = NSString(data: dataJson as Data, encoding: String.Encoding.utf8.rawValue)
        
//        let json = JSON(JSONString!).dictionaryObject
//        Sync.changes([json!], inEntityNamed: "Location", dataStack: appDelegate.dataStack, completion: { [weak self] (error) in
//            if error != nil {
//                print("location saveing error")
//            } else {
//                print("location saved successfully")
//                //self?.fetchCurrentUserObjects()
//            }
//        })

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
