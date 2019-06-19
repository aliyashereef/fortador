//
//  user.swift
//  fortador
//
//  Created by Aliya Shareef on 3/3/19.
//  Copyright © 2019 Aliya Shareef. All rights reserved.
//

import UIKit

class user {
    var name: String
    var image : UIImage
    
    init(name: String, imageWithName : String) {
        self.name = name
        let image: UIImage = UIImage(named: imageWithName)!
        self.image = image
    }
}
