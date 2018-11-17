//
//  DonatorsCellDataModeling.swift
//  Amigo de Sangue
//
//  Created by Pedro Ripper on 19/10/2018.
//  Copyright © 2018 Pedro Ripper. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol Document {
    init?(dictionary:[String:Any])
}

struct DonatorCell {
    var name: String
    var bloodTypeCode: Int
 //   var gender: String
    var userId: String
    var wantToContribute: Bool
    var userUID: String
    var canDonateTo: [Int]
    
    var dictionary: [String:Any]{
       return [
        "name": name,
        "bloodTypeCode": bloodTypeCode,
      //  "gender": gender,
        "userId": userId,
        "wantToContribute": wantToContribute,
        "userUID": userUID,
        "canDonateTo": canDonateTo
            ]
    }
}
extension DonatorCell: Document {
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
            let bloodTypeCode = dictionary["bloodTypeCode"] as? Int,
        //    let gender = dictionary["gender"] as? String,
            let userId = dictionary["userId"] as? String,
            let wantToContribute = dictionary["wantToContribute"] as? Bool,
            let userUID = dictionary["userUID"] as? String ,
            let canDonateTo = dictionary["canDonateTo"] as? [Int] else {return nil}
        self.init(name: name, bloodTypeCode: bloodTypeCode, userId: userId, wantToContribute: wantToContribute, userUID: userUID, canDonateTo: canDonateTo)
    }
}

