//
//  CentersDataModeling.swift
//  Amigo de Sangue
//
//  Created by Pedro Ripper on 31/10/18.
//  Copyright © 2018 Pedro Ripper. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol CentersDocument {
    init?(centerDictionary:[String:Any])
}

struct center {
    var centerName: String
    var centerAdress: String
    var centerCEP: Int
    var centerNeighbourhood: String
    
    var centerDictionary: [String:Any]{
    return [
        "centerName": centerName,
        "centerAdress": centerAdress,
        "centerCEP": centerCEP,
        "centerNeighbourhood": centerNeighbourhood
    ]
    }
}


extension center : CentersDocument{
    init?(centerDictionary: [String : Any]) {
        guard let centerName = centerDictionary["centerName"] as? String,
        let centerAdress = centerDictionary["centerAdress"] as? String,
        let centerCEP = centerDictionary["centerDictionary"] as? Int,
        let centerNeighbourhood = centerDictionary["centerNeighbourhood"] as? String
            else {return nil}
        
        self.init(centerName: centerName, centerAdress: centerAdress, centerCEP: centerCEP, centerNeighbourhood: centerNeighbourhood)
        
    }
}

