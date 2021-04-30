//
//  SearchResultCell.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 4/30/21.
//

import UIKit

class SearchResultCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK:- Outlet Properties
    @IBOutlet var businessImageView: UIImageView!
    @IBOutlet var companyNameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
}
