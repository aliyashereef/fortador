//
//  serviceRequestCell.swift
//  fortador
//
//  Created by Aliya Shareef on 5/7/19.
//  Copyright © 2019 Aliya Shareef. All rights reserved.
//

import UIKit
protocol requestDelegate: NSObjectProtocol {
    func requestServiceTapped()
}
class serviceRequestCell: UITableViewCell  {

    weak var delegate: requestDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func serviceRequestTapped(_ sender: Any) {
       delegate?.requestServiceTapped()
    }
}
