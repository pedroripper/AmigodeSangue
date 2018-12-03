//
//  AmigosViewController.swift
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

class AmigosViewController: UITableViewController {
    
    var requestsArray = [RequestCell]()
    var openDonatorsArray = [OpenDonatorCell]()
    var openReceiversArray = [OpenReceiverCell]()
    var db = Firestore.firestore()
    let userUID: String = Auth.auth().currentUser!.uid as String
    
    var receiverBloodTypeCode: Int?
    var receiverBloodType: String = " "
    var receiverName: String?
    
    var donatorBloodTypeCode: Int?
    var donatorBloodType: String = " "
    var donatorName: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavController()
        loadRequestsData()
        loadOpenDonationsDONATOR()
        loadOpenDonationsRECEIVER()
    }
    
    //LOAD NAVIGATION CONTROLLER
    func setUpNavController(){
        let logOutButtonImage = UIImageView(image:UIImage(named: "log-out"))
        let logOutButton = UIButton(type: .system)
        logOutButton.setImage(logOutButtonImage.image, for: .normal)
        logOutButtonImage.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logOutButton)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(AmigosViewController.lougoutButtonTapped))
        logOutButton.isUserInteractionEnabled = true
        logOutButton.addGestureRecognizer(recognizer)
        
        let refreshButtonImage = UIImageView(image: UIImage(named: "refresh"))
        let refreshButton = UIButton(type: .system)
        refreshButton.setImage(refreshButtonImage.image, for: .normal)
        refreshButtonImage.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: refreshButton)
        
        let refreshRecognizer = UITapGestureRecognizer(target: self, action: #selector(AmigosViewController.refreshButtonTapped))
        refreshButton.addGestureRecognizer(refreshRecognizer)
        refreshButton.isUserInteractionEnabled = true
    }
    @objc private func lougoutButtonTapped(){
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
    @objc private func refreshButtonTapped(){
        loadRequestsData()
        loadOpenDonationsRECEIVER()
        loadOpenDonationsDONATOR()
    }
    
    //LOAD USERS REQUESTS
    func loadRequestsData(){
        db.collection("users").document(userUID).collection("ReceiversRequest").getDocuments { (QuerySnapshot, error) in
            if let error = error{
                print("\(error.localizedDescription)")
            } else {
                let hud = JGProgressHUD(style: .dark)
                hud.textLabel.text = "Carregando"
                hud.show(in: self.view)
                self.requestsArray = QuerySnapshot!.documents.compactMap({ RequestCell(requestDictionary: $0.data())})
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    hud.dismiss(afterDelay: 0.0)
                }
            }
        }
    }
    
    //LOAD OPEN DONATIONS AS DONATOR
    func loadOpenDonationsDONATOR(){
        db.collection("users").document(userUID).collection("OpenDonationsDonator").getDocuments { (QuerySnapshot, error) in if let error = error{
                print("\(error.localizedDescription)")
            } else {
                let hud = JGProgressHUD(style: .dark)
                hud.textLabel.text = "Carregando"
                hud.show(in: self.view)
                self.openDonatorsArray = QuerySnapshot!.documents.compactMap({ OpenDonatorCell(openDonationsDonatorDictionary: $0.data())})
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    hud.dismiss(afterDelay: 0.0)
                }
            }
        }
    }
    
    //LOAD OPEN DONATIONS AS RECEIVER
    func loadOpenDonationsRECEIVER(){
        db.collection("users").document(userUID).collection("OpenDonationsReceiver").getDocuments { (QuerySnapshot, error) in if let error = error{
            print("\(error.localizedDescription)")
        } else {
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Carregando"
            hud.show(in: self.view)
            self.openReceiversArray = QuerySnapshot!.documents.compactMap({ OpenReceiverCell(openDonationsReceiverDictionary: $0.data())})
            DispatchQueue.main.async {
                print("loadDonationsReceiver")
                self.tableView.reloadData()
                hud.dismiss(afterDelay: 0.0)
            }
            }
        }
    }
    
    //CONVERT BLOODTYPE CODE TO STRING
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
        let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        //BLOOD TRANSFUSION REQUESTS FOR DONATORS
        if indexPath.section == 0 {
            let requesters = requestsArray[indexPath.row]
            let RequestsVC = StoryBoard.instantiateViewController(withIdentifier: "AcceptDonationViewController") as! AcceptDonationViewController
            RequestsVC.getReceiverName = requesters.receiverName
            RequestsVC.getReceiverUID = requesters.receiverUID
            RequestsVC.getReceiverBloodTypeCode = requesters.receiverBloodTypeCode
            RequestsVC.getReceiverBloodType = self.receiverBloodType
            self.navigationController?.pushViewController(RequestsVC, animated: false)
        }
        //BLOOD TRANSFUSIONS IN PROCESS FOR RECEIVERS
        if indexPath.section == 1 {
            let donators = openReceiversArray[indexPath.row]
            let DonationsReceiverVC = StoryBoard.instantiateViewController(withIdentifier: "OpenDonationReceiverViewController") as! OpenDonationReceiverViewController
            DonationsReceiverVC.getDonatorUID = donators.donatorUID
            self.navigationController?.pushViewController(DonationsReceiverVC, animated: false)
        }
        //BLOOD TRANSFUSIONS IN PROCESS FOR DONATORS
        if indexPath.section == 2 {
            let receivers = openDonatorsArray[indexPath.row]
            let DonationsDonatorVC = StoryBoard  .instantiateViewController(withIdentifier: "OpenDonationDonatorViewController") as! OpenDonationDonatorViewController
            DonationsDonatorVC.getReceiverUID = receivers.receiverUID
            self.navigationController?.pushViewController(DonationsDonatorVC, animated: false)
            
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.backgroundColor = UIColor.gray
        if section == 0{
            headerLabel.text = "Pedidos de Doação"
        }
        if section == 1{
            headerLabel.text = "Meus Pedidos de Doação"
        }
        if section == 2 {
            headerLabel.text = "Doações para eu fazer"
        }
        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return requestsArray.count as Int
       }
        if section == 1{
            return openReceiversArray.count as Int
        }
        else{
            return openDonatorsArray.count as Int
        }
 
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "amigosCell", for: indexPath)
        
       if indexPath.section == 0{
            let requesters = requestsArray[indexPath.row]
            self.receiverBloodType = bloodTypeDecoder(code: requesters.receiverBloodTypeCode)!
            cell.textLabel?.text = "\(requesters.receiverName)"
            cell.detailTextLabel?.text = "Sangue: \(receiverBloodType)"
            return cell
        }
       if indexPath.section == 1{
            let openReceivers = openReceiversArray[indexPath.row]
            self.donatorBloodType = bloodTypeDecoder(code: openReceivers.donatorBloodTypeCode)!
            cell.textLabel?.text = "\(openReceivers.donatorName)"
            cell.detailTextLabel?.text = "Sangue: \(donatorBloodType)"
            return cell
        }
        else{
            let openDonators = openDonatorsArray[indexPath.row]
            self.receiverBloodType = bloodTypeDecoder(code: openDonators.receiverBloodTypeCode)!
            cell.textLabel?.text = "\(openDonators.receiverName)"
            cell.detailTextLabel?.text = "Sangue: \(receiverBloodType)"
            return cell
        }
        
        
    }
    
    
    
    
    
}

