//
//  automobileCell.swift
//  fortador
//
//  Created by Aliya Shareef on 12/23/18.
//  Copyright © 2018 Aliya Shareef. All rights reserved.
//

import UIKit

protocol autoDelegate: NSObjectProtocol {
    func didSelectAuto(auto: Auto)
}
class automobileCell: UICollectionViewCell  {
    weak var autoDelegate: autoDelegate?
    @IBOutlet weak var autoImageView: UIImageView!
    @IBOutlet weak var autoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
