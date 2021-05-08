//
//  ViewController.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 4/14/21.
//

import UIKit
import CoreLocation

class MainScreenViewController: UIViewController, CLLocationManagerDelegate {
    
    //cll location manager
    var manager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //when view appears, get user location
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else {
            print("err")
            return
        }
        print("teswt \(first.coordinate.latitude)")
    }
}

