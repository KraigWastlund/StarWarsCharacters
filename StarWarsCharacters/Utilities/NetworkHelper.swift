//
//  NetworkHelper.swift
//  StarWarsCharacters
//
//  Created by Kraig Wastlund on 6/2/19.
//  Copyright © 2019 Kraig Wastlund. All rights reserved.
//

import Foundation

struct NetworkHelper {
    
    static func networkRequest(url: URL) -> URLRequest? {
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
