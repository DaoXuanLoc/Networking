//
//  RepoTableViewCell.swift
//  NetWorking
//
//  Created by Dao Xuan Loc on 1/5/21.
//

import UIKit

class RepoTableViewCell: UITableViewCell {
    
    @IBOutlet weak private var nameRepoLabel: UILabel!
    @IBOutlet weak private var urlRepoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configCell(repo: Repository) {
        nameRepoLabel.text = repo.repoName
        urlRepoLabel.text = repo.repoUrl
    }
}
