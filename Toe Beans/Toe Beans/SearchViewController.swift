//
//  SearchViewController.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 4/20/21.
//

import UIKit

class SearchViewController: UIViewController {
    //search result array
    var searchResults = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //prevent search bar from obscuring table view
        tableView.contentInset = UIEdgeInsets(top: 56, left: 0, bottom: 0, right: 0)
    }
    

    // MARK: - IB Outlets
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!

}

// MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //dismisses keyboard after pressing search
        searchBar.resignFirstResponder()
        //array to hold search results
        searchResults = []
        for i in 0...2 {
            searchResults.append(String(format: "Fake Result %d for '%@'", i, searchBar.text!))
        }
        //reloads table view to make new rows visible
        tableView.reloadData()
    }
    
    //fixes white line right above search bar
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

// MARK: - Table View Delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchResultCell"
        
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell.textLabel!.text = searchResults[indexPath.row]
        return cell
    }
    
    
}
