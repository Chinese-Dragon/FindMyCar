//
//  ViewController.swift
//  FindMyCar
//
//  Created by Mark on 2/12/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import UIKit
import GoogleMaps

enum State {
	case NotParked
	case Parked
	case Looking
}

class FindMyCarViewController: UIViewController {
	@IBOutlet weak var googleMap: GMSMapView!
	@IBOutlet weak var parkCarButton: UIButton!
	@IBOutlet weak var carDirection: UIImageView!
	@IBOutlet weak var carDistance: UILabel!
	
	private let locationManager = CLLocationManager()
	private var carMarker: GMSMarker!
	private var carLocation: CLLocation!
	private var currentState: State = .NotParked
	private var lastestHeading: CGFloat?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupMap()
		setupLocationService()
	}
	
	func setupMap() {
		googleMap.mapType = .normal
		googleMap.isMyLocationEnabled = true
		googleMap.delegate = self
	}
	
	func setupLocationService() {
		locationManager.requestAlwaysAuthorization()
		locationManager.requestWhenInUseAuthorization()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestLocation()
	}
	
	func zoomToLocation(_ location: CLLocation) {
		let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 16.0)
		
		// make camera focus on a target location with proper zoom level
		googleMap.camera = camera
	}
	
	func reset() {
		// change state
		currentState = .NotParked
		
		// stop updating
		locationManager.stopUpdatingHeading()
		locationManager.stopUpdatingLocation()
		
		// change button title
		parkCarButton.setTitle("Park My Car", for: .normal)
		
		// change color
		parkCarButton.backgroundColor = UIColor.myBlue
		
		// remove marker
		carMarker.map = nil
		
		// remove car location
		carLocation = nil
		
		// remove car distance
		carDistance.text = ""
		
		// remove lastestheading
		lastestHeading = nil
		
		//
		carDirection.image = #imageLiteral(resourceName: "CompassDirection")
		
		// show alert
		alert("See!", "Your car is here!")
	}
	
	@IBAction func parkCar(_ sender: UIButton) {
		switch currentState {
		case .NotParked:
			// change state
			currentState = .Parked
			
			// request current location and put a maker
			locationManager.requestLocation()
			
			parkCarButton.setTitle("Find My Car", for: .normal)
			parkCarButton.backgroundColor = UIColor.myGreen
		case .Parked:
			// change state
			currentState = .Looking
			
			// update current location and heading
			locationManager.startUpdatingLocation()
			locationManager.startUpdatingHeading()
			
			parkCarButton.setTitle("Cancel", for: .normal)
			parkCarButton.backgroundColor = UIColor.red
		case .Looking:
			currentState = .Parked
			
			// stop updating
			locationManager.stopUpdatingLocation()
			locationManager.stopUpdatingHeading()
			
			parkCarButton.setTitle("Find My Car", for: .normal)
			parkCarButton.backgroundColor = UIColor.myGreen
		}
	}
}

extension FindMyCarViewController: GMSMapViewDelegate {
	
}

extension FindMyCarViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let currentLocation = locations.last else { return }
		
		if currentState == .Parked {
			// setup marker
			carMarker = GMSMarker(position: currentLocation.coordinate)
			carMarker.map = googleMap
			carLocation = currentLocation
		} else if currentState == .Looking {
			guard let currentHeading = lastestHeading else { return }
			// get bearing
			let bearing = currentLocation.bearingToLocationRadian(carLocation)
			
			// rotate
			UIView.animate(withDuration: 0.5) {
				self.carDirection.transform = CGAffineTransform(rotationAngle: bearing - currentHeading)
			}
			
			// show distance
			let distance = currentLocation.distance(from: carLocation)
			carDistance.text = "\(distance)m"
			
			// check if user reached
			if distance <= 5 {
				reset()
			}
		} else {
			zoomToLocation(currentLocation)
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error.localizedDescription);
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
		lastestHeading = CGFloat(newHeading.trueHeading.degreesToRadians)
	}
}



