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
    @IBOutlet var bloodPeriodLabel: UILabel!
    
    var bloodTypecd: Int?
    var db = Firestore.firestore()
    let userUID: String = Auth.auth().currentUser!.uid as String
    
    var birthDate: Date?
    var lastDonation: Date?
    var numberOfDonations: Int = 0
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
                self.numberOfDonations = document.get("numberOfDonations") as! Int
                self.numberOfDonationsLabel.text = "Número de Doações: \(self.numberOfDonations)"
                if self.numberOfDonations != 0 {
                self.lastDonation = document.get("lastDonation") as? Date
                self.isDonationPeriodOk()
                self.lastDonationDateLabel.text = "Última Doação: \(self.formatDateToString(date: self.lastDonation!))"
                } else {
                    self.lastDonationDateLabel.text = "Nunca doou"
                    self.isFirstTime()
                }
                hud.dismiss(afterDelay: 0.0)
            }
            else {print("shit data")}
        }
    }

    @IBAction func logOutButtonTapped() {
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
    
    func isDonationPeriodOk() {
        let date1 = Date()
        let form = DateComponentsFormatter()
        form.maximumUnitCount = 2
        form.unitsStyle = .full
        form.allowedUnits = [.month]
        let s = form.string(from: self.lastDonation!, to: date1)
        if s != "0 months" && s != "1 months" && s != "2 months" {
            self.bloodPeriodLabel.textColor = UIColor.green
            self.bloodPeriodLabel.text = "Está no período de doar"
        }
        
    }
    func isFirstTime() {
        if self.numberOfDonations == 0 {
            self.bloodPeriodLabel.textColor = UIColor.green
            self.bloodPeriodLabel.text = "Está no período de doar"
        }
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
