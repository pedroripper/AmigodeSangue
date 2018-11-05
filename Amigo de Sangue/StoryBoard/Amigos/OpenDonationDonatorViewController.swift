//
//  OpenDonationDonatorViewController.swift
//  Amigo de Sangue
//
//  Created by Pedro Ripper on 26/10/18.
//  Copyright © 2018 Pedro Ripper. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase
import JGProgressHUD

class OpenDonationDonatorViewController: UIViewController {
    var db: Firestore = Firestore.firestore()
    let userUID: String = Auth.auth().currentUser!.uid as String
    
    
    //RECEIVER DATA
    var getReceiverUID = String()
    
    var receiverBloodTypeCode: Int!
    
    @IBOutlet var receiverNameLabel: UILabel!
    @IBOutlet var receiverBloodTypeLabel: UILabel!
    @IBOutlet var centerNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
        
    func loadData(){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Carregando"
        hud.show(in: self.view)
        db.collection("users").document(userUID).collection("OpenDonationsDonator").document("\(getReceiverUID)").getDocument { (document, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                self.centerNameLabel.text = document?.get("selectedCenter") as? String
                self.receiverNameLabel.text = document?.get("receiverName") as? String
                self.receiverBloodTypeCode = document?.get("receiverBloodTypeCode") as? Int
                self.receiverBloodTypeLabel.text = self.bloodTypeDecoder(code: self.receiverBloodTypeCode)
                hud.dismiss(afterDelay: 0.0)
            }
        }
        
    }
    
   
    @IBAction func cancelDonationButtonTapped() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Carregando"
        hud.show(in: self.view)
        self.db.collection("users").document("\(self.userUID)").collection("OpenDonationsDonator").document("\(getReceiverUID)").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        self.db.collection("users").document("\(getReceiverUID)").collection("OpenDonationsReceiver").document("\(userUID)").setData([
            "isCancelled" : true as Bool
            ], merge: true)
        hud.dismiss(afterDelay: 0.0)

    }
    @IBAction func donationCompletedButtonTapped() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Carregando"
        hud.show(in: self.view)
        self.db.collection("users").document("\(self.userUID)").collection("OpenDonationsDonator").document("\(getReceiverUID)").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        self.db.collection("users").document("\(getReceiverUID)").collection("OpenDonationsReceiver").document("\(userUID)").setData([
            "isDone" : true as Bool
            ], merge: true)
        hud.dismiss(afterDelay: 0.0)
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
