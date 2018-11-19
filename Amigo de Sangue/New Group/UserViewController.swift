//
//  UserViewController.swift
//  Amigo de Sangue
//
//  Created by Pedro Ripper on 01/10/2018.
//  Copyright © 2018 Pedro Ripper. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import JGProgressHUD

class UserViewController: UIViewController {
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var bloodTypeLabel: UILabel!
    @IBOutlet var wannaDonateSwitch: UISwitch!
    @IBOutlet var numberOfDonationsLabel: UILabel!
    @IBOutlet var lastDonationDateLabel: UILabel!
    @IBOutlet var birthdayDateLabel: UILabel!
    
    var bloodTypecd: Int?
    var db = Firestore.firestore()
    let userUID: String = Auth.auth().currentUser!.uid as String
    
    var birthDate: Date?
    var lastDonation: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
    }
    func setUpViewController(){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Carregando"
        hud.show(in: self.view)
        print(Auth.auth().currentUser?.uid as Any)
        db.collection("users").document(userUID).getDocument { (document, error) in
            if let document = document, document.exists{
                print("GOT DOC")
                self.usernameLabel.text = document.get("name") as? String
                self.bloodTypecd = document.get("bloodTypeCode") as? Int
                self.bloodTypeDecoder()
                self.birthDate = document.get("birthDate") as? Date
                self.birthdayDateLabel.text = self.formatDateToString(date: self.birthDate!)
                let numberOfDonations = document.get("numberOfDonations") as? Int ?? 0
                self.numberOfDonationsLabel.text = "Número de Doações: \(numberOfDonations)"
                if numberOfDonations != 0 {
                self.lastDonation = document.get("lastDonation") as? Date
                self.lastDonationDateLabel.text = "Última Doação: \(self.formatDateToString(date: self.lastDonation!))"
                } else { self.lastDonationDateLabel.text = "Nunca doou" }
                hud.dismiss(afterDelay: 0.0)
            }
            else { print("shit data")}
        }
    }

    @IBAction func logOutButtonTapped() {
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
    
    func bloodTypeDecoder(){
        if bloodTypecd == 11{
            self.bloodTypeLabel.text = "A+"
        }
        if bloodTypecd == 10{
            self.bloodTypeLabel.text = "A-"
        }
        if bloodTypecd == 21{
            self.bloodTypeLabel.text = "B+"
        }
        if bloodTypecd == 20{
            self.bloodTypeLabel.text = "B-"
        }
        if bloodTypecd == 31{
            self.bloodTypeLabel.text = "AB+"
        }
        if bloodTypecd == 30{
            self.bloodTypeLabel.text = "AB-"
        }
        if bloodTypecd == 41{
            self.bloodTypeLabel.text = "O+"
        }
        if bloodTypecd == 40{
            self.bloodTypeLabel.text = "O-"
        }
    
    }
    
    func formatDateToString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date as Date)
    }
    
    
    @IBAction func wannaDonateSwitchTapped(_ sender: Any) {
        if wannaDonateSwitch.isOn{
            db.collection("users").document(userUID).setData(["wantToContribute" : true], merge: true)
        }
        else{
            db.collection("users").document(userUID).setData(["wantToContribute" : false], merge: true)
        }
    }
}
