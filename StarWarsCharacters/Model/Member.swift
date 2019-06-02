//
//  Member+CoreDataProperties.swift
//  RESTchallenge
//
//  Created by Kraig Wastlund on 6/1/19.
//  Copyright © 2019 Kraig Wastlund. All rights reserved.
//
//

import Foundation
import UIKit
import CoreData
import DBC

enum Affiliation: String {
    
    case JEDI
    case RESISTANCE
    case FIRST_ORDER
    case SITH
    
    func color() -> UIColor {
        switch self {
        case .JEDI:
            return UIColor.blue.withAlphaComponent(0.5)
        case .RESISTANCE:
            return UIColor.green.withAlphaComponent(0.5)
        case .FIRST_ORDER:
            return UIColor.black.withAlphaComponent(0.5)
        case .SITH:
            return UIColor.red.withAlphaComponent(0.5)
        }
    }
}

extension Affiliation: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case JEDI
        case RESISTANCE
        case FIRST_ORDER
        case SITH
    }
}

struct MemberNetworkResponse: Decodable {
    let individuals: [Member]
}

struct Member: Decodable {
    let id: Int64
    let firstName: String?
    let lastName: String?
    let birthdate: Date?
    let profilePicture: String? // TODO: RENAME!!!
    let forceSensitive: Bool
    let affiliation: Affiliation?
    
    func displayName() -> String {
        let fn = firstName ?? ""
        let ln = lastName ?? ""
        return "\(fn) \(ln)"
    }
}
