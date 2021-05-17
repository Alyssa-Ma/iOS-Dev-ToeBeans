//
//  SearchResultCell.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 4/30/21.
//

import UIKit

//custom tablecell setup
class SearchResultCell: UITableViewCell{

    var string: String = ""
    var stringTest: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(named: "SearchResultColor")?.withAlphaComponent(0.5)
        selectedBackgroundView = selectedView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK:- Outlet Properties
    @IBOutlet var companyNameLabel: UILabel!
    
}

