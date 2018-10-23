//
//  AmigosViewController.swift
//  Amigo de Sangue
//
//  Created by Pedro Ripper on 16/09/2018.
//  Copyright © 2018 Pedro Ripper. All rights reserved.
//

import UIKit
import FirebaseAuth
class AmigosViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavController()
        
    }
    func setUpNavController(){
        let logOutButtonImage = UIImageView(image:UIImage(named: "logout"))
        let logOutButton = UIButton(type: .system)
        logOutButton.setImage(logOutButtonImage.image, for: .normal)
        logOutButtonImage.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logOutButton)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(AmigosViewController.lougoutButtonTapped))
        logOutButton.isUserInteractionEnabled = true
        logOutButton.addGestureRecognizer(recognizer)
        
    }
    @objc private func lougoutButtonTapped(){
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
}

