//
//  FavoritesViewController.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 4/20/21.
//

import UIKit

protocol FavoritesDelegate: AnyObject {
    func sendData(favorite: SearchRes!)
}

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    //to hold favorites
    static var favorites = [SearchRes]()
    //delegate
    var favDelegate: FavoritesDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        //reload tableview to display new
        tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    //return to previous screen
    // MARK:- IB Actions
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Table View Delegate
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return number of favorites
        return FavoritesViewController.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        //return favorite obj at row
        let favoriteCell = FavoritesViewController.favorites[indexPath.row]
        //display the place name
        cell.textLabel?.text = favoriteCell.name
        //change font of cell
        cell.textLabel?.font = UIFont(name: "Noteworthy", size: 17)
        return cell
    }
    
    //funcs for selection handling
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //favDelegate?.sendData(favorite: FavoritesViewController.favorites[indexPath.row])
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AttributesViewController {
            destination.attributesArray = FavoritesViewController.favorites[(tableView.indexPathForSelectedRow?.row)!]
            //came from favorites view
            destination.cameFromFavorite = true
        }
    }
}
