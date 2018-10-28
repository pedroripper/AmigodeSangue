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

        print(getReceiverName)
    }
    
    @IBAction func openChatButtonTapped() {
        
    }
    
       
    
}
