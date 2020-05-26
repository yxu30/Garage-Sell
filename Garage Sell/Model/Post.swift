//
//  Posts.swift
//  Garage Sell
//
//  Created by Yuhong Xu on 5/21/20.
//  Copyright © 2020 Yuhong Xu. All rights reserved.
//

import UIKit
import Firebase


class Post{
    var id: String
    var description: String
    var imageURI: String
    var isSell: Bool
    var owner: String
    var price: Double
    var sold: Bool
    var title: String
    var createdAt: Timestamp
    var modifiedAt: Timestamp
    
    var imageView: UIImage?
    
    init(documentSnapshot: DocumentSnapshot){
        self.id = documentSnapshot.documentID
        let data = documentSnapshot.data()
        description = data!["description"] as! String
        imageURI = data!["imageURI"] as! String
        isSell = data!["isSell"] as! Bool
        owner = data!["owner"] as! String
        price = data!["price"] as! Double
        sold = data!["sold"] as! Bool
        title = data!["title"] as! String
        createdAt = data!["createdAt"] as! Timestamp
        modifiedAt = data!["modifiedAt"] as! Timestamp
    }
    
    func setImageView(_ imageView : UIImage){
        self.imageView = imageView
    }
    
}
