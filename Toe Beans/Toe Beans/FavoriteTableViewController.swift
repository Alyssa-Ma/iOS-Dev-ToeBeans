//
//  FavoriteTableViewController.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 4/19/21.
//

import UIKit

protocol FavoriteDelegate : AnyObject {
    func addFavorite(with string: String) -> String
}
class FavoriteTableViewController: UITableViewController{

    var items = [FavoriteItem]()
    var favoriteString: String?
    private var string: String?
    public weak var delegate: FavoriteDelegate?
    static let identifier = "FavoriteDelegate?"
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //let item1 = FavoriteItem()
        let item1 = FavoriteItem()
        item1.text = "test1"
        items.append(item1)
        
        let item2 = FavoriteItem()
        item2.text = "test2"
        items.append(item2)
    }

    
    // MARK: - Helper methods
    func configureText(for cell: UITableViewCell, with item: FavoriteItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    public func getString(with string: String) -> String {
        self.string = string
        print("test access inside cell favorite \(string)")
        return string
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteItem", for: indexPath)
        favoriteString = delegate?.addFavorite(with: string!)
        print("favorite string test \(favoriteString)")
        let item = items[indexPath.row]
        configureText(for: cell, with: item)
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
