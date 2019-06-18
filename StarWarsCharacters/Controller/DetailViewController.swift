//
//  DetailViewController.swift
//  StarWarsCharacters
//
//  Created by Kraig Wastlund on 6/2/19.
//  Copyright © 2019 Kraig Wastlund. All rights reserved.
//

import UIKit
import DBC
import CoreData

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var forceSensitiveLabel: UILabel!
    @IBOutlet weak var affiliationLabel: UILabel!
    @IBOutlet weak var affiliationImageView: UIImageView!
    @IBOutlet weak var affiliationColorView: UIView!
    
    var member: Member!
    var context: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        require(context != nil)
        require(member != nil)
        
        setup()
    }
        
    private func setup() {
        
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "black_space"))
        
        // get image from core data
        ProfileImage.getProfileImage(for: member, newUrl: nil, in: context, completion: { [weak self] (profileImage) in
            guard let s = self else { return }
            guard let profileImage = profileImage else { return }
            guard let image = profileImage.image else { return }
            s.imageView.image = UIImage(data: image)
        })
        
        // set info
        nameLabel.text = member.displayName()
        birthdayLabel.text = member.displayBirthday()
        forceSensitiveLabel.text = member.displayForceSensitive()
        affiliationLabel.text = member.displayAffiliation()
        affiliationImageView.image = member.displayAffiliationImage()
        affiliationColorView.backgroundColor = member.affiliation?.color()
    }
}
