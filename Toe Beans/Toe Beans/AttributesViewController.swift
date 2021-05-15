//
//  ViewController.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 5/15/21.
//
import Foundation
import CoreLocation
import UIKit

class AttributesViewController: UITableViewController, CLLocationManagerDelegate {
    var attributesArray: SearchRes!
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var distance: UILabel!
    
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
            distance.text = "Distance: \(attributesArray!.distance!)"
        }
        else {
            distance.text = "Distance: Unknown"
        }
        
        print(attributesArray)
         
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}



