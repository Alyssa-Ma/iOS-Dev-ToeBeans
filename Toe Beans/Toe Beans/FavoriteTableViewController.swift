//
//  FavoriteTableViewController.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 4/19/21.
//

import UIKit

class FavoriteTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteItem", for: indexPath)
        return cell
    }
    
    // MARK:- IB Actions
    @IBAction func close()
    {
        dismiss(animated: true, completion: nil)
    }

}
