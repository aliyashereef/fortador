//
//  loginScreenController.swift
//  fortador
//
//  Created by Aliya Shareef on 13/10/2019.
//  Copyright © 2019 Aliya Shareef. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class LoginScreenController: UIViewController {

    @IBOutlet weak var phoneNumberField: UITextField!
    
    @IBOutlet weak var verificationCodeField: UITextField!
    
    @IBAction func verifyNumberButtonAction(_ sender: Any) {
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
        let phone = phoneNumberField.text!
        if phone.count == 10 {
            let phoneNumber = "+91"+phone
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { ( verificationID, error) in
              if let error = error {
                MBProgressHUD.hide(for: self.view, animated: false)
                self.showAlert(title: "ERROR", message: error.localizedDescription, style: .alert)
                return
                }
                MBProgressHUD.hide(for: self.view, animated: false)
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                self.performSegue(withIdentifier: "Next", sender: nil)
            }
        } else {
            loadingNotification.hide(animated: true)
            self.showAlert(title: "ERROR", message: "check the phone number" , style: .alert)
        }
    }
    
    @IBAction func verifyCodeButtonAction(_ sender: Any) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")!
        if let verificationCode = verificationCodeField.text {
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID,
                verificationCode: verificationCode)
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.signIn(credential: credential)
          } else {
            MBProgressHUD.hide(for: self.view, animated: false)
            self.showAlert(title: "ERROR", message: "verification code can't be empty" , style: .alert)
          }
}
    
    func signIn (credential : AuthCredential) {
        Auth.auth().signInAndRetrieveData(with: credential, completion: { (authResult, error) in
            if let error = error {
                MBProgressHUD.hide(for: self.view, animated: false)
                self.showAlert(title: "ERROR", message: error.localizedDescription , style: .alert)
            return
          }
            UserDefaults.standard.set(true, forKey: "UserLoggedIn")
            if let storyboard = self.storyboard {
                let vc = storyboard.instantiateViewController(withIdentifier: "homeVC") as! UINavigationController
                let appsDelegate = UIApplication.shared.delegate
                appsDelegate?.window!!.rootViewController = nil
                appsDelegate?.window!!.rootViewController = vc
                self.present(vc, animated: false, completion: nil)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.backItem?.hidesBackButton = true
        
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
}
