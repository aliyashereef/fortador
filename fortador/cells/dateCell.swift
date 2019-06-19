//
//  dateCell.swift
//  fortador
//
//  Created by Aliya Shareef on 5/7/19.
//  Copyright © 2019 Aliya Shareef. All rights reserved.
//

import UIKit

class dateCell: UITableViewCell  {
    
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func dateToSting(date : Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let myString = formatter.string(from: date)
        return myString
    }
}
