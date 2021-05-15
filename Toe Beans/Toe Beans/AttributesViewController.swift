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
    

    @IBOutlet weak var name: UILabel!
    /**
     @IBOutlet weak var nsme: UILabel!
     @IBOutlet weak var address: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var distance: UILabel!
     */
    var attributesArray: SearchRes!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = attributesArray.name
        /**
        address.text = attributesArray.address
        
        phoneNumber.text = attributesArray.phoneNumber
        website.text = attributesArray.website
        distance.text = "\(attributesArray.distance)"
         */
        print(attributesArray)
         
    }
    
}



