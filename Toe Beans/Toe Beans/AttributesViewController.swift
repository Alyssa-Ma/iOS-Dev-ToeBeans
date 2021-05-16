//
//  ViewController.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 5/15/21.
//
import Foundation
import CoreLocation
import UIKit

class AttributesViewController: UITableViewController, CLLocationManagerDelegate, FavoritesDelegate {

    var attributesArray: SearchRes!
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var addFavoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        print(attributesArray)
        //after 2 seconds, push attributesviewcontroller
        perform(#selector(advance), with: nil, afterDelay: 2)
         
    }
    
    func sendData() -> String {
        let retSTr = "attributes controller \(attributesArray.address)"
        print(retSTr)
        return retSTr
    }
    
    @IBAction func addFavorite() {
        
        performSegue(withIdentifier: "AddFavorite", sender: self)
    }
    
    @objc func advance () {
        let vc = FavoritesViewController()
        //run methods called by delegates
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}



