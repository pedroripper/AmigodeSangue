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

class DonatorViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var donatorsTableView: UITableView!

    var donators = [DonatorCell]()
    
    
    
    var donatorUsername: String?
    var donatorBloodTypecd: Int?
    var donatorBloodType: String?
    
    var userBloodcd: Int?
    var userBlood: String?
    var reqBlood: String?
    
    var db: Firestore!
    let userUID: String = Auth.auth().currentUser!.uid as String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavController()
        
        db = Firestore.firestore()
        loadData()
        
        
    }

    
    func loadData(){
       /* self.db.collection("users").document(userUID).getDocument { (document, error) in
            if let document = document, document.exists{
                print("GOT DOC")
                self.userBloodcd = document.get("bloodTypeCode") as? Int
                self.bloodTypeDecoder()
            } }
            self.db.collection("users").getDocuments(completion: { (QuerySnapshot, error) in
                if let error = error{
                    print("\(error.localizedDescription)")
                } else {
                    self.donators = QuerySnapshot!.documents.compactMap({ DonatorCell(dictionary: $0.data())})
                    DispatchQueue.main.async {
                        self.donatorsTableView.reloadData()
                    }
                }
            })*/
        self.db.collection("users").getDocuments(completion: { (querysnapshot, error) in
            if let error = error{
                print("\(error.localizedDescription)")
            } else {
                print(querysnapshot as Any)
                self.donators = querysnapshot!.documents.compactMap({ DonatorCell(dictionary: $0.data())})
                                    DispatchQueue.main.async {
                    print("AWESOME")
                    self.donatorsTableView.reloadData()
                }
            }
        })
      

        
    }
    
    
    func compatibleBloods(){
        if userBlood == "A+" {
            
        }
        
    }
    
    
    func setUpNavController(){
        let logOutButtonImage = UIImageView(image:UIImage(named: "logout"))
        let logOutButton = UIButton(type: .system)
        logOutButton.setImage(logOutButtonImage.image, for: .normal)
        logOutButtonImage.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logOutButton)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(DonatorViewController.lougoutButtonTapped))
        logOutButton.isUserInteractionEnabled = true
        logOutButton.addGestureRecognizer(recognizer)
        
    }
        
    @objc private func lougoutButtonTapped(){
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
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
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.donatorsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let donator = donators[indexPath.row]
        cell.textLabel?.text = "Nome: \(donator.name)"
        cell.detailTextLabel?.text = "\(donator.bloodTypeCode)"
        
        return cell
    }
    


}
