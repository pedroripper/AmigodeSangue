//
//  ChatViewController.swift
//  Amigo de Sangue
//
//  Created by Pedro Ripper on 26/10/18.
//  Copyright © 2018 Pedro Ripper. All rights reserved.
//

import UIKit
import MessageKit
import FirebaseAuth
import FirebaseFirestore
import Firebase

struct User {
    let userUID: String
    let userName: String
}

public protocol MessageType {
    
    var sender: Sender { get }
    
    var messageId: String { get }
    
    var sentDate: Date { get }
    
    var kind: MessageKind { get }
}

public struct Sender {
    
    public let id: String
    
    public let displayName: String
}

class ChatViewController: MessagesViewController {
    
    private let db = Firestore.firestore()
    
    var getUser1UID = String()
    var getUser2UID = String()
    var getUser1Name = String()
    var getUser2Name = String()
    
    var messages = [Message]
    
    override func viewDidLoad() {
        
    }
    func loadUsers(){
        let user1 = User(userUID: getUser1UID, userName: getUser1Name)
        let user2 = User(userUID: getUser2UID, userName: getUser2Name)
    }
  

    
    
}


