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
    @IBOutlet var genderTextField: UITextField!
    @IBOutlet var birthDateTextField: UITextField!
    
    let bloodTypePicker = UIPickerView()
    let bloodTypes = ["Selecionar","A+","A-","B+","B-","AB+","AB-","O+","O-"]
    var selectedBloodType: String?
    var bloodTypecd: Int?
    
    let genderTypePicker = UIPickerView()
    let genderTypes = ["Selecionar","Homem","Mulher","Outro"]
    var selectedGender: String?
    let birthDayPicker = UIDatePicker()
    var selectedDate: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBloodTypePicker()
        createToolBar()
        
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
                if user != nil{
                    saveUserInfo()
                    hud.dismiss(afterDelay: 0.0)
                    self.performSegue(withIdentifier: "signUpSegue", sender: self)
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.bloodTypeTextField.text = ""
                    self.userIdTextField.text = ""
                    }else {}}
            }
        //SAVE USER TO DATABASE
        func saveUserInfo(){
            bloodTypeCode()
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
                    "userUID": userUID as Any
                    ])
                    { err in
                    if let err = err {
                        print("Error writing document: \(err)")} else {print("Document successfully written!")}
                    }
            }
        }
        }
    
    @IBAction func goBackButtonTapped() {
        dismiss(animated: false, completion: nil)
    }
    
    func createToolBar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SignUpViewController.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.bloodTypeTextField.inputAccessoryView = toolBar
        self.userIdTextField.inputAccessoryView = toolBar
        self.emailTextField.inputAccessoryView = toolBar
        self.passwordTextField.inputAccessoryView = toolBar
        self.usernameTextField.inputAccessoryView = toolBar
        self.birthDateTextField.inputAccessoryView = toolBar
        self.genderTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func createBloodTypePicker(){
        bloodTypePicker.delegate = self
        self.bloodTypeTextField.inputView = bloodTypePicker
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
        if pickerView == genderTypePicker{
            selectedGender = genderTypes[row]
            self.genderTextField.text = selectedGender
        }
    }

    
    
}
