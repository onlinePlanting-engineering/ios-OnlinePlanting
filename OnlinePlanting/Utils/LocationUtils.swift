//
//  LocationUtils.swift
//  OnlinePlanting
//
//  Created by ___Alex___ on 5/5/17.
//  Copyright © 2017 onlinePlanting. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreData
import Sync
import SwiftyJSON

class LocationUtils: NSObject, CLLocationManagerDelegate {
    
    var currLocation : CLLocation?
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        return locationManager
    }()
    
    static var sharedInstance: LocationUtils {
        struct Static {
            static let instance: LocationUtils = LocationUtils()
        }
        return Static.instance
    }
    
    private override init() {
        super.init()
        prespareLocataion()
    }
    
    func prespareLocataion() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeNotification), name: .NSManagedObjectContextObjectsDidChange, object: appDelegate.dataStack.mainContext)
        
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyKilometer
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func changeNotification(notification: NSNotification) {
        _ = notification.userInfo?[NSInsertedObjectsKey]
        //print("insertedObjects:\(insertedObjects)")
    }
    
    func getCurrentLocation() -> CLLocation? {
        return currLocation
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currLocation = locations.last
        LonLatToCity()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        print("location failed")
    }
    
    func LonLatToCity() {
        let geocoder: CLGeocoder = CLGeocoder()
        guard let location = currLocation else { return }
        geocoder.reverseGeocodeLocation(location) { (placemark, error) -> Void in
            if(error == nil) {
                let data = placemark! as NSArray
                let userLocationData = data.firstObject as! CLPlacemark
                let countryCode: String = (userLocationData.addressDictionary! as NSDictionary).value(forKey: "CountryCode") as! String
                let country: String = (userLocationData.addressDictionary! as NSDictionary).value(forKey: "Country") as! String
                let province: String = (userLocationData.addressDictionary! as NSDictionary).value(forKey: "State") as! String
                let city: String = (userLocationData.addressDictionary! as NSDictionary).value(forKey: "City") as! String
                let subLocality: String = (userLocationData.addressDictionary! as NSDictionary).value(forKey: "SubLocality") as! String
                let street: String = (userLocationData.addressDictionary! as NSDictionary).value(forKey: "Name") as! String
                
                let locationArray: [String: String] = ["id": "1", "countryCode": countryCode, "country": country, "province": province, "city": city, "subLocality": subLocality, "street": street]
                
                OPDataService.sharedInstance.saveUserLocationData(locationArray, handler: { [weak self](success, error) in
                    if error != nil {
                        print("save location data failed")
                    } else {
                        self?.fetchCurrentUserLocationObjects()
                    }
                })
                
            } else {
                print("failed")
            }
        }
    }
    
    func fetchCurrentUserLocationObjects() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        let location = (try! appDelegate.dataStack.mainContext.fetch(request)) as! [Location]
        if location.count > 0 {
            appDelegate.currentLocation = location[0]
        }
    }
}
