//
//  Utilities.swift
//  FindMyCar
//
//  Created by Mark on 2/12/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

extension CGFloat {
	var degreesToRadians: CGFloat { return self * .pi / 180 }
	var radiansToDegrees: CGFloat { return self * 180 / .pi }
}

extension Double {
	var degreesToRadians: Double { return Double(CGFloat(self).degreesToRadians) }
	var radiansToDegrees: Double { return Double(CGFloat(self).radiansToDegrees) }
}

extension CLLocation {
	func bearingToLocationRadian(_ destinationLocation: CLLocation) -> CGFloat {
		
		let lat1 = self.coordinate.latitude.degreesToRadians
		let lon1 = self.coordinate.longitude.degreesToRadians
		
		let lat2 = destinationLocation.coordinate.latitude.degreesToRadians
		let lon2 = destinationLocation.coordinate.longitude.degreesToRadians
		
		let dLon = lon2 - lon1
		
		let y = sin(dLon) * cos(lat2)
		let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
		let radiansBearing = atan2(y, x)
		
		return CGFloat(radiansBearing)
	}
	
	func bearingToLocationDegrees(destinationLocation: CLLocation) -> CGFloat {
		return bearingToLocationRadian(destinationLocation).radiansToDegrees
	}
}


extension UIColor {
	static var myGreen: UIColor {
		return UIColor(red: 58.0/255.0, green: 220.0/255.0, blue: 136.0/255.0, alpha: 1)
	}
	
	static var myBlue: UIColor {
		return UIColor(red: 31.0 / 255, green: 187.0 / 255, blue: 226.0 / 255, alpha: 1.0);
	}
}

extension UIViewController {
	func alert(_ title: String, _ message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
}

