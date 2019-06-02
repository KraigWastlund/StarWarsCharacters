//
//  JSONDecoder+Extension.swift
//  StarWarsCharacters
//
//  Created by Kraig Wastlund on 6/2/19.
//  Copyright © 2019 Kraig Wastlund. All rights reserved.
//

import Foundation

extension JSONDecoder {
    
    enum DateError: String, Error {
        case dateFormatNotYetSupported
    }
    
    static func challengeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            
            formatter.dateFormat = "yyyy-MM-dd" // this is the expected format:  "birthdate":"1987-10-31"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            
            throw DateError.dateFormatNotYetSupported
        })
        
        return decoder
    }
}
