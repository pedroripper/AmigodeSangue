//
//  AcceptDonationViewController.swift
//  Amigo de Sangue
//
//  Created by Pedro Ripper on 25/10/18.
//  Copyright © 2018 Pedro Ripper. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase
import JGProgressHUD

class AcceptDonationViewController: UIViewController {

    var db: Firestore = Firestore.firestore()
    let userUID: String = Auth.auth().currentUser!.uid as String
    
    //RECEIVER DATA
    var getReceiverName = String()
    var getReceiverBloodType = String()
    var getReceiverBloodTypeCode = Int()
    var getReceiverUID = String()
    
    var donatorName: String!
    var donatorBloodTypeCode: Int!
    
    @IBOutlet var receiverNameLabel: UILabel!
    @IBOutlet var receiverBloodTypeLabel: UILabel!
    
    @IBOutlet weak var requestedCenterName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData(){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Carregando"
        hud.show(in: self.view)
        self.receiverNameLabel.text = getReceiverName
        self.receiverBloodTypeLabel.text = getReceiverBloodType
        print(getReceiverName)
        self.db.collection("users").document(self.userUID).collection("ReceiversRequest").document(getReceiverUID).getDocument { (DocumentSnapshot, error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                self.requestedCenterName.text = DocumentSnapshot?.get("selectedCenter") as? String
            }
        }
        hud.dismiss(afterDelay: 0.0)
    }
    
    @IBAction func acceptRequestButtonTapped() {
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Carregando"
            hud.show(in: self.view)
            //DONATOR DATA
            db.collection("users").document(userUID).getDocument { (document, error) in
            if let document = document, document.exists{
                self.donatorName = document.get("name") as? String
                self.donatorBloodTypeCode = document.get("bloodTypeCode") as? Int
            
            //STORE DONATION INFO FOR DONATOR
            self.db.collection("users").document(self.userUID).collection("OpenDonationsDonator").document("\(self.getReceiverUID)").setData([
                "donatorBloodTypeCode": self.donatorBloodTypeCode as Int,
                "donatorName": self.donatorName as String,
                "donatorUID": self.userUID as String,
                "receiverBloodTypeCode": self.getReceiverBloodTypeCode as Int,
                "receiverName": self.getReceiverName as String,
                "receiverUID": self.getReceiverUID as String,
                "isDone": false as Bool,
                "selectedCenter": self.requestedCenterName.text ?? " -- "
                ])
    }
                self.db.collection("users").document(self.userUID).collection("ReceiversRequest").document("\(self.getReceiverUID)").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        //STORE DONATION INFO FOR RECEIVER
            self.db.collection("users").document(self.getReceiverUID).collection("OpenDonationsReceiver").document("\(self.userUID)").setData([
            "donatorBloodTypeCode": self.donatorBloodTypeCode as Int,
            "donatorName": self.donatorName as String,
            "donatorUID": self.userUID as String,
            "receiverBloodTypeCode": self.getReceiverBloodTypeCode as Int,
            "receiverName": self.getReceiverName as String,
            "receiverUID": self.getReceiverUID as String,
            "isDone": false as Bool,
            "isCancelled": false as Bool,
            "selectedCenter": self.requestedCenterName.text ?? " -- "
            ])
        hud.dismiss(afterDelay: 0.0)
        }
    }
    
    @IBAction func refuseRequestButtonTapped() {
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Carregando"
            hud.show(in: self.view)
            self.db.collection("users").document(self.userUID).collection("ReceiversRequest").document(getReceiverUID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        hud.dismiss(afterDelay: 0.0)
    }
    
    
}
