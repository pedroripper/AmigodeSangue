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
    
    //Centers
    let centerNames = ["Selecionar","Hemorio - Centro","Banco de Sangue Serum","Santa Casa de Misericórdia"]
    @IBOutlet var centerPicker: UITextField!
    let centersPicker = UIPickerView()
    var selectedCenter: String = ""
    
    
    @IBOutlet var donatorNameLabel: UILabel!
    @IBOutlet var donatorBloodTypeLabel: UILabel!
    @IBOutlet var donatorStatsOkLabel: UILabel!
    @IBOutlet var requestSentLabel: UILabel!
    
    
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
        db.collection("users").document("\(getDonatorUID)").collection("ReceiversRequest").document(userUID).setData( [
            "receiverUID": userUID,
            "donatorUID": getDonatorUID,
            "receiverBloodTypeCode": userBloodTypecode as Any,
            "donatorBloodTypeCode": getDonatorBloodTypeCode,
            "donatorName": getDonatorName,
            "receiverName": username as Any,
            "selectedCenter": centerPicker.text!
            ])
        self.requestSentLabel.text = "Pedido Enviado!"
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
