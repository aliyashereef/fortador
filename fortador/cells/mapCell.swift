//
//  mapCell.swift
//  fortador
//
//  Created by Aliya Shareef on 12/23/18.
//  Copyright © 2018 Aliya Shareef. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
protocol mapDelegate: NSObjectProtocol {
    func didSelectLocation(location : CLLocation , serviceType : ServiceRequest.serviceType)
}

class mapCell: UITableViewCell, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    let auroraLocation : CLLocation = CLLocation.init(latitude: 11.2534494, longitude: 75.8267334)

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet var googleMap: GMSMapView!
    @IBOutlet weak var locationLabel: UILabel!
    var locationManager = CLLocationManager()
    var camera = GMSCameraPosition()
    var indexPath: IndexPath!
    var serviceType : ServiceRequest.serviceType!
    weak var mapdelegate: mapDelegate?

    override func awakeFromNib() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        self.showCurrentLocationOnMap()
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.showCurrentLocationOnMap()
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        self.locationManager.startUpdatingLocation()
    }
    
    func showCurrentLocationOnMap() {
        if (self.locationManager.location?.coordinate != nil) {
            camera  = GMSCameraPosition.camera(withLatitude: ((self.locationManager.location?.coordinate.latitude)!), longitude: ((self.locationManager.location?.coordinate.longitude)!), zoom: 10)
            self.getAddressFromLatLon(pdblLatitude: (self.locationManager.location?.coordinate.latitude)!, withLongitude: (self.locationManager.location?.coordinate.longitude)!)
            self.serviceType = ServiceRequest.serviceType.mobileService
            self.mapdelegate?.didSelectLocation(location:self.locationManager.location! , serviceType: self.serviceType)
        }
        
        let map = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.googleMap.frame.size.width, height: self.googleMap.frame.size.height), camera: camera)
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                if (self.googleMap != nil) {
                    map.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                }
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Your Location"
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = map
        map.isMyLocationEnabled = true
        map.settings.myLocationButton = true
        self.googleMap.addSubview(map)
        self.googleMap.bringSubviewToFront(self.locationLabel)
        self.googleMap.bringSubviewToFront(self.segmentedControl)
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
    }
    
    @IBAction func valueChangeOnLocationSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.locationManager.startUpdatingLocation()
            showCurrentLocationOnMap()
            self.serviceType = ServiceRequest.serviceType.mobileService
            self.mapdelegate?.didSelectLocation(location:self.locationManager.location! , serviceType: self.serviceType)
        } else {
            showAuroraLocation()
            self.googleMap.bringSubviewToFront(self.locationLabel)
            self.googleMap.bringSubviewToFront(self.segmentedControl)
            self.serviceType = ServiceRequest.serviceType.onsite
            self.mapdelegate?.didSelectLocation(location:self.locationManager.location! , serviceType: self.serviceType)
        }
    }
    
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = pdblLatitude
        center.longitude = pdblLongitude
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.name != nil {
                        addressString = addressString + pm.name! + ", "
                    }
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country!
                    }
                    self.locationLabel.text = "  Location: " + (addressString)
                }
        })
    }
    
    func showAuroraLocation() {
        
        let auroraCamera  = GMSCameraPosition.camera(withLatitude:self.auroraLocation.coordinate.latitude, longitude:self.auroraLocation.coordinate.longitude, zoom: 18)
        let auroraMap = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.googleMap.frame.size.width, height: self.googleMap.frame.size.height), camera: auroraCamera)
        auroraMap.delegate = self
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                if (self.googleMap != nil) {
                    auroraMap.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                }
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        self.getAddressFromLatLon(pdblLatitude: self.auroraLocation.coordinate.latitude, withLongitude: self.auroraLocation.coordinate.longitude)
        let marker = GMSMarker()
        marker.position = auroraCamera.target
        marker.snippet = "Aurora Auto Arts"
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = auroraMap
        self.googleMap.addSubview(auroraMap)
        self.googleMap.bringSubviewToFront(auroraMap)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            let url : NSURL = NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(self.auroraLocation.coordinate.latitude),\(self.auroraLocation.coordinate.longitude)&directionsmode=driving")! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        } else {
            NSLog("Can't use comgooglemaps://")
            let alert = UIAlertController(title: "Error", message: "Google maps not installed", preferredStyle:UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(ok)
            
            //self..present(alert, animated:true, completion: nil)
        }
        return true
    }
}


