//
//  OpenDonationsAsReceiversDataModeling.swift
//  Amigo de Sangue
//
//  Created by Pedro Ripper on 25/10/18.
//  Copyright © 2018 Pedro Ripper. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol OpenDonationsReceiverDocument {
    init?(openDonationsReceiverDictionary:[String:Any])
}

struct OpenReceiverCell {
    var donatorBloodTypeCode: Int
    var donatorName: String
    var donatorUID: String
    var receiverBloodTypeCode: Int
    var receiverName: String
    var receiverUID: String
    var isDone: Bool
    var isCancelled: Bool
    
    var openDonationsReceiverDictionary: [String:Any]{
        return [
            "donatorBloodTypeCode": donatorBloodTypeCode,
            "donatorName": donatorName,
            "donatorUID": donatorUID,
            "receiverBloodTypeCode": receiverBloodTypeCode,
            "receiverName": receiverName,
            "receiverUID": receiverUID,
            "isDone": isDone,
            "isCancelled": isCancelled
        ]
    }
}
extension OpenReceiverCell: OpenDonationsReceiverDocument {
    init?(openDonationsReceiverDictionary: [String : Any]) {
        guard let donatorBloodTypeCode = openDonationsReceiverDictionary["donatorBloodTypeCode"] as? Int,
            let donatorName = openDonationsReceiverDictionary["donatorName"] as? String,
            let donatorUID = openDonationsReceiverDictionary["donatorUID"] as? String,
            let receiverBloodTypeCode = openDonationsReceiverDictionary["receiverBloodTypeCode"] as? Int,
            let receiverName = openDonationsReceiverDictionary["receiverName"] as? String,
            let receiverUID = openDonationsReceiverDictionary["receiverUID"] as? String ,
            let isDone = openDonationsReceiverDictionary["isDone"] as? Bool,
            let isCancelled = openDonationsReceiverDictionary["isCancelled"] as? Bool else {return nil}
        self.init(donatorBloodTypeCode: donatorBloodTypeCode, donatorName: donatorName, donatorUID: donatorUID, receiverBloodTypeCode: receiverBloodTypeCode, receiverName: receiverName, receiverUID: receiverUID, isDone: isDone, isCancelled: isCancelled)
    }
}

