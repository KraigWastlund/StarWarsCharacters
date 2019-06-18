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

enum Affiliation: String, Decodable, CaseIterable {
    
    case jedi = "JEDI"
    case resistance = "RESISTANCE"
    case firstOrder = "FIRST_ORDER"
    case sith = "SITH"
    
    func color() -> UIColor {
        switch self {
        case .jedi:
            return Colors.jedi
        case .resistance:
            return Colors.resistance
        case .firstOrder:
            return Colors.firstOrder
        case .sith:
            return Colors.sith
        }
    }
    
    func displayTitle() -> String {
        switch self {
        case .firstOrder:
            return "First Order"
        case .sith:
            return "Sith"
        case .resistance:
            return "Resistance"
        case .jedi:
            return "Jedi"
        }
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
        return affiliation.displayTitle()
    }
    
    func displayAffiliationImage() -> UIImage {
        guard let affiliation = affiliation else { return UIImage() }
        switch affiliation {
        case .firstOrder:
            return #imageLiteral(resourceName: "firstorder-symbol")
        case .sith:
            return #imageLiteral(resourceName: "sith-symbol")
        case .resistance:
            return #imageLiteral(resourceName: "resistance-symbol")
        case .jedi:
            return #imageLiteral(resourceName: "jedi-symbol")
        }
    }
}
