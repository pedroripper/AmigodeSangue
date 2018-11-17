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
    
    var userBloodcd: Int = 31
    var userBlood: String?
    var reqBlood: String?
    var compatibleBloods: [Int] = []

    
    var db = Firestore.firestore()
    let userUID: String = Auth.auth().currentUser!.uid as String
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavController()
        loadData()
    }
    
    func loadData(){
        self.db.collection("users").document("\(userUID)").getDocument { (document, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                self.userBloodcd = document?.get("bloodTypeCode") as! Int
                print("Blood cd: \(self.userBloodcd)")
                self.compatibleBloods.removeAll()
                self.compatibleBloods += self.compatibleBloodTypes(code: self.userBloodcd)
                print("User compatible bloods: \(self.compatibleBloods)")
                self.getDataToCells()
            }
        }
    }
    func getDataToCells(){
            print("11111111111")
        self.db.collection("users").whereField("canDonateTo", arrayContains: userBloodcd as Int).whereField("wantToContribute", isEqualTo: true).getDocuments(completion: { (QuerySnapshot, error) in
                if let error = error{
                    print("\(error.localizedDescription)")
                } else {
                    let hud = JGProgressHUD(style: .dark)
                    hud.textLabel.text = "Carregando"
                    hud.show(in: self.view)
                    print(QuerySnapshot as Any)
                    self.donatorsArray = QuerySnapshot!.documents.compactMap({ DonatorCell(dictionary: $0.data())})
                    DispatchQueue.main.async {
                        print(self.donatorsArray)
                        self.tableView.reloadData()
                        hud.dismiss(afterDelay: 0.0)
                        }
                        }
            })
    }
    
    func setUpNavController(){
        let logOutButtonImage = UIImageView(image:UIImage(named: "log-out"))
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
    
    func compatibleBloodTypes(code: Int?) -> [Int]{
        let userBlood = code
        var comptBlood: [Int]?
        if userBlood == 11 {
             comptBlood = [11,10,41,40]
        }
        if userBlood == 10 {
            comptBlood = [10,40]
        }
        if userBlood == 21{
            comptBlood = [21,20,41,40]
        }
        if userBlood == 20 {
            comptBlood = [20,40]
        }
        if userBlood == 31{
            comptBlood = [11,10,21,20,31,30,41,40]
        }
        if userBlood == 30 {
            comptBlood = [30,40,10,20]
        }
        if userBlood == 41 {
            comptBlood = [41,40]
        }
        if userBlood == 40 {
            comptBlood = [40]
        }
        return comptBlood!
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        let donator = donatorsArray[indexPath.row]
        let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let DestinatedVC = StoryBoard.instantiateViewController(withIdentifier: "RequestDonationViewController") as! RequestDonationViewController
        DestinatedVC.getDonatorName = donator.name
        let donatorBloodType = bloodTypeDecoder(code: donator.bloodTypeCode)!
        DestinatedVC.getDonatorBloodType = donatorBloodType
        DestinatedVC.getDonatorUID = donator.userUID
        DestinatedVC.getDonatorBloodTypeCode  = donator.bloodTypeCode
        DestinatedVC.getDonatorWannaDonate = donator.wantToContribute
        self.navigationController?.pushViewController(DestinatedVC, animated: false)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return donatorsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        print(donatorsArray[indexPath.row])
        print("\(indexPath)")
        print("\(indexPath.row)")
        let donator = donatorsArray[indexPath.row]
        donatorBloodType = bloodTypeDecoder(code: donator.bloodTypeCode)!
        cell.textLabel?.text = "\(donator.name)"
        cell.detailTextLabel?.text = "Sangue: \(donatorBloodType)"
        return cell
    }
    
}


