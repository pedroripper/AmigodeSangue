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
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData(){
        self.receiverNameLabel.text = getReceiverName
        self.receiverBloodTypeLabel.text = getReceiverBloodType
        print(getReceiverName)
    }
    
    @IBAction func acceptRequestButtonTapped() {
            //GET DONATOR DATA
            db.collection("users").document(userUID).getDocument { (document, error) in
            if let document = document, document.exists{
                self.donatorName = document.get("name") as? String
                self.donatorBloodTypeCode = document.get("bloodTypeCode") as? Int
            }
            //STORE DONATION INFO
            self.db.collection("users").document(self.userUID).collection("OpenDonationsDonator").addDocument(data:[
            "donatorBloodTypeCode": self.donatorBloodTypeCode as Int,
            "donatorName": self.donatorName as String,
            "donatorUID": self.userUID as String,
            "receiverBloodTypeCode": self.getReceiverBloodTypeCode as Int,
            "receiverName": self.getReceiverName as String,
            "receiverUID": self.getReceiverUID as String,
            "isDone": false as Bool
            ])
    }
        self.db.collection("users").document(self.userUID).collection("ReceiversRequest").document(getReceiverUID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
}