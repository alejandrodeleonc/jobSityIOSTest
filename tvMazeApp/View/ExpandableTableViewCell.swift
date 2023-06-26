//
//  ExpandableTableViewCell.swift
//  tvMazeApp
//
//  Created by Alejandro De León on 26/6/23.
//

import UIKit

class ExpandableTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var episodes: [Episode] = []
    var isExpanded: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    func configure(withTitle title: String, episodes: [Episode], isExpanded: Bool) {
        titleLabel.text = title
        self.episodes = episodes
        self.isExpanded = isExpanded
    }
}

extension ExpandableTableViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isExpanded ? episodes.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let episode = episodes[indexPath.row]
        // Configure the cell with episode data
        // cell.titleLabel.text = episode.name
        // cell.numberLabel.text = "\(episode.number)"
        // ...
        return cell
    }
}
