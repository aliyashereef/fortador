//
//  serviceCell.swift
//  fortador
//
//  Created by Aliya Shareef on 3/2/19.
//  Copyright © 2019 Aliya Shareef. All rights reserved.
//

import UIKit
protocol serviceDelegate: NSObjectProtocol {
    func didSelect(service : Service) 
}

class serviceCell: UICollectionViewCell {
    
    weak var delegate: serviceDelegate?
    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
