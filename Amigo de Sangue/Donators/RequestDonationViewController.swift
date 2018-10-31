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

class RequestDonationViewController: UIViewController{
    
    
  
    var db: Firestore = Firestore.firestore()
    let userUID: String = Auth.auth().currentUser!.uid as String
    //Donator data
    var getDonatorName = String()
    var getDonatorBloodType = String()
    var getDonatorBloodTypeCode = Int()
    var getDonatorUID = String()
    var getDonatorWannaDonate = Bool()
    
    //Centers
    var centersArray = [center]()
    var centersNames: [String]?
    @IBOutlet var centerPicker: UITextField!
    let centersPicker = UIPickerView()
    var selectedCenter: String?
    
    
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
     //   loadCenters()
    }
 /*
    func loadCenters(){
        db.collection("centers").getDocuments { (QuerySnapshot, error) in
            if let error = error{
                print("\(error.localizedDescription)")
            } else {
                self.centersArray = QuerySnapshot!.documents.compactMap({center(centerDictionary:$0.data())})
                DispatchQueue.main.async {
                    self.centersNames = centersArray.
                }
            }
        }
    }
    */
    func userData(){
        db.collection("users").document(userUID).getDocument { (document, error) in
        if let document = document, document.exists{
        print("GOT DOC")
            self.userBloodTypecode = document.get("bloodTypeCode") as? Int
            self.username = document.get("name") as? String
            }
        }
    }
    

    
    
    
    func loadData(){
        donatorNameLabel.text = getDonatorName
        donatorBloodTypeLabel.text = getDonatorBloodType
        if getDonatorWannaDonate == false{
            donatorStatsOkLabel.textColor = UIColor.red
            donatorStatsOkLabel.text = "Doador não está apto."
        } else {
            donatorStatsOkLabel.textColor = UIColor.green
            donatorStatsOkLabel.text = "Doador pode doar."
        }
    }
    
    
    @IBAction func askDonationButtonTapped() {
       
        /*db.collection("users").document("\(getDonatorUID)").collection("ReceiversRequest").addDocument(data: [
            "receiverUID": userUID,
            "donatorUID": getDonatorUID,
            "receiverBloodTypeCode": userBloodTypecode as Any,
            "donatorBloodTypeCode": getDonatorBloodTypeCode,
            "donatorName": getDonatorName,
            "receiverName": username as Any
            ])*/
        db.collection("users").document("\(getDonatorUID)").collection("ReceiversRequest").document(userUID).setData( [
            "receiverUID": userUID,
            "donatorUID": getDonatorUID,
            "receiverBloodTypeCode": userBloodTypecode as Any,
            "donatorBloodTypeCode": getDonatorBloodTypeCode,
            "donatorName": getDonatorName,
            "receiverName": username as Any
            ])
        self.requestSentLabel.text = "Pedido Enviado!"
    }
    /*
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return centersArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       // return centersArray[index]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
    }*/
    
}
