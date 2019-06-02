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
    
    var member: Member!
    var context: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        require(context != nil)
        require(member != nil)
        ProfileImage.getProfileImage(for: member, newUrl: nil, in: context, completion: { [weak self] (profileImage) in
            guard let s = self else { return }
            guard let profileImage = profileImage else { return }
            guard let image = profileImage.image else { return }
            s.imageView.image = UIImage(data: image)
        })
        
        setup()
    }
        
    private func setup() {
        view.backgroundColor = member.affiliation?.color()
        nameLabel.text = member.displayName()
        birthdayLabel.text = member.displayBirthday()
        forceSensitiveLabel.text = member.displayForceSensitive()
        affiliationLabel.text = member.displayAffiliation()
    }
}
