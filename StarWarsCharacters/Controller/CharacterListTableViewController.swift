//
//  CharacterListTableViewController.swift
//  StarWarsCharacters
//
//  Created by Kraig Wastlund on 6/2/19.
//  Copyright © 2019 Kraig Wastlund. All rights reserved.
//

import UIKit
import CoreData
import DBC

class CharacterListTableViewController: UITableViewController {
    
    private var members = [Member]()
    var context: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = LocalizedStrings.galacticPersonell
        setup()
    }
    
    private func setup() {
        
        title = LocalizedStrings.galacticPersonell
        
        tableView.register(CharacterListCell.self, forCellReuseIdentifier: "cell")
        
        // network call
        
        URLSession.shared.apiGetCall(urlSuffix: "", type: MemberNetworkResponse.self) { [weak self] (success, result) in
            guard let s = self else { return }
            guard success == true else { return }
            guard let r = result as? MemberNetworkResponse else { checkFailure("We didn't get the object back we were expecting? (Member)"); return }
            s.members = r.individuals
            s.tableView.reloadData()
        }
    }

    // MARK: - Table view datasource/delegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CharacterListCell.cellHeight
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CharacterListCell else { return UITableViewCell() }
        
        let currentMember = members[indexPath.row]
        
        cell.populateCell(name: currentMember.displayName(), affiliation: currentMember.affiliation!)
        guard let urlString = currentMember.profilePicture else { checkFailure("each member should have a pic url"); return UITableViewCell() }
        ProfileImage.getProfileImage(for: currentMember, newUrl: urlString, in: context) { (profileImage) in
            guard let profileImage = profileImage else { checkFailure("fail get image"); return }
            guard let image = profileImage.image else { checkFailure("fail get image"); return }
            cell.profileImage = UIImage(data: image)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // navigate to detail view
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
