//
//  CharacterListCell.swift
//  StarWarsCharacters
//
//  Created by Kraig Wastlund on 6/2/19.
//  Copyright © 2019 Kraig Wastlund. All rights reserved.
//

import UIKit
import DBC

fileprivate let _imagePadding: CGFloat = 12
fileprivate let _imageDim: CGFloat = CharacterListCell.cellHeight - (_imagePadding * 2)
fileprivate let _dotDim: CGFloat = 20

class CharacterListCell: UITableViewCell {
    
    static let cellHeight: CGFloat = 80
    
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
    
    let dot = UIView()
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
        
        // transparent background
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        nameLabel.font = .systemFont(ofSize: 24, weight: .regular)
        nameLabel.textColor = .white
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(profileImageView)
        profileImageView.layer.cornerRadius = _imageDim / 2
        profileImageView.layer.masksToBounds = true
        
        dot.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dot)
        dot.layer.cornerRadius = _dotDim / 2
        dot.layer.masksToBounds = true
        
        // constraints
        let views = ["name": nameLabel, "image": profileImageView, "dot": dot]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[image(\(_imageDim))]-[name]-[dot(\(_dotDim))]-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(_imagePadding)-[image(\(_imageDim))]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[name]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[dot(\(_dotDim))]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        contentView.addConstraint(NSLayoutConstraint(item: dot, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
    }
    
    func populateCell(name: String, affiliation: Affiliation) {
        self.nameLabel.text = name
        self.affiliation = affiliation
    }
}

extension CharacterListCell {
    
    private func reactToAffiliationChange() {
        
        guard let affiliation = affiliation else { checkFailure("affiliation just got set"); return }
        dot.backgroundColor = affiliation.color()
        dot.alpha = 0.0
        nameLabel.alpha = 0.0
        profileImageView.alpha = 0.0
        UIView.animate(withDuration: 2.0) { [weak self] in
            guard let s = self else { return }
            s.dot.alpha = 1.0
            s.nameLabel.alpha = 1.0
            s.profileImageView.alpha = 1.0
        }
    }
    
    private func reactToImageChange() {
        
        guard let image = profileImage else { checkFailure("image just got set"); return }
        profileImageView.image = image
        setNeedsLayout()
    }
}
