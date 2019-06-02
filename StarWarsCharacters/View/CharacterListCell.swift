//
//  CharacterListCell.swift
//  StarWarsCharacters
//
//  Created by Kraig Wastlund on 6/2/19.
//  Copyright © 2019 Kraig Wastlund. All rights reserved.
//

import UIKit
import DBC

let _cellHeight: CGFloat = 80
fileprivate let _imagePadding: CGFloat = 12
fileprivate let _imageDim: CGFloat = _cellHeight - (_imagePadding * 2)
fileprivate let _dotDim: CGFloat = 15

class CharacterListCell: UITableViewCell {

//    static let cellHeight: CGFloat = 80
//    private static let imagePadding: CGFloat = 12
//    private static let imageWidth: CGFloat = cellHeight - (CharacterListCell.imagePadding * 2)
    // private let customBackgroundView = UIView()
    
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
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        // don't clear out color of the custom view on selection ##hack
//        let color = customBackgroundView.backgroundColor
//        super.setSelected(selected, animated: animated)
//
//        if selected {
//            customBackgroundView.backgroundColor = color
//        }
//        // don't clear out color of the custom view on selection ##hack
//    }
//
//    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        // don't clear out color of the custom view on selection ##hack
//        let color = customBackgroundView.backgroundColor
//        super.setHighlighted(highlighted, animated: animated)
//
//        if highlighted {
//            customBackgroundView.backgroundColor = color
//        }
//        // don't clear out color of the custom view on selection ##hack
//    }
    
    private func setup() {
        
        // transparent background
        backgroundColor = .clear
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        nameLabel.font = .systemFont(ofSize: 24, weight: .light)
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
        
        // custom background view for UI selection hack
//        customBackgroundView.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(customBackgroundView)
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": customBackgroundView]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": customBackgroundView]))
//        sendSubviewToBack(customBackgroundView)
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
            // s.customBackgroundView.backgroundColor = affiliation.color()
            s.dot.backgroundColor = affiliation.color()
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
