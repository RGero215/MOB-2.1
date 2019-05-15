//
//  AddWaypoint.swift
//  Trip Planner
//
//  Created by Ramon Geronimo on 5/5/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import CoreData

class AddWaypoint: UIViewController, UISearchBarDelegate {
    
    var trip: Trips?
    var managedObjectContext: NSManagedObjectContext!
    var waypoints: Waypoints!
    
    
    var selectedPin:MKPlacemark? = nil

    var matchingItems:[MKMapItem] = []
    

    
    var locationManager: CLLocationManager?
    var location: CLLocation?
    
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.isTranslucent = false
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        return searchBar
    }()
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        let width = view.frame.size.width
        let height = view.frame.size.height / 2 - 100
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    var stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Add Waypoint"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        guard let trip = self.trip else {return}
        requestLocation(place: trip.trip)
        setupview()
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressRecogniser.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressRecogniser)
       
    
    }
    
    @objc func handleLongPress(_ sender : UIGestureRecognizer){
        if sender.state == UIGestureRecognizer.State.began {
            // clear existing pins
            mapView.removeAnnotations(mapView.annotations)
            let touchPoint = sender.location(in: mapView)
            let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchCoordinate
            
            mapView.addAnnotation(annotation) //drops the pin
            print("lat:  \(touchCoordinate.latitude)")
            let num = touchCoordinate.latitude as NSNumber
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 4
            formatter.minimumFractionDigits = 4
            _ = formatter.string(from: num)
            print("long: \(touchCoordinate.longitude)")
            let num1 = touchCoordinate.longitude as NSNumber
            let formatter1 = NumberFormatter()
            formatter1.maximumFractionDigits = 4
            formatter1.minimumFractionDigits = 4
            _ = formatter1.string(from: num1)
//            self.adressLoLa.text = "\(num),\(num1)"
            
            // Add below code to get address for touch coordinates.
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)
            geoCoder.reverseGeocodeLocation(location, completionHandler:
                {
                    placemarks, error -> Void in
                    
                    // Place details
                    guard let placeMark = placemarks?.first else { return }
                    
                    annotation.title = placeMark.name
                    guard let place = placeMark.name else {return}
                    self.requestLocation(place: place)
                    self.searchBar.text? = self.parseAddress(selectedItem: placeMark)
                    
                    // Location name
                    if let locationName = placeMark.location {
                        
                        print(locationName)
                    }
                    // Street address
                    if let street = placeMark.thoroughfare {
                        print(street)
                    }
                    // City
                    if let city = placeMark.subAdministrativeArea {
                        print(city)
                    }
                    // Zip code
                    if let zip = placeMark.isoCountryCode {
                        print(zip)
                    }
                    // Country
                    if let country = placeMark.country {
                        print(country)
                    }
            })
        }
    }
    
    @objc func handleCancel(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSave(){
        if let text = searchBar.text, searchBar.text != "" {
            let waypoint = Waypoints(entity: Waypoints.entity(), insertInto: managedObjectContext)
            waypoint.waypoint = text
            waypoint.trip = trip
            trip?.hasWaypoint = true
            self.managedObjectContext?.saveChanges()
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    func setupview(){
        let width = view.frame.size.width
        let height = view.frame.size.height
        
        stackView = UIStackView(arrangedSubviews: [searchBar, tableView, mapView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: (view.frame.height / 2) + 44).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: view.frame.height / 2).isActive = true
        
    
    }

}

extension AddWaypoint: UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        requestLocation(place: searchBarText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchBarText = searchBar.text else { return }
        requestLocation(place: searchBarText)
        if searchBarText == "" {
            guard let trip = self.trip else {return}
            requestLocation(place: trip.trip)
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cellId")
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        dropPinZoomIn(placemark: selectedItem)
        searchBar.text = parseAddress(selectedItem: selectedItem)
        self.matchingItems = []
        tableView.reloadData()
    }
    
    func startLocationService() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            activateLocationServices()
        } else {
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    private func activateLocationServices(){
        locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            activateLocationServices()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if location == nil {
            
        } else {
            
        }
    }
    
    func parseAddress(selectedItem:CLPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
    
    @objc func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
    
    func requestLocation(place: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = place
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            if self.matchingItems.count >= 1 {
                self.dropPinZoomIn(placemark: self.matchingItems[0].placemark)
                
            }
            self.tableView.reloadData()
        }
    }
    
}
