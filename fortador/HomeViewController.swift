//
//  HomeViewController.swift
//  fortador
//
//  Created by Aliya Shareef on 12/23/18.
//  Copyright © 2018 Aliya Shareef. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedIndexDescription: String!
    var serviceRequest : ServiceRequest!
    var service : [Service] = []
    var isDateCellOpen : Bool = false
    var datePickerIndexPath: IndexPath?
    var serviceDate : Date = Date()
    var selectedAuto : Auto!
    var serviceLocation : CLLocation!
    var requestService : Service!
    var requestedserviceType :ServiceRequest.serviceType!
    @IBOutlet weak var homeTableView: UITableView!
    var ref: DatabaseReference!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        var isLoggedIn = UserDefaults.standard.bool(forKey:"UserLoggedIn")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.homeTableView.rowHeight = UITableView.automaticDimension
        self.homeTableView.estimatedRowHeight = UITableView.automaticDimension
        if let url = Bundle.main.url(forResource: "services", withExtension: "json") {
            let serviceJsonData = try! String(contentsOf: url)
            if let data = serviceJsonData.data(using: .utf8) {
                do {
                    let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
                    print(dict)
                    for serv in dict{
                        let servic = Service.init(dict: serv.value as! NSDictionary)
                        service.append(servic)
                    }
                } catch {
                    print(error.localizedDescription)
                }
                print(service)
            }
        }
        
//        ref = Database.database().reference()
//        let autoRef = ref.child("automobile")
//        autoRef.queryOrderedByValue().observe(.value, with: { snapshot in
//            var newItems: [String] = []
//            for child in snapshot.children {
//                if let snapshot = child as? DataSnapshot {
//                    let value = snapshot.value as! String
//                    newItems.append(value)
//                }
//            }
//            self.auto = newItems
//            self.homeTableView.reloadData()
//        })
        
        self.homeTableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isDateCellOpen) {
            return 7
        } else {
            return 6
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        } else if indexPath.row < 3 {
            return 130
        } else if indexPath.row == 3 {
            return UITableView.automaticDimension
        } else if indexPath.row == self.datePickerIndexPath?.row && isDateCellOpen{
            return 180
        } else if indexPath.row == 4 {
        return 40
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let mapCell  = tableView.dequeueReusableCell(withIdentifier: "mapCell", for: indexPath) as! mapCell
            mapCell.mapdelegate = self
            return mapCell
        } else if indexPath.row == 1 {
            let autoCell  = tableView.dequeueReusableCell(withIdentifier: "autoTableViewCell", for: indexPath) as! autoTableViewCell
            autoCell.autoDelegate = self
            return autoCell
        } else if indexPath.row == 2 {
            let serviceCell  = tableView.dequeueReusableCell(withIdentifier: "serviceTableViewCell", for: indexPath) as! serviceTableViewCell
            serviceCell.service = self.service
            serviceCell.delegate = self
            return serviceCell
        } else if indexPath.row == 3{
            let descriptionCell  = tableView.dequeueReusableCell(withIdentifier: "serviceDescriptionCell", for: indexPath) as! serviceDescriptionCell
            descriptionCell.descriptionLabel.text = self.selectedIndexDescription
            return descriptionCell
        } else if indexPath.row == 4 {
            datePickerIndexPath = IndexPath.init(row: indexPath.row+1, section: indexPath.section)
            let cell  = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! dateCell
            let dateString = cell.dateToSting(date: self.serviceDate)
            cell.dateLabel.text = " Date and Time: \(dateString)"
            return cell
        } else if indexPath.row == 5 {
            datePickerIndexPath = indexPath
            if (self.isDateCellOpen) {
                let cell  = tableView.dequeueReusableCell(withIdentifier: "datePickerCell", for: indexPath) as! datePickerCell
                cell.delegate = self
                return cell
            } else {
                let cell  = tableView.dequeueReusableCell(withIdentifier: "requestButtonCell", for: indexPath) as! serviceRequestCell
                cell.delegate = self
                return cell
            }
        } else {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "requestButtonCell", for: indexPath) as! serviceRequestCell
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 6 {
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            tableView.beginUpdates()
            let dateCellIndexPath : IndexPath = IndexPath.init(row: datePickerIndexPath!.row-1, section: datePickerIndexPath!.section)
            if indexPath == dateCellIndexPath && isDateCellOpen {
                tableView.deleteRows(at: [self.datePickerIndexPath!], with: .fade)
                isDateCellOpen = false
                tableView.deselectRow(at: indexPath, animated: true)
            } else {
                if isDateCellOpen {
                    
                } else if indexPath == dateCellIndexPath {
                    isDateCellOpen = true
                    //tableView.deleteRows(at:[self.datePickerIndexPath!], with: .fade)
                    self.datePickerIndexPath = indexPathToInsertDatePicker(indexPath: indexPath)
                    tableView.insertRows(at: [self.datePickerIndexPath!], with: .fade)
                    tableView.deselectRow(at: indexPath, animated: true)
                } else {
                    tableView.deselectRow(at: indexPath, animated: true)
                }
            }
            tableView.endUpdates()
        }
    }
    
    func indexPathToInsertDatePicker(indexPath: IndexPath) -> IndexPath {
        if let datePickerIndexPath = datePickerIndexPath, datePickerIndexPath.row < indexPath.row {
            return indexPath
        } else {
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        }
    }
    
    func postServiceRequest () {
        let dictonary = self.serviceRequest.dictForFirebase()
        ref = Database.database().reference()
        ref.child("serviceRequest").childByAutoId().setValue(dictonary) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                self.showAlert(title: "Error", message: "Data could not be saved: \(error).", style: .alert)
            } else {
                self.showAlert(title: "Success", message: "Service request notified to team", style: .alert)
            }
        }
    }
}

extension HomeViewController : serviceDelegate {
    func didSelect(service : Service) {
        self.requestService = service
        self.selectedIndexDescription = service.description
        self.homeTableView.reloadData()
    }
}

// MARK: - DatePickerTableViewCellDelegate methods

extension HomeViewController : dateDelegate {
    func dateChangedForField(toDate: Date) {
            self.serviceDate = toDate
            self.homeTableView.reloadData()
    }
}

extension HomeViewController : autoDelegate {
    func didSelectAuto(auto: Auto) {
        self.selectedAuto = auto
    }
}

extension HomeViewController : mapDelegate {
    func didSelectLocation(location: CLLocation, serviceType: ServiceRequest.serviceType) {
        self.serviceLocation = location
        self.requestedserviceType = serviceType
    }
}

extension HomeViewController : requestDelegate {
    
    func requestServiceTapped() {
        if (self.selectedAuto != nil) && (self.requestService != nil) && (self.serviceLocation != nil)  {
            self.serviceRequest = ServiceRequest.init(service:self.requestService! ,user: (Auth.auth().currentUser?.phoneNumber)!, time: self.serviceDate, auto:self.selectedAuto! , serviceType: self.requestedserviceType!, location: self.serviceLocation!)
        self.postServiceRequest()
        } else {
            self.showAlert(title: "Remember", message: "Please select your vehicle segment and service you wish to do. Thank you", style: .alert)
        }
    }
    
    func showAlert(title : String, message : String, style : UIAlertController.Style) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            @unknown default:
                print("error")
            }}))
        self.present(alert, animated: true,completion: nil)
    }
    
    @IBAction func tapBtnMenu(_ sender: Any) {
        SidebarLauncher.init(delegate:self).show()
     }
}

extension HomeViewController: SidebarDelegate{
    func sidbarDidOpen() {
    }

    func sidebarDidClose(with item: NavigationModel?) {
        guard let item = item else {return}
        switch item.type {
        case .about:
            print("called about")
        case .facebook:
            print("called facebook")
        case .logout:
            let firebaseAuth = Auth.auth()
            do {
              try firebaseAuth.signOut()
                UserDefaults.standard.set(false, forKey: "UserLoggedIn")
                UserDefaults.standard.synchronize()
                if let storyboard = self.storyboard {
                    let vc = storyboard.instantiateViewController(withIdentifier: "loginVC") 
                    let appsDelegate = UIApplication.shared.delegate
                    appsDelegate?.window!!.rootViewController = nil
                    appsDelegate?.window!!.rootViewController = vc
                    self.present(vc, animated: false, completion: nil)
                }
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }
        }
    }
}
