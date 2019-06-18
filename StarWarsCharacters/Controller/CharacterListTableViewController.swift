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

struct MemberSection {
    let members: [Member]
    let sectionTitle: String
}

let _useLargeTestData = false

class CharacterListTableViewController: UITableViewController {
    
    private var memberSections = [MemberSection]()
    var context: NSManagedObjectContext!
    var selectedMember: Member?
    var backgroundImages = [#imageLiteral(resourceName: "space_02"), #imageLiteral(resourceName: "space_01"), #imageLiteral(resourceName: "space_03"), #imageLiteral(resourceName: "space_06"), #imageLiteral(resourceName: "space_05"), #imageLiteral(resourceName: "space_04")]
    var imageIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        require(context != nil)
        
        title = LocalizedStrings.listTitle
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        require(backgroundImages.count > 0)
        let index = imageIndex % backgroundImages.count
        let imageView = UIImageView(image: backgroundImages[index])
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFill
        tableView.backgroundView = imageView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectedMember = nil
        imageIndex += 1
    }
    
    private func setup() {
        
        tableView.register(CharacterListCell.self, forCellReuseIdentifier: "cell")
        
        if _useLargeTestData {
            if let path = Bundle.main.path(forResource: "test", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let memberNetworkResponse = try JSONDecoder.challengeDecoder().decode(MemberNetworkResponse.self, from: data)
                    memberSections = CharacterListTableViewController.memberSections(from: memberNetworkResponse.individuals)
                } catch {
                    fatalError()
                }
            }
        } else {
            URLSession.shared.apiGetCall(urlSuffix: "", type: MemberNetworkResponse.self) { [weak self] (success, result) in
                guard let s = self else { return }
                guard success == true else { return }
                guard let r = result as? MemberNetworkResponse else { checkFailure("We didn't get the object back we were expecting? (Member)"); return }
                s.memberSections = CharacterListTableViewController.memberSections(from: r.individuals)
                s.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view datasource/delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return memberSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberSections[section].members.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CharacterListCell.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 200, height: 20))
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        headerView.addSubview(titleLabel)
        titleLabel.text = memberSections[section].sectionTitle.uppercased()
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CharacterListCell else { return UITableViewCell() }
        
        cell.resetImageView()
        let section = memberSections[indexPath.section]
        let currentMember = section.members[indexPath.row]
        
        if let affiliation = currentMember.affiliation, let urlString = currentMember.profilePicture {
            
            cell.populateCell(name: currentMember.displayName(), affiliation: affiliation)
            
            ProfileImage.getProfileImage(for: currentMember, newUrl: urlString, in: context) { (profileImage) in
                guard let profileImage = profileImage else { checkFailure("fail get image"); return }
                guard let image = profileImage.image else { checkFailure("fail get image"); return }
                cell.profileImage = UIImage(data: image)
            }
        } else {
            checkFailure("We failed to get properties for member")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = memberSections[indexPath.section]
        selectedMember = section.members[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: self)
        
        SoundManager.shared().playSound()
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showDetail" else { checkFailure("only segue possible!"); return }
        guard let vc = segue.destination as? DetailViewController else { checkFailure("only vc possible!"); return }
        guard let selectedMember = self.selectedMember else { checkFailure("Should have selected."); return }
        
        vc.member = selectedMember
        vc.context = context
    }
    
    // MARK: DATASOURCE HELPER
    
    static func memberSections(from members: [Member]) -> [MemberSection] {
        var memberSections = [MemberSection]()
        
        for aff in Affiliation.allCases {
            let members = members.filter{ $0.affiliation == aff}
            memberSections.append(MemberSection(members: members, sectionTitle: aff.displayTitle()))
        }
        
        return memberSections
    }
}
