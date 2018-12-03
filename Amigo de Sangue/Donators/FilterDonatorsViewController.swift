//
//  FilterDonatorsViewController.swift
//  Amigo de Sangue
//
//  Created by Pedro Ripper on 30/11/18.
//  Copyright © 2018 Pedro Ripper. All rights reserved.
//

import UIKit

class FilterDonatorsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var popOver: UIView!
    @IBOutlet var bloodTypeFilterPickerTextField: UITextField!
    
    
    
    let bloodTypePicker = UIPickerView()
    let bloodTypes = ["Selecionar","A+","A-","B+","B-","AB+","AB-","O+","O-"]
    var selectedBloodType: String?
    var bloodTypecd: Int?

    var donatorsVC = DonatorViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "Filtrar"
        configureTextFields()
        createPicker()
        bloodTypecd = donatorsVC.userBloodcd
    }
    
    func configureTextFields(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Pronto", style: .plain, target: self, action: #selector(SignUpViewController.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.bloodTypeFilterPickerTextField.inputAccessoryView = toolBar
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func createPicker(){
        bloodTypePicker.delegate = self
        self.bloodTypeFilterPickerTextField.inputView = bloodTypePicker
    }
    
    @IBAction func filterButtonTapped() {
        bloodTypeCode()
        let StoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let DestinatedVC = StoryBoard.instantiateViewController(withIdentifier: "FilteredDonatorsViewController") as! FilteredDonatorsViewController
        DestinatedVC.getFilterBloodcd = bloodTypecd ?? 31
        self.navigationController?.pushViewController(DestinatedVC, animated: false)
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
        selectedBloodType = bloodTypes[row]
        self.bloodTypeFilterPickerTextField.text = selectedBloodType
    }


}
