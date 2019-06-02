//
//  StarWarsCharactersTests.swift
//  StarWarsCharactersTests
//
//  Created by Kraig Wastlund on 6/2/19.
//  Copyright © 2019 Kraig Wastlund. All rights reserved.
//

import XCTest
@testable import StarWarsCharacters

class StarWarsCharactersTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testHexColor() {
        let color = UIColor.fromHexString(hex: "cccccc")
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        XCTAssert(red == 0.8, "Failed to get the correct amount of red.")
        XCTAssert(green == 0.8, "Failed to get the correct amount of green.")
        XCTAssert(blue == 0.8, "Failed to get the correct amount of blue.")
        XCTAssert(alpha == 1.0, "Failed to get the correct amount of alpha.")
    }
    
    func testDateFormatter() {
        struct Test: Codable {
            let date: Date
        }
        let json = """
                        {
                        "date": "2019-04-10"
                        }
                        """ // server date string
        let data = Data(json.utf8)
        let test = try? JSONDecoder.challengeDecoder().decode(Test.self, from: data)
        XCTAssert(test?.date.timeIntervalSince1970 == 1554854400.0, "Failed to get expected date.")
    }
}
