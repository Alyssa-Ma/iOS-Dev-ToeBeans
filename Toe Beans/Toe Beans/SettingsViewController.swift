//
//  SettingsViewController.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 5/15/21.
//

import UIKit
import Foundation

class SettingsViewController: UIViewController, searchDelegate {
    
    @IBOutlet weak var radiusSegment: UISegmentedControl!
    @IBOutlet weak var apiSegment: UISegmentedControl!
    
    let apiKey = "apiKey"
    let radKey = "radKey"
    let cafe = "cafe"
    let bakery = "bakery"
    let vet = "veterinarian"
    let rad150 = "150"
    let rad500 = "500"
    let rad1000 = "1000"
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateAPI()
        updateRadius()
        // Do any additional setup after loading the view.
    }
    
    //send info to delegate
    func updateAPI() {
        let apiSet = userDefaults.string(forKey: apiKey)
        if (apiSet == cafe) {
            apiSegment.selectedSegmentIndex = 0
            //api delegate later
        }
        else if (apiSet == bakery) {
            apiSegment.selectedSegmentIndex = 1
            //api delegate later
        }
        else if (apiSet == vet) {
            apiSegment.selectedSegmentIndex = 2
            //api delegate later
        }
    }

    //update userdefault based on segment
    @IBAction func apiSegmentChanged(_ sender: Any) {
        switch apiSegment.selectedSegmentIndex {
        //set each case to its respective str
        case 0:
            userDefaults.set(cafe, forKey: apiKey)
        case 1:
            userDefaults.set(bakery, forKey: apiKey)
        case 2:
            userDefaults.set(vet, forKey: apiKey)
        //default is cafe
        default:
            userDefaults.set(cafe, forKey: apiKey)
        }
        updateAPI()
    }
    
    func updateRadius() {
        let radSet = userDefaults.string(forKey: radKey)
        if (radSet == rad150) {
            radiusSegment.selectedSegmentIndex = 0
            //api delegate later
        }
        else if (radSet == rad500) {
            radiusSegment.selectedSegmentIndex = 1
            //api delegate later
        }
        else if (radSet == rad1000) {
            radiusSegment.selectedSegmentIndex = 2
            //api delegate later
        }
    }
    
    @IBAction func radiusSegmentChanged(_ sender: Any) {
        switch radiusSegment.selectedSegmentIndex {
        //set each case to its respective str
        case 0:
            userDefaults.set(rad150, forKey: radKey)
        case 1:
            userDefaults.set(rad500, forKey: radKey)
        case 2:
            userDefaults.set(rad1000, forKey: radKey)
        //default is cafe
        default:
            userDefaults.set(rad150, forKey: radKey)
        }
        updateRadius()
    }
    
    func getPlace() -> String {
        //print(userDefaults.string(forKey: apiKey)!)()
        return userDefaults.string(forKey: apiKey)!
    }
    
    func getRadius() -> String {
        return userDefaults.string(forKey: radKey)!
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
