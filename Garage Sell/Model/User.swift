//
//  User.swift
//  Garage Sell
//
//  Created by Yuhong Xu on 5/21/20.
//  Copyright © 2020 Yuhong Xu. All rights reserved.
//

import Foundation
import Firebase

class User{
    var id: String
    var PIDs = [DocumentReference]()
    var contactInfo : [String: Any]
    var name: String
    var zipcode: String
    
    init(documentSnapshot: DocumentSnapshot){
        self.id = documentSnapshot.documentID
        let data = documentSnapshot.data()
        self.PIDs = data!["PIDs"] as! [DocumentReference]
        self.contactInfo = (data!["contactInfo"] as? [String: Any])!
        self.name = data!["name"] as! String
        self.zipcode = data!["zipcode"] as! String
    }
}
