//
//  SearchViewController.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 4/20/21.
//
import Foundation
import CoreLocation
import UIKit

class SearchViewController: UIViewController, CLLocationManagerDelegate {
    struct TableView {
        struct CellIdentifiers {
            static let searchResultCell = "SearchResultCell"
            static let nothingFoundCell = "NothingFoundCell"
        }
    }
    
    // MARK: - IB Outlets
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var getLocationButton: UIButton!
    
    //search result array
    var searchResults = [SearchResult]()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    }
    
    //get location
    @IBAction func getLocation() {
        //user wants to use own location
        ownLocation = true
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
            print("got a location")
            stopLocationManager()
            //set the new coords
            locationLat = String(format: "%.8f", location!.coordinate.latitude)
            locationLong = String(format: "%.8f", location!.coordinate.longitude)
            print("own location str test \(locationLat) \(locationLong)")
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
    
    public func findLocations(with query: String, completion: @escaping (([Location]) -> Void)) {
        let geoCoder = CLGeocoder()
        
        //handle error
        geoCoder.geocodeAddressString(query) {places, error in
            guard let places = places, error == nil else {
                completion([])
                return
            }
            
            let models: [Location] = places.compactMap({ place in
                var name = ""
                if let locationName = place.name {
                    name += locationName
                }
                
                if let adminRegion = place.administrativeArea {
                    name += ", \(adminRegion)"
                }
                
                if let locality = place.locality {
                    name += ", \(locality)"
                }
                if let country = place.country {
                    name += ", \(country)"
                }
                
                print("place string test \(place)")
                print("coord test \(place.location!.coordinate)")
                
                let result = Location(coordinates: place.location?.coordinate)
                return result
            })
            completion(models)
        }
    }
    
    func APIHandling(){
        /**
        //set url based on the given coords
        let url = URL(string: "https://trueway-places.p.rapidapi.com/FindPlacesNearby?location=\(locationLat), \(locationLong)&language=en&radius=150&type=cafe")
        print("url test \(url)")
        print(url)
        
        //protect from getting nil url
        guard url != nil else {
            print("Error creating url obj")
            
        }
        return url!
        
        
        //URL Request
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
        //Header
        let header = ["x-rapidapi-key": "6bcca20f97mshb8796872ad007a7p13b6f1jsn4b2319dd60cf",
                       "x-rapidapi-host": "trueway-places.p.rapidapi.com"]
        print(header)
        request.allHTTPHeaderFields = header
        
        //Req type
        request.httpMethod = "GET"
        
        //URL Session
        let session = URLSession.shared
        
        //Data task
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            //if no errors and there is some data
            print("test??")
            if error == nil && data != nil {
                do {
                    //parse data
                    let dictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:Any]
                    print(dictionary)
                }
                catch {
                    print("Error parsing response data")
                }
            }
        }
        dataTask.resume()
         */
    }
}

// MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
    //if search button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //user wants to use search bar
        ownLocation = false
        if !searchBar.text!.isEmpty {
            //dismisses keyboard after pressing search
            searchBar.resignFirstResponder()
            //user has done a search
            hasSearched = true
            //array to hold search results
            searchResults = []
            //geocode search results
            location

            //APIHandling()
            //reloads table view to make new rows visible
            tableView.reloadData()
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
        if !hasSearched{
            return 0
        } else if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = TableView.CellIdentifiers.searchResultCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchResultCell
        //handle no results or search failed
        if searchResults.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
            let searchResult = searchResults[indexPath.row]
            //cell.companyNameLabel.text = searchResult.results.name
            //cell.locationLabel.text = searchResult.locationName
        }
        return cell
    }
    
    //funcs for selection handling
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.count == 0 {
            return nil
        } else {
            return indexPath
        }
    }
}
