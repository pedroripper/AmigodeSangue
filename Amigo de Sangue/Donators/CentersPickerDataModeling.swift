//
//  CentersPickerDataModeling.swift
//  Amigo de Sangue
//
//  Created by Pedro Ripper on 10/12/18.
//  Copyright © 2018 Pedro Ripper. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth



protocol CenterDocument {
    init?(centerDictionary:[String:Any])
}

struct CenterPickerOption {
    var centerName: String
    var latitude: String
    var longitude: String
    
    var centerDictionary: [String:Any]{
        return [
            "centerName": centerName,
            "latitude": latitude,
            "longitude": longitude
        ]
    }
}
extension CenterPickerOption: Document {
    init?(dictionary centerDictionary: [String : Any]) {
        guard let centerName = centerDictionary["centerName"] as? String,
            let latitude = centerDictionary["latitude"] as? String,
            let longitude = centerDictionary["longitude"] as? String else {return nil}
            self.init(centerName: centerName, latitude: latitude, longitude: longitude)    
    }
}

