//
//  ProfileImage+extension.swift
//  StarWarsCharacters
//
//  Created by Kraig Wastlund on 6/2/19.
//  Copyright © 2019 Kraig Wastlund. All rights reserved.
//

import Foundation
import DBC
import CoreData

// MARK: Utility

extension ProfileImage {
    
    static func getProfileImage(for member: Member, newUrl: String, in context: NSManagedObjectContext, completion: @escaping (_ image: ProfileImage?)->Void) {
        
        if let profileImage = ProfileImage.retreiveFromCoreData(withMemberId: member.id, in: context) {
            if profileImage.imageUrl == newUrl {
                completion(profileImage)
            } else {
                ProfileImage.deleteFromCoreData(profileImage: profileImage, in: context)
            }
        }
        
        // if i get here i need to download the new image, store in core data, and call completion
        guard let url = URL(string: newUrl) else { checkFailure("we have no url"); return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            
            ProfileImage.saveToCoreData(image: image, url: newUrl, memberId: member.id, context: context) { (profileImage) in
                completion(profileImage)
            }
            }.resume()
    }
}

// MARK: Core Data

extension ProfileImage {
    
    static func retreiveFromCoreData(withMemberId memberId: Int64, in context: NSManagedObjectContext) -> ProfileImage? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ProfileImage.description())
        request.predicate = NSPredicate(format: "memberId == %@", argumentArray: [memberId])
        
        do {
            guard let profileImages = try context.fetch(request) as? [ProfileImage] else { checkFailure("image fetch fail"); return nil }
            guard profileImages.count < 2 else { checkFailure("we should have at most one image that belongs to member."); return nil }
            
            return profileImages.first
        } catch {
            fatalError("Failed to fetch images: \(error)")
        }
    }
    
    static func saveToCoreData(image: UIImage, url: String, memberId: Int64, context: NSManagedObjectContext, completion: @escaping (_ image: ProfileImage)->Void) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ProfileImage.description())
        request.predicate = NSPredicate(format: "memberId == %@", argumentArray: [memberId])
        
        do {
            guard let profileImages = try context.fetch(request) as? [ProfileImage] else { checkFailure("image fetch fail"); return }
            guard profileImages.count < 2 else { checkFailure("we should have at most one image that belongs to member."); return }
            
            // delete old one
            if let profileImage = profileImages.first  {
                context.delete(profileImage)
            }
            
            // save image
            context.performAndWait {
                let newProfileImage = ProfileImage(context: context)
                newProfileImage.memberId = memberId
                newProfileImage.imageUrl = url
                // TODO: FIX !
                newProfileImage.image = url.hasSuffix(".png") ? image.pngData() : image.jpegData(compressionQuality: 1.0)
                
                do {
                    try context.save()
                    completion(newProfileImage)
                } catch {
                    requireFailure("Failed to save image")
                }
            }
            
        } catch {
            fatalError("Failed to fetch images: \(error)")
        }
    }
    
    static func deleteFromCoreData(profileImage: ProfileImage, in context: NSManagedObjectContext) {
        context.delete(profileImage)
    }
}
