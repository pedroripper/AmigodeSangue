//
//  OpenDonationReceiverViewController.swift
//  Amigo de Sangue
//
//  Created by Pedro Ripper on 26/10/18.
//  Copyright © 2018 Pedro Ripper. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import JGProgressHUD


class OpenDonationReceiverViewController: UIViewController {
    var db: Firestore = Firestore.firestore()
    let userUID: String = Auth.auth().currentUser!.uid as String
    
    //DONATOR DATA
    var getDonatorUID = String()
    
    @IBOutlet weak var donatorNameTextField: UILabel!
    @IBOutlet weak var donatorBloodTextField: UILabel!
   
    var donatorBloodTypeCode: Int?
    var isDonationCancelled: Bool?
    var isDonationCompleted: Bool?
    
    
    @IBOutlet var donationStatusLabel: UILabel!
    
    @IBOutlet var eraseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        self.eraseButton.isHidden = true
    }
    
    func loadData(){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Carregando"
        hud.show(in: self.view)
        self.db.collection("users").document(userUID).collection("OpenDonationsReceiver").document("\(getDonatorUID)").getDocument { (document, error) in
            if let error =  error {
                print("Error: \(error.localizedDescription)")
            } else {
                self.donatorNameTextField.text = document?.get("donatorName") as? String
                self.donatorBloodTypeCode = document?.get("donatorBloodTypeCode") as? Int
                self.donatorBloodTextField.text = self.bloodTypeDecoder(code: self.donatorBloodTypeCode)
                self.isDonationCancelled = document?.get("isCancelled") as? Bool
                self.isDonationCompleted = document?.get("isDone") as? Bool
                hud.dismiss(afterDelay: 0.0)
                self.checkForDonationStatus()
            }
        }
    }
    
    func checkForDonationStatus(){
        if self.isDonationCancelled == true {
            self.donationStatusLabel.textColor = UIColor.red
            self.donationStatusLabel.text = "A doaçāo foi cancelada..."
            self.eraseButton.isHidden = false
        }
        if self.isDonationCompleted == true {
            self.donationStatusLabel.textColor = UIColor.green
            self.donationStatusLabel.text = "A doaçāo foi realizada!"
            self.eraseButton.isHidden = false
        }
    }
    
    
    @IBAction func eraseDonationButtonTapped() {
        self.db.collection("users").document("\(userUID)").collection("OpenDonationsReceiver").document("\(getDonatorUID)").delete() { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Document deleted")
            }
        }
        }
    
    
    //CONVERT BLOODTYPE CODE TO STRING
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
