//
//  CharacterListCell.swift
//  StarWarsCharacters
//
//  Created by Kraig Wastlund on 6/2/19.
//  Copyright © 2019 Kraig Wastlund. All rights reserved.
//

import UIKit
import DBC

class CharacterListCell: UITableViewCell {

    static let cellHeight: CGFloat = 60
    private static let imageWidth: CGFloat = cellHeight - 8
    
    var affiliation: Affiliation? {
        didSet {
            reactToAffiliationChange()
        }
    }
    
    var profileImage: UIImage? {
        didSet {
            reactToImageChange()
        }
    }
    
    let nameLabel = UILabel()
    let profileImageView = UIImageView()
    
    convenience init(affiliation: Affiliation) {
        self.init()
        self.affiliation = affiliation
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    private func setup() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        nameLabel.font = .systemFont(ofSize: 24, weight: .light)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(profileImageView)
        
        // constraints
        let views = ["name": nameLabel, "image": profileImageView]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[image(\(CharacterListCell.imageWidth))][name]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[image]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[name]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
    }
    
    func populateCell(name: String, affiliation: Affiliation) {
        self.nameLabel.text = name
        self.affiliation = affiliation
    }
}

extension CharacterListCell {
    
    private func reactToAffiliationChange() {
        
        guard let affiliation = affiliation else { checkFailure("affiliation just got set"); return }
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let s = self else { return }
            s.contentView.backgroundColor = affiliation.color()
        }) { (complete) in
            // do stuff?
        }
    }
    
    private func reactToImageChange() {
        
        guard let image = profileImage else { checkFailure("image just got set"); return }
        
        profileImageView.image = image
        setNeedsLayout()
    }
}

extension CharacterListCell {
    
    func downloadProfilePicture(from url: URL) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            
            DispatchQueue.main.async() {
                self.profileImage = image
            }
            }.resume()
    }
}
