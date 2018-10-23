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
    @IBOutlet var birthDate: UILabel!
    @IBOutlet var wannaDonateSwitch: UISwitch!
    
    var bloodTypecd: Int?
    var db = Firestore.firestore()
    let userUID: String = Auth.auth().currentUser!.uid as String
    
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
                self.birthDate.text = document.get("birthdate") as? String
                hud.dismiss(afterDelay: 0.0)
            }
            else { print("shit data")}
            
        }
        
    }
    
   /* func setUpNavController(){
        //Logout Button
        let logOutButtonImage = UIImageView(image:UIImage(named: "logout"))
        let logOutButton = UIButton(type: .system)
        logOutButton.setImage(logOutButtonImage.image, for: .normal)
        logOutButtonImage.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logOutButton)
        
        let logoutRecognizer = UITapGestureRecognizer(target: self, action: #selector(UserViewController.lougoutButtonTapped))
        logOutButton.isUserInteractionEnabled = true
        logOutButton.addGestureRecognizer(logoutRecognizer)
        
        //User Configurations Button
        let confUserButtonImage = UIImageView(image: UIImage(named: "settings"))
        let confUserButton = UIButton(type: .system)
        confUserButton.setImage(confUserButtonImage.image, for: .normal)
        confUserButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: confUserButton)
        
        let configRecognizer = UITapGestureRecognizer(target: self, action: #selector(UserViewController.confUserButtonTapped))
        confUserButton.isUserInteractionEnabled = true
        confUserButton.addGestureRecognizer(configRecognizer)
        
        
    }*/
    
    
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
    
    @IBAction func wannaDonateSwitchTapped(_ sender: Any) {
        if wannaDonateSwitch.isOn{
            db.collection("users").document(userUID).setData(["wantToContribute" : true], merge: true)
        }
        else{
            db.collection("users").document(userUID).setData(["wantToContribute" : false], merge: true)
        }
    }
    
    
    

}
