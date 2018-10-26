//
//  File.swift
//  Amigo de Sangue
//
//  Created by Pedro Ripper on 25/10/18.
//  Copyright © 2018 Pedro Ripper. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol RequestDocument {
    init?(requestDictionary:[String:Any])
}

struct RequestCell {
    var donatorBloodTypeCode: Int
    var donatorName: String
    var donatorUID: String
    var receiverBloodTypeCode: Int
    var receiverName: String
    var receiverUID: String
    
    var requestDictionary: [String:Any]{
        return [
            "donatorBloodTypeCode": donatorBloodTypeCode,
            "donatorName": donatorName,
            "donatorUID": donatorUID,
            "receiverBloodTypeCode": receiverBloodTypeCode,
            "receiverName": receiverName,
            "receiverUID": receiverUID
        ]
    }
}
extension RequestCell: RequestDocument {
    init?(requestDictionary: [String : Any]) {
        guard let donatorBloodTypeCode = requestDictionary["donatorBloodTypeCode"] as? Int,
            let donatorName = requestDictionary["donatorName"] as? String,
            let donatorUID = requestDictionary["donatorUID"] as? String,
            let receiverBloodTypeCode = requestDictionary["receiverBloodTypeCode"] as? Int,
            let receiverName = requestDictionary["receiverName"] as? String,
            let receiverUID = requestDictionary["receiverUID"] as? String else {return nil}
       self.init(donatorBloodTypeCode: donatorBloodTypeCode, donatorName: donatorName, donatorUID: donatorUID, receiverBloodTypeCode: receiverBloodTypeCode, receiverName: receiverName, receiverUID: receiverUID)
    }
}
