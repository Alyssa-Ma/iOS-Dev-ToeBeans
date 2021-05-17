//
//  ViewController.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 5/15/21.
//
import Foundation
import CoreLocation
import UIKit

class AttributesViewController: UITableViewController, FavoritesDelegate {
    
    var attributesArray: SearchRes!
    var vc: FavoritesViewController?
    var cameFromFavorite: Bool = false
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var addFavoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK:- Attribute Label Setup
        
        //set labels to new text and nil protection
        if attributesArray.name != nil {
            name.text = attributesArray.name!
        } else {
            name.text = "No Name"
        }
        
        if attributesArray.address != nil {
            address.text = "Address: \(attributesArray!.address!)"
        } else {
            address.text = "Address: Not listed"
        }
        
        if attributesArray.phoneNumber != nil {
            phoneNumber.text = "Phone Number: \(attributesArray!.phoneNumber!)"
        } else {
            phoneNumber.text = "Phone Number: Not listed"
        }
        
        if attributesArray.website != nil {
            website.text = "Website: \(attributesArray!.website!)"
        } else {
            website.text = "Website: Not listed"
        }
        
        if attributesArray.distance != nil {
            distance.text = "Distance: \(attributesArray!.distance!) meters"
        }
        else {
            distance.text = "Distance: Unknown"
        }
        //print(attributesArray)
    }
    
    // MARK:- Helper Methods
    
    //when view appears, if the favorite is already in the array, don't show the favorite button
    override func viewWillAppear(_ animated: Bool) {
        //loop through favorites to check
        for favorites in FavoritesViewController.favorites {
            //check name and distance values
            if favorites.name == attributesArray.name && favorites.distance == attributesArray.distance {
                //hide button if it's the same
                addFavoriteButton.isHidden = true
            }
            
        }
    }
    
    //add favorite button
    @IBAction func addFavorite() {
        //append to favorites array
        FavoritesViewController.favorites.append(attributesArray)
        //move to favorites screen
        performSegue(withIdentifier: "AddFavorite", sender: self)
    }
    
    //animate deselecting row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //delegate data back
    func sendData(favorite: SearchRes!) {
        vc!.favDelegate = self
        print("test")
        attributesArray = favorite
    }
    
}


