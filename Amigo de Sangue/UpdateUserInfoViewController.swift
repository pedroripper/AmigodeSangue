//
//  UpdateUserInfoViewController.swift
//  Amigo de Sangue
//
//  Created by Pedro Ripper on 15/10/2018.
//  Copyright © 2018 Pedro Ripper. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import FirebaseAuth
import JGProgressHUD

class UpdateUserInfoViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var locationInput: UITextField!
    @IBOutlet var canDonateSwitch: UISwitch!
    @IBOutlet var birthDateInput: UITextField!
    @IBOutlet var genderInput: UITextField!
    @IBOutlet var updateStatusLabel: UILabel!
    
    
    var db: Firestore!
    
    let genderTypePicker = UIPickerView()
    let genderTypes = ["Selecionar","Homem","Mulher","Outro"]
    var selectedGender: String?
    let birthDayPicker = UIDatePicker()
    var selectedDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createToolBar()
        createGenderPicker()
        createBirthDayPicker()
        db = Firestore.firestore()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
    }
  
    @IBAction func upDateInfo() {
        saveUserInfo()
    }
    
    @IBAction func cancelButtonTapped() {
        dismiss(animated: false, completion: nil)
    }
    
    func saveUserInfo(){
        print("Started Updating")
        let user =  Auth.auth().currentUser
        if user != nil {
            print("Started Updating")
            let userUID = (user?.uid)!
            //guard let birthdateText = self.datePickTextField.text, !birthdateText.isEmpty else{return}
            guard let genderText = self.genderInput.text, !genderText.isEmpty else{return}
            db.collection("users").document(userUID).setData([
                "gender": selectedGender!,
                //  "birthdate": selectedDate!,
                ], merge: true)
            { err in
                if let err = err {
                    print("Error writing document: \(err)")} else {print("Done updating")
                    self.updateStatusLabel.text = "Atualizado!"}
            }
        }
    }
    
    
    func createToolBar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SignUpViewController.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.genderInput.inputAccessoryView = toolBar
        self.birthDateInput.inputAccessoryView = toolBar
        self.locationInput.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func createGenderPicker(){
        genderTypePicker.delegate = self
        self.genderInput.inputView = genderTypePicker
        
    }
    
    func createBirthDayPicker(){
        self.birthDateInput.inputView = birthDayPicker
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        // Apply date format
        selectedDate = dateFormatter.string(from: sender.date)
        self.birthDateInput.text = selectedDate
    }
    
    //UIPICKERVIEW
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderTypes.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderTypes[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genderTypePicker{
        selectedGender = genderTypes[row]
        self.genderInput.text = selectedGender
        }
        }
    


}
