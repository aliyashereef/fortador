//
//  service.swift
//  fortador
//
//  Created by Aliya Shareef on 3/2/19.
//  Copyright © 2019 Aliya Shareef. All rights reserved.
//

import UIKit

class Service {
    var name: String
    var image : UIImage
    var price : Float
    var description : String
    
    init(name: String, price : Float, imageWithName : String, description : String) {
        self.name = name
        self.price = price
        let image: UIImage = UIImage(named: imageWithName)!
        self.image = image
        self.description = description
    }
    
    init(dict : NSDictionary) {
        self.name = dict["name"] as! String
        self.description = dict["description"] as! String
        let image: UIImage = UIImage(named: "1")!
        self.image = image
        self.price = dict["price"] as! Float
    }
    
    func toAnyObject() -> Any {
        return [
            "name": self.name,
            "description": self.description,
            "imageWithName": "",
            "price": self.price
        ]
    }
}
