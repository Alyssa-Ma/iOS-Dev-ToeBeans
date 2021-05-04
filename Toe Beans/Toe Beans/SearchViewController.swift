//
//  SearchViewController.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 4/20/21.
//
import Foundation
import UIKit

class SearchViewController: UIViewController {
    struct TableView {
        struct CellIdentifiers {
            static let searchResultCell = "SearchResultCell"
            static let nothingFoundCell = "NothingFoundCell"
        }
    }
    
    //search result array
    var searchResults = [SearchResult]()
    //bool if user has done a search
    var hasSearched = false
    //
    var geoLat: String
    var geoLon: String
    
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
    

    // MARK: - IB Outlets
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
}


// MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            //dismisses keyboard after pressing search
            searchBar.resignFirstResponder()
            //user has done a search
            hasSearched = true
            //array to hold search results
            searchResults = []
            
            
            //reloads table view to make new rows visible
            tableView.reloadData()
        }
        
        // MARK: - Geocode API Handling
        //convert user input to be api friendly
        let convertedInput = searchBar.text?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let geoUrl = URL(string: "https://forward-reverse-geocoding.p.rapidapi.com/v1/search?q=" + convertedInput! + "&format=json&accept-language=en&polygon_threshold=0.0")
        //debug url
        //print(geoUrl)
        //protect from getting nil url
        guard geoUrl != nil else {
            print("Error creating url obj")
            return
        }
        
        //URL Request
        var geoRequest = URLRequest(url: geoUrl!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
        //Header
        let geoHeader = ["x-rapidapi-key": "6bcca20f97mshb8796872ad007a7p13b6f1jsn4b2319dd60cf",
                      "x-rapidapi-host": "forward-reverse-geocoding.p.rapidapi.com"]
        
        geoRequest.allHTTPHeaderFields = geoHeader
        
        //Req type
        geoRequest.httpMethod = "GET"
        
        //URL Session
        let geoSession = URLSession.shared
        
        //Data task
        let geoDataTask = geoSession.dataTask(with: geoRequest) { [self] (data, response, error) in
            //guard in case of fail
            guard let data = data else {return}
            do {
                //decode the json
                let geoData = try JSONDecoder().decode([Location].self, from: data)
                //testing
                //print("geo data??")
                //print(geoData)
                //set first result to the longitude and latitude
                geoLat = geoData[0].lat
                geoLon = geoData[0].lon
                //testing
                //print("geo lat " + geoLat.self)
                //print("geo long " + geoLon.self)
            }
            //error message
            catch let jsonErr {
                print("error parsing json")
            }
        }
        //api call
        geoDataTask.resume()
        
        // MARK: - Cafe API Handling
        print("test geo lat" + geoLat.self)
        //Cafe URL with latitude and longitude from previous api
        let url = URL(string: "https://trueway-places.p.rapidapi.com/FindPlacesNearby?location=" + geoLat.self + "," + geoLon.self + "&language=en&radius=150&type=cafe")
        print(url)
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
