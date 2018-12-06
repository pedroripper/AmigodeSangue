//
//  RequestDonationViewController.swift
//  Amigo de Sangue
//
//  Created by Pedro Ripper on 24/10/2018.
//  Copyright © 2018 Pedro Ripper. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase
import JGProgressHUD

class RequestDonationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
  
    var db: Firestore = Firestore.firestore()
    let userUID: String = Auth.auth().currentUser!.uid as String
    //Donator data
    var getDonatorName = String()
    var getDonatorBloodType = String()
    var getDonatorBloodTypeCode = Int()
    var getDonatorUID = String()
    var getDonatorWannaDonate = Bool()
    var getReceiverFilteredBloodcd = Int()
    
    //Centers
    let centerNames = ["Selecionar","Hemorio - Centro","Banco de Sangue Serum","Santa Casa de Misericórdia"]
    @IBOutlet var centerPicker: UITextField!
    let centersPicker = UIPickerView()
    var selectedCenter: String = ""
    
    
    @IBOutlet var donatorNameLabel: UILabel!
    @IBOutlet var donatorBloodTypeLabel: UILabel!
    @IBOutlet var donatorStatsOkLabel: UILabel!
    @IBOutlet var requestSentLabel: UILabel!
    
    @IBOutlet var receiverNameTextField: UITextField!
    @IBOutlet var receiverInfoTextField: UITextField!
    
    
    
    var userBloodTypecode: Int?
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userData()
        loadData()
        createCentersPicker()
        createToolBar()
    }
    
    func userData(){
        db.collection("users").document(userUID).getDocument { (document, error) in
        if let document = document, document.exists{
            self.userBloodTypecode = document.get("bloodTypeCode") as? Int
            self.username = document.get("name") as? String
            self.receiverNameTextField.text = self.username
            }
        }
    }

    func loadData(){
        self.donatorNameLabel.text = self.getDonatorName
        self.donatorBloodTypeLabel.text = self.getDonatorBloodType
        if getDonatorWannaDonate == false{
            donatorStatsOkLabel.textColor = UIColor.red
            donatorStatsOkLabel.text = "Doador não está apto."
        } else {
            donatorStatsOkLabel.textColor = UIColor.green
            donatorStatsOkLabel.text = "Doador pode doar."
        }
    }
    
    func createCentersPicker(){
        centersPicker.delegate = self
        self.centerPicker.inputView = centersPicker
    }
    
    
    @IBAction func askDonationButtonTapped() {
        if self.receiverNameTextField.text == self.username {
        db.collection("users").document("\(getDonatorUID)").collection("ReceiversRequest").document(userUID).setData( [
            "receiverUID": userUID,
            "donatorUID": getDonatorUID,
            "receiverBloodTypeCode": getReceiverFilteredBloodcd as Any,
            "donatorBloodTypeCode": getDonatorBloodTypeCode,
            "donatorName": getDonatorName,
            "receiverName": username as Any,
            "selectedCenter": centerPicker.text! as Any,
            "isSelfDonation": true,
            "receiverInfo": receiverInfoTextField.text! as Any
            ])
        self.requestSentLabel.text = "Pedido Enviado!"
        } else {
            db.collection("users").document("\(getDonatorUID)").collection("ReceiversRequest").document(userUID).setData( [
                "receiverUID": userUID,
                "donatorUID": getDonatorUID,
                "receiverBloodTypeCode": getReceiverFilteredBloodcd as Any,
                "donatorBloodTypeCode": getDonatorBloodTypeCode,
                "donatorName": getDonatorName,
                "receiverName": receiverNameTextField.text as Any,
                "selectedCenter": centerPicker.text!,
                "isSelfDonation": false,
                "whoAsked": username!,
                "receiverInfo": receiverInfoTextField.text!
                ])
            self.requestSentLabel.text = "Pedido Enviado!"
        }
        
    }
    
    func createToolBar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SignUpViewController.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.centerPicker.inputAccessoryView = toolBar
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return centerNames.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return centerNames[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCenter = centerNames[row]
        self.centerPicker.text = selectedCenter
    }
    
}

extension RequestDonationViewController {
    func bloodTypeDecoder(code: Int?) -> String?{
        let btCD = code
        var decode: String?
        if btCD == 11{
            decode = "A+"
        }
        if btCD == 10{
            decode = "A-"
        }
        if btCD == 21{
            decode = "B+"
        }
        if btCD == 20{
            decode = "B-"
        }
        if btCD == 31{
            decode = "AB+"
        }
        if btCD == 30{
            decode = "AB-"
        }
        if btCD == 41{
            decode = "O+"
        }
        if btCD == 40{
            decode = "O-"
        }
        return decode
    }
}
