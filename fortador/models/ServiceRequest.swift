//
//  ServiceRequest.swift
//  fortador
//
//  Created by Aliya Shareef on 3/16/19.
//  Copyright © 2019 Aliya Shareef. All rights reserved.
//

import UIKit
import MapKit

class ServiceRequest {
    var user: String
    var service : Service
    var time : Date
    var automobile : Auto
    var location : CLLocation
    enum serviceType: String {
        case mobileService
        case onsite
    }
    var servicetype : serviceType
    
    init(service: Service, user: String, time : Date, auto : Auto, serviceType : serviceType , location : CLLocation) {
        self.user = user
        self.service = service
        self.time = time
        self.automobile = auto
        self.servicetype = serviceType
        self.location = location
    }
    
    func dictForFirebase() -> Dictionary< String, Any>  {
        return [
            "user":self.user as String,
            "serviceName": self.service.name as String,
            "time": "\(self.time)",
            "automobile": self.automobile.name,
            "serviceType": self.servicetype.rawValue,
            "location":"\(self.location)"
        ]
    }
}
