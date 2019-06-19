//
//  autoTableViewCell.swift
//  fortador
//
//  Created by Aliya Shareef on 4/20/19.
//  Copyright © 2019 Aliya Shareef. All rights reserved.
//

import UIKit

class autoTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    var auto : [String] = ["Sedan","Hatchback","SUV"]
    var autoDelegate : autoDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK:- Collection view delegate and datasource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.auto.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "autoCollectionViewCell", for: indexPath) as! automobileCell
        if let car : NSString = self.auto[indexPath.row] as NSString {
                cell.autoLabel.text = car as String
                if let image: UIImage = UIImage(named: car as String){
                    cell.autoImageView.image = image
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! automobileCell
        let selectedAuto : Auto = Auto.init(name:self.auto[indexPath.row])
        cell.layer.borderWidth = 4.0
        cell.layer.borderColor = UIColor(red:0.87, green:0.56, blue:0.25, alpha:1.0).cgColor
        autoDelegate?.didSelectAuto(auto:selectedAuto)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0
    }
}
