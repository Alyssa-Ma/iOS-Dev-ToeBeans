//
//  SearchViewController.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 4/20/21.
//
import Foundation
import CoreLocation
import UIKit

protocol searchDelegate {
    func getPlace() -> String
    func getRadius() -> String
}

class SearchViewController: UIViewController, CLLocationManagerDelegate {
    struct TableView {
        struct CellIdentifiers {
            //custom table cells
            static let searchResultCell = "SearchResultCell"
            static let nothingFoundCell = "NothingFoundCell"
        }
    }
    
    // MARK: - IB Outlets
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var getLocationButton: UIButton!
    
    //search result parsed json
    var searchRes: ResultArray?
    //bool if user has done a search
    var hasSearched = false
    //reference to object that gets GPS coords
    let locationManager = CLLocationManager()
    //store user's current location
    var location: CLLocation?
    //check if we're updating location
    var updatingLocation = false
    //if error in location
    var lastLocationError: Error?
    //bool if user wants to use own location
    var ownLocation = false
    //search location
    var locations: [Location]?
    //strings to hold what to input for api
    var locationLat: String = ""
    var locationLong: String = ""
    //int to hold the number of results
    var resCount: Int? = 0
    //hold placetype
    var placeType: String = ""
    var apiRadius: String = ""
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        //prevent search bar from obscuring table view
        tableView.contentInset = UIEdgeInsets(top: 56, left: 0, bottom: 0, right: 0)
        
        //cell nib
        var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
        
        //nothing found nib
        cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
        
        //keyboard on launch
        searchBar.becomeFirstResponder()
        //on load, get the current defaults, can't use delegate yet or nil
        if userDefaults.string(forKey: "apiKey") == nil {
            placeType = "cafe"
        }
        else {
            placeType = userDefaults.string(forKey: "apiKey")!
        }
        
        if userDefaults.string(forKey: "radKey") == nil {
            apiRadius = "150"
        }
        else {
            apiRadius = userDefaults.string(forKey: "radKey")!
        }
    }
    
    //get location
    @IBAction func getLocation() {
        //ask for location permission
        let authStatus = locationManager.authorizationStatus
        //if auth status is not yet known, prompt
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        //alert if user denied location services
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        //start the location manager
        startLocationManager()
        //dismisses keyboard after pressing search
        searchBar.resignFirstResponder()
        //user has done a search
        hasSearched = true
        //array to hold search results
        //searchResults?.resul
        //print("url lat test \(locationLat)")
        
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //if error, print with desc of why
        print("didFailWithError \(error.localizedDescription)")
        
        //unable to get a location currently, try until location found or other err
        if(error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        lastLocationError = error
        stopLocationManager()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //new location = stsored location var, update
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        
        //ignore old cached results
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        
        //if the new location is less accurate, ignore
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        //if the new location is more accurate than the old one
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            //clear error and store the new location
            lastLocationError = nil
            location = newLocation
        }
        
        //stop updating
        if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
            //print("got a location")
            //set the new coords
            locationLat = String(format: "%.8f", newLocation.coordinate.latitude)
            locationLong = String(format: "%.8f", newLocation.coordinate.longitude)
            //print("own location str test \(locationLat) \(locationLong)")
            stopLocationManager()
            //handle api
            APIHandling()
        }
    }
    
    //start location manager
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
        }
    }
    //tell location manager to stop looking for locations
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }
    
    // MARK: - Helper Methods
    //alert if user denied location services
    func showLocationServicesDeniedAlert() {
        //alert popup
        let alert = UIAlertController(title: "Location Services Disabled", message: "To use this app, please enable location services.", preferredStyle: .alert)
        
        //press ok
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        //show alert
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - API Handling
    func APIHandling() {
        //print("url lat test \(locationLat)")
        //set url based on the given params
        let url = URL(string: "https://trueway-places.p.rapidapi.com/FindPlacesNearby?location=\(locationLat)%2C\(locationLong)&language=en&radius=\(apiRadius)&type=\(placeType)")
        //print("url test \(url)")
        //print(url)
        //protect from getting nil url
        guard url != nil else {
            print("Error creating url obj")
            return
        }

        //URL Request
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
        //Header
        let header = ["x-rapidapi-key": "6bcca20f97mshb8796872ad007a7p13b6f1jsn4b2319dd60cf",
                       "x-rapidapi-host": "trueway-places.p.rapidapi.com"]
        //print(header)
        request.allHTTPHeaderFields = header
        
        //Req type
        request.httpMethod = "GET"
        
        //URL Session
        let session = URLSession.shared
        
        //Data task
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            //protect from nil
            guard let data = data else {return}
            
            do {
                //decode results
                self.searchRes = try JSONDecoder().decode(ResultArray.self, from: data)
                //print("test \(self.attrThing)")
                //set result count
                self.resCount = self.searchRes?.results.count
                //print("res count test \(self.resCount)")
                /**
                if let searchRes = self.searchRes {
                    print("test searchres \(searchRes)")
                }
                else {
                    print("failed to parse")
                }
                 */
            }
            catch {
                print("error json parse: \(error)")
            }
            //refresh table
            DispatchQueue.main.async {
                //print("refresh table")
                self.tableView.reloadData()
            }
           /**
            if error == nil && data != nil {
                do {
                    
                    //parse data
                    let dictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                    print("dictionary print \(dictionary)")
                    

                }
                catch {
                    print("Error parsing response data")
                }
            }
             */
        }
        dataTask.resume()
    }
    
}

// MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
    //if search button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //if search bar is not empty
        if !searchBar.text!.isEmpty {
            //dismisses keyboard after pressing search
            searchBar.resignFirstResponder()
            //user has done a search
            hasSearched = true
            //array to hold search results
            //searchResults = []
            LocationManager.shared.findLocations(with: searchBar.text!) {[weak self] locations in DispatchQueue.main.async {
                //check if there is a location
                if locations.count != 0 {
                    //set to locations
                    self?.locations = locations
                    //print(locations.count)
                    //set the lat and long
                    self!.locationLat = String(format: "%.8f", locations[0].coordinates?.latitude as! CVarArg)
                    self!.locationLong = String(format: "%.8f", locations[0].coordinates?.longitude as! CVarArg)
                    //do api handling
                    self?.APIHandling()
                }
                else {
                    print("couldn't find location")
                }
            }
            }
        }
    }
    //fixes white line right above search bar
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

// MARK: - Table View Delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //no search results yet
        if !hasSearched{
            return 0
        //for nothingfound cell
        } else if resCount == 0 {
            return 1
        //else, number of results
        } else {
            return resCount!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //handle no results or search failed
        if resCount == 0 {
            return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
            let searchResult = searchRes?.results[indexPath.row]
            //set company name
            cell.companyNameLabel.text = searchResult?.name
            //print("company name \(searchResult?.name)")
            //print("location name \(searchResult?.address)")
            //if location isn't listed, print the coords instead

            //print("returned cell")
            //animate cell
            UIView.animate(withDuration: 2, animations: {
                            cell.transform = CGAffineTransform.identity}
            )
            return cell
        }
    }
    
    //funcs for selection handling
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //attributeInfo[].address = searchRes?.results[indexPath.row].address
        //tableView.deselectRow(at: indexPath, animated: true)
        //show attributes when tap on cell
        performSegue(withIdentifier: "ShowAttributes", sender: self)
    }
    
    //send info to attributesview
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AttributesViewController {
            //set attributes array to current index's data
            destination.attributesArray = (searchRes?.results[(tableView.indexPathForSelectedRow?.row)!])!
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if resCount == 0 {
            return nil
        } else {
            return indexPath
        }
    }
    
    //need to do set height manually or cell doesn't display
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}



