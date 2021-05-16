//
//  FavoritesViewController.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 5/16/21.
//

import UIKit

protocol FavoritesDelegate: AnyObject {
    func sendData() -> String
}

class FavoritesViewController: UIViewController {    

    @IBOutlet weak var tableView: UITableView!
    //to hold favorites
    static var favorites = [SearchRes]()
    //delegate data to favorites
    var delegate: FavoritesDelegate?
    var test: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //reload tableview to display new
        self.tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        //test = delegate?.sendData()
        print("favorites view test \(test)")
    }
            
    // MARK:- IB Actions
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Table View Delegate
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoritesViewController.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        //return favorite cell in index
        let favoriteCell = FavoritesViewController.favorites[indexPath.row]
        //display the place name
        cell.textLabel?.text = favoriteCell.name
        return cell
    }
    
    //funcs for selection handling
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //show attributes when tapping on cell
        performSegue(withIdentifier: "FavoriteShowAttributes", sender: self)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if FavoritesViewController.favorites.count == 0 {
            return nil
        } else {
            return indexPath
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //option to delete favorite
        if editingStyle == .delete {
            FavoritesViewController.favorites.remove(at: indexPath.row)
        }
        //reload tableview after deleting
        tableView.reloadData()
    }
}
