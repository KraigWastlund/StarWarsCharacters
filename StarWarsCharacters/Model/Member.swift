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
    
//    enum PostTypeCodingError: Error {
//        case decoding(String)
//    }
//    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        if let _ = try? values.decode(Int.self, forKey: .JEDI) {
//            self = .JEDI
//            return
//        }
//        if let _ = try? values.decode(String.self, forKey: .RESISTANCE) {
//            self = .RESISTANCE
//            return
//        }
//        if let _ = try? values.decode(String.self, forKey: .FIRST_ORDER) {
//            self = .FIRST_ORDER
//            return
//        }
//        if let _ = try? values.decode(String.self, forKey: .SITH) {
//            self = .SITH
//            return
//        }
//        throw PostTypeCodingError.decoding("Something went wrong decoding `Affiliation`: \(dump(values))")
//    }
}

struct MemberNetworkResponse: Decodable {
    let individuals: [Member]
}

struct Member: Decodable {
    let id: Int64
    let firstName: String?
    let lastName: String?
    let birthdate: Date?
    let profilePicture: String?
    let forceSensitive: Bool
    let affiliation: Affiliation?
    
    func displayName() -> String {
        let fn = firstName ?? ""
        let ln = lastName ?? ""
        return "\(fn) \(ln)"
    }
}
