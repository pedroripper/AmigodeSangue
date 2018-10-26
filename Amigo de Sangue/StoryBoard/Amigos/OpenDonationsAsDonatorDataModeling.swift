//
//  File.swift
//  Amigo de Sangue
//
//  Created by Pedro Ripper on 25/10/18.
//  Copyright © 2018 Pedro Ripper. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol OpenDonationsDonatorDocument {
    init?(openDonationsDonatorDictionary:[String:Any])
}

struct OpenDonatorCell {
    var donatorBloodTypeCode: Int
    var donatorName: String
    var donatorUID: String
    var receiverBloodTypeCode: Int
    var receiverName: String
    var receiverUID: String
    var isDone: Bool
    
    var openDonationsDonatorDictionary: [String:Any]{
        return [
            "donatorBloodTypeCode": donatorBloodTypeCode,
            "donatorName": donatorName,
            "donatorUID": donatorUID,
            "receiverBloodTypeCode": receiverBloodTypeCode,
            "receiverName": receiverName,
            "receiverUID": receiverUID,
            "isDone": isDone
        ]
    }
}
extension OpenDonatorCell: OpenDonationsDonatorDocument {
    init?(openDonationsDonatorDictionary: [String : Any]) {
        guard let donatorBloodTypeCode = openDonationsDonatorDictionary["donatorBloodTypeCode"] as? Int,
            let donatorName = openDonationsDonatorDictionary["donatorName"] as? String,
            let donatorUID = openDonationsDonatorDictionary["donatorUID"] as? String,
            let receiverBloodTypeCode = openDonationsDonatorDictionary["receiverBloodTypeCode"] as? Int,
            let receiverName = openDonationsDonatorDictionary["receiverName"] as? String,
            let receiverUID = openDonationsDonatorDictionary["receiverUID"] as? String ,
            let isDone = openDonationsDonatorDictionary["isDone"] as? Bool else {return nil}
       self.init(donatorBloodTypeCode: donatorBloodTypeCode, donatorName: donatorName, donatorUID: donatorUID, receiverBloodTypeCode: receiverBloodTypeCode, receiverName: receiverName, receiverUID: receiverUID, isDone: isDone)
    }
}
