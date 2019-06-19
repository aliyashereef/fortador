//
//  serviceTableViewCell.swift
//  fortador
//
//  Created by Aliya Shareef on 4/20/19.
//  Copyright © 2019 Aliya Shareef. All rights reserved.
//

import UIKit
class serviceTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate{
    
    var service : [Service] = []
    var delegate : serviceDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK:- Collection view delegate and datasource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.service.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "serviceCell", for: indexPath) as! serviceCell
        let service : Service = self.service[indexPath.row]
        cell.serviceLabel.text = service.name
        cell.serviceImageView.image = service.image
        cell.priceLabel.text = NSString(format: "Rs %.2f Onwards", service.price) as String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 4.0
        cell?.layer.borderColor = UIColor(red:0.87, green:0.56, blue:0.25, alpha:1.0).cgColor
        delegate?.didSelect(service: service[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0
    }
    
}
