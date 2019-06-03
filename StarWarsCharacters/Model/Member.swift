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
            return Colors.navyBlue
        case .RESISTANCE:
            return Colors.greyBlue
        case .FIRST_ORDER:
            return Colors.maroon
        case .SITH:
            return Colors.red
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
    let profilePicture: String?
    let forceSensitive: Bool
    let affiliation: Affiliation?
    
    func displayName() -> String {
        let fn = firstName ?? ""
        let ln = lastName ?? ""
        return "\(fn) \(ln)"
    }
    
    func displayBirthday() -> String? {
        guard let birthDate = birthdate else { checkFailure("no birth date on model"); return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE MMM d, yyyy"
        let formattedBirthDate = dateFormatter.string(from: birthDate)
        return String(format: LocalizedStrings.birthDate_colon, formattedBirthDate)
    }
    
    func displayForceSensitive() -> String {
        return String(format: LocalizedStrings.forceSensitive_colon, forceSensitive ? "Yes" : "No")
    }
    
    func displayAffiliation() -> String {
        guard let affiliation = affiliation else { return "" }
        switch affiliation {
        case .FIRST_ORDER:
            return "First Order"
        case .SITH:
            return "Sith"
        case .RESISTANCE:
            return "Resistance"
        case .JEDI:
            return "Jedi"
        }
    }
    
    func displayAffiliationImage() -> UIImage {
        guard let affiliation = affiliation else { return UIImage() }
        switch affiliation {
        case .FIRST_ORDER:
            return #imageLiteral(resourceName: "firstorder-symbol")
        case .SITH:
            return #imageLiteral(resourceName: "sith-symbol")
        case .RESISTANCE:
            return #imageLiteral(resourceName: "resistance-symbol")
        case .JEDI:
            return #imageLiteral(resourceName: "jedi-symbol")
        }
    }
}
