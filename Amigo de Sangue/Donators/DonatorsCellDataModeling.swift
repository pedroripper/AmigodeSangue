//
//  DonatorsCellDataModeling.swift
//  Amigo de Sangue
//
//  Created by Pedro Ripper on 19/10/2018.
//  Copyright © 2018 Pedro Ripper. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth



protocol Document {
    init?(dictionary:[String:Any])
}

struct DonatorCell {
    var name: String
    var bloodTypeCode: Int
    var userId: String
    var wantToContribute: Bool
    var userUID: String
    var canDonateTo: [Int]
    var nextDonation: Date
    
    var dictionary: [String:Any]{
       return [
        "name": name,
        "bloodTypeCode": bloodTypeCode,
        "userId": userId,
        "wantToContribute": wantToContribute,
        "userUID": userUID,
        "canDonateTo": canDonateTo,
        "nextDonation": nextDonation
            ]
    }
}
extension DonatorCell: Document {
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
            let bloodTypeCode = dictionary["bloodTypeCode"] as? Int,
            let userId = dictionary["userId"] as? String,
            let wantToContribute = dictionary["wantToContribute"] as? Bool,
            let userUID = dictionary["userUID"] as? String ,
            let canDonateTo = dictionary["canDonateTo"] as? [Int],
            let nextDonation = dictionary["nextDonation"] as? Date else {return nil}
        let userCDUI: String = Auth.auth().currentUser!.uid as String
        if userCDUI != userUID {
        self.init(name: name, bloodTypeCode: bloodTypeCode, userId: userId, wantToContribute: wantToContribute, userUID: userUID, canDonateTo: canDonateTo, nextDonation: nextDonation)
        }
        else {
            return nil
        }
    
    }
}




