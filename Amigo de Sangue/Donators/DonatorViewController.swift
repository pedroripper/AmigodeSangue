//
//  DonatorViewController.swift
//  Amigo de Sangue
//
//  Created by Pedro Ripper on 16/09/2018.
//  Copyright © 2018 Pedro Ripper. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase
import JGProgressHUD

class DonatorViewController: UITableViewController {
    

    var donatorsArray = [DonatorCell]()
    
    var donatorUsername: String?
    var donatorBloodTypecd: Int?
    var donatorBloodType: String = ""
    
    var userBloodcd: Int?
    var userBlood: String?
    var reqBlood: String?
    var compatibleBloods = [Int]()
    
    var db = Firestore.firestore()
    let userUID: String = Auth.auth().currentUser!.uid as String
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavController()
       // compatibleBlood()
        loadData()
        
        
    }

    /*func compatibleBlood(){
        self.db.collection("users").document(userUID).getDocument { (document, error) in
            if let document = document, document.exists{
                print("GOT DOC")
                self.userBloodcd = document.get("bloodTypeCode") as? Int
                
                if self.self.userBloodcd == 11{
                    self.compatibleBloods.append(contentsOf: [11,10,41,40])
                }
                if self.userBloodcd == 10{
                    self.compatibleBloods.append(contentsOf: [10,40])
                }
                if self.userBloodcd == 21{
                    self.compatibleBloods.append(contentsOf: [21,20,41,40])
                }
                if self.userBloodcd == 20{
                    self.compatibleBloods.append(contentsOf: [20,40])
                }
                if self.userBloodcd == 31{
                    self.compatibleBloods.append(contentsOf: [11,10,21,20,31,30,41,40])
                }
                if self.userBloodcd == 30{
                    self.compatibleBloods.append(contentsOf: [10,20,30,40])
                }
                if self.userBloodcd == 40{
                    self.compatibleBloods.append(contentsOf: [40])
                }
                if self.userBloodcd == 41{
                    self.compatibleBloods.append(contentsOf: [40,41])
                }
                
                
            } else { print("shit data")}}
    }*/
    
    func loadData(){
        self.db.collection("users").getDocuments(completion: { (QuerySnapshot, error) in
            if let error = error{
                print("\(error.localizedDescription)")
            } else {
                let hud = JGProgressHUD(style: .dark)
                hud.textLabel.text = "Carregando"
                hud.show(in: self.view)
                print(QuerySnapshot as Any)
                self.donatorsArray = QuerySnapshot!.documents.compactMap({ DonatorCell(dictionary: $0.data())})
                DispatchQueue.main.async {
                    print("AWESOME")
                    self.tableView.reloadData()
                    hud.dismiss(afterDelay: 0.0)

                }
            }
        })
        
       /* self.db.collection("users").whereField("bloodTypeCode", arrayContains: self.compatibleBloods).getDocuments(completion: { (QuerySnapshot, error) in
            if let error = error{
                print("\(error.localizedDescription)")
            } else {
                print(QuerySnapshot as Any)
                self.donatorsArray = QuerySnapshot!.documents.compactMap({ DonatorCell(dictionary: $0.data())})
                DispatchQueue.main.async {
                    print("AWESOME")
                    self.tableView.reloadData()
                }
            }
        })*/
    }
    
    func setUpNavController(){
        let logOutButtonImage = UIImageView(image:UIImage(named: "logout"))
        let logOutButton = UIButton(type: .system)
        logOutButton.setImage(logOutButtonImage.image, for: .normal)
        logOutButtonImage.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logOutButton)
        
        let refreshButtonImage = UIImageView(image: UIImage(named: "refresh"))
        let refreshButton = UIButton(type: .system)
        refreshButton.setImage(refreshButtonImage.image, for: .normal)
        refreshButtonImage.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: refreshButton)
        
        
        let logOutRecognizer = UITapGestureRecognizer(target: self, action: #selector(DonatorViewController.lougoutButtonTapped))
        logOutButton.isUserInteractionEnabled = true
        logOutButton.addGestureRecognizer(logOutRecognizer)
        let refreshRecognizer = UITapGestureRecognizer(target: self, action: #selector(DonatorViewController.refreshButtonTapped))
        refreshButton.addGestureRecognizer(refreshRecognizer)
        refreshButton.isUserInteractionEnabled = true
        
        
    }
        
    @objc private func lougoutButtonTapped(){
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
    @objc private func refreshButtonTapped(){
        loadData()
    }
    
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
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return donatorsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let donator = donatorsArray[indexPath.row]
        donatorBloodType = bloodTypeDecoder(code: donator.bloodTypeCode)!
        cell.textLabel?.text = "\(donator.name)"
        cell.detailTextLabel?.text = "Sangue: \(donatorBloodType)"
        return cell
    }
    


}
