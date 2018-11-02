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


class OpenDonationReceiverViewController: UIViewController {
    var db: Firestore = Firestore.firestore()
    let userUID: String = Auth.auth().currentUser!.uid as String
    
    @IBOutlet weak var donatorNameTextField: UILabel!
    @IBOutlet weak var donatorBloodTextField: UILabel!
    @IBOutlet weak var requestedCenterName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadData(){
        self.db.collection("users").document(userUID).collection("OpenDonationsReceiver").document()
    }
    
    
    

}
