//
//  ViewController.swift
//  Amigo de Sangue
//
//  Created by Pedro Ripper on 13/09/2018.
//  Copyright © 2018 Pedro Ripper. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LogInViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createToolBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    @IBAction func signInButtonTapped() {
        if emailTextField.text != "" && passwordTextField.text != ""{
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if user != nil {
                   // UserDefaults.standard.set(true, forKey: "LogIn")
                   // UserDefaults.standard.synchronize()
                    self.performSegue(withIdentifier: "logInSegue", sender: self)
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    
                }
                else{
                    self.warningLabel.text = "Usuário não existe ou LogIn incorreto."
                }
            }
        }
    }
    func createToolBar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(LogInViewController.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.emailTextField.inputAccessoryView = toolBar
        self.passwordTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
 
    
    
}

