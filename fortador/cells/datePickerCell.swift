//
//  datePickerCell.swift
//  fortador
//
//  Created by Aliya Shareef on 5/7/19.
//  Copyright © 2019 Aliya Shareef. All rights reserved.
//

import UIKit

protocol dateDelegate: NSObjectProtocol {
    func dateChangedForField(toDate: Date)
}
class datePickerCell: UITableViewCell  {
    @IBOutlet weak var datePicker: UIDatePicker!
    weak var delegate: dateDelegate?
    
    override func awakeFromNib() {
        datePicker.minimumDate = Date()
        super.awakeFromNib()
    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        if (self.datePicker != nil) {
            self.delegate?.dateChangedForField(toDate: self.datePicker.date)
        }
    }
}
