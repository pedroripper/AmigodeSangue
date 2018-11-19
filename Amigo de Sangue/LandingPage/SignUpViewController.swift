//
//  SignUpViewController.swift
//  Amigo de Sangue
//
//  Created by Pedro Ripper on 18/09/2018.
//  Copyright © 2018 Pedro Ripper. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase
import JGProgressHUD

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var db: Firestore!
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var bloodTypeTextField: UITextField!
    @IBOutlet var birthDateTextField: UITextField!
    
    let bloodTypePicker = UIPickerView()
    let bloodTypes = ["Selecionar","A+","A-","B+","B-","AB+","AB-","O+","O-"]
    var selectedBloodType: String?
    var bloodTypecd: Int?
    var canDonateTo: [Int] = []
    /*
     let genderTypePicker = UIPickerView()
     let genderTypes = ["Selecionar","Homem","Mulher","Outro"]
     var selectedGender: String? */
    let datePicker: UIDatePicker = UIDatePicker()
    var selectedDate: String?
    var birthDayDate: NSDate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickers()
        configureTextFields()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //CREATE ACCOUNT
    @IBAction func createAccountButtonTapped() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Carregando"
        //CHECK IF ANYTHING IS IN BLANK
        if emailTextField.text != "" && passwordTextField.text != "" && userIdTextField.text != "" && userIdTextField.text != "" && bloodTypeTextField.text != ""{
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if let error = error {
                    print("ERROR CREATING USER:")
                    print(error.localizedDescription)
                } else {
                    saveUserInfo()
                    print(self.bloodTypeTextField.text as Any)
                    hud.dismiss(afterDelay: 0.0)
                    self.performSegue(withIdentifier: "signUpSegue", sender: self)
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.userIdTextField.text = ""
                    print("USER SAVED SUCCESSFULLY")
                }
            }}
        //SAVE USER TO DATABASE
        func saveUserInfo(){
            bloodTypeCode()
            canDonateTo = donations()
            print(canDonateTo)
            let user =  Auth.auth().currentUser
            if user != nil {
                let userUID = user?.uid
                guard let usernameText = self.usernameTextField.text, !usernameText.isEmpty else{return}
                guard let userIdText = self.userIdTextField.text, !userIdText.isEmpty else{return}
                
                db.collection("users").document(userUID!).setData([
                    "name": usernameText,
                    "userId": userIdText,
                    "bloodTypeCode": bloodTypecd as Any,
                    // "gender": selectedGender as Any,
                    "wantToContribute": true,
                    "userUID": userUID as Any,
                    "canDonateTo": canDonateTo as Array,
                    "numberOfDonations": 0,
                    "birthDate": birthDayDate! as NSDate
                    ])
                { err in
                    if let err = err {
                        print("Error writing document: \(err)")} else {print("Document successfully written!")}
                }
            }
            self.bloodTypeTextField.text = ""
        }
    }
    
    @IBAction func goBackButtonTapped() {
        dismiss(animated: false, completion: nil)
    }
    
    func configureTextFields(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Pronto", style: .plain, target: self, action: #selector(SignUpViewController.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.bloodTypeTextField.inputAccessoryView = toolBar
        self.userIdTextField.inputAccessoryView = toolBar
        self.emailTextField.inputAccessoryView = toolBar
        self.passwordTextField.inputAccessoryView = toolBar
        self.usernameTextField.inputAccessoryView = toolBar
        self.birthDateTextField.inputAccessoryView = toolBar
        //   self.genderTextField.inputAccessoryView = toolBar
        
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func createPickers(){
        bloodTypePicker.delegate = self
        self.bloodTypeTextField.inputView = bloodTypePicker
        
        self.datePicker.timeZone = NSTimeZone.local
        self.birthDateTextField.inputView = datePicker
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.addTarget(self, action: #selector(SignUpViewController.datePickerValueChanged(_:)), for: .valueChanged)
    }

        
    
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateFormat =  "dd/MM/yyyy"
        self.birthDayDate = dateFormatter.date(from: self.birthDateTextField.text!) as NSDate?
        let selectedDate: String = dateFormatter.string(from: datePicker.date)
        self.birthDateTextField.text = selectedDate

    }
    
    func bloodTypeCode(){
        if selectedBloodType == "A+"{
            bloodTypecd = 11
        }
        if selectedBloodType == "A-"{
            bloodTypecd = 10
        }
        if selectedBloodType == "B+"{
            bloodTypecd = 21
        }
        if selectedBloodType == "B-"{
            bloodTypecd = 20
        }
        if selectedBloodType == "AB+"{
            bloodTypecd = 31
        }
        if selectedBloodType == "AB-"{
            bloodTypecd = 30
        }
        if selectedBloodType == "O+"{
            bloodTypecd = 41
        }
        if selectedBloodType == "O-"{
            bloodTypecd = 40
        }
    }
    func donations()  -> [Int]{
        if bloodTypecd == 11 {
            return [11,31]
        }
        if bloodTypecd == 10 {
            return [10,30]
        }
        if bloodTypecd == 21 {
            return [21,31]
        }
        if bloodTypecd == 20 {
            return [20,30]
        }
        if bloodTypecd == 31 {
            return [31]
        }
        if bloodTypecd == 30 {
            return [31,30]
        }
        if bloodTypecd == 41 {
            return [11,21,31,41]
        }
        else{
            return [11,10,21,20,31,30,41,40]
        }
    }
    
    //UIPICKERVIEW
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bloodTypes.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bloodTypes[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == bloodTypePicker{
            selectedBloodType = bloodTypes[row]
            self.bloodTypeTextField.text = selectedBloodType
        }
        /*  if pickerView == genderTypePicker{
         selectedGender = genderTypes[row]
         self.genderTextField.text = selectedGender
         }*/
    }
    
    
    
}
