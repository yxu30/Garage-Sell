//
//  Posts.swift
//  Garage Sell
//
//  Created by Yuhong Xu on 5/21/20.
//  Copyright © 2020 Yuhong Xu. All rights reserved.
//

import Foundation
import Firebase


class Post{
    var id: String
//    var category: Constants.Category
    var description: String
//    var images: [String]()
    var isSell: Bool
    var owner: DocumentReference
    var price: Double
    var sold: Bool
    var title: String
    var createdAt: Timestamp
    var modifiedAt: Timestamp
    
    
    init(documentSnapshot: DocumentSnapshot){
        self.id = documentSnapshot.documentID
        let data = documentSnapshot.data()
//        category = Constants.Category(rawValue: data!["category"] as! String)!
        description = data!["description"] as! String
        
//        images =
        isSell = data!["isSell"] as! Bool
        owner = data!["owner"] as! DocumentReference
        price = data!["price"] as! Double
        sold = data!["sold"] as! Bool
        title = data!["title"] as! String
        createdAt = data!["createdAt"] as! Timestamp
        modifiedAt = data!["modifiedAt"] as! Timestamp
    }
    
}
