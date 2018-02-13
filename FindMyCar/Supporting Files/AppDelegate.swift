//
//  AppDelegate.swift
//  FindMyCar
//
//  Created by Mark on 2/12/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		GMSServices.provideAPIKey("AIzaSyBuCljRq8LQdNTVsxWRkV4Z85_hzk1nGH4");
		return true
	}

}

