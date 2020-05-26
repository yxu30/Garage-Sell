//
//  continuePostUploadViewController.swift
//  Garage Sell
//
//  Created by Yuhong Xu on 5/24/20.
//  Copyright © 2020 Yuhong Xu. All rights reserved.
//

import UIKit
import Firebase

class ContinuePostUploadViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var itemPriceTextField: UITextField!
    @IBOutlet weak var sellOrDemandSelector: UISegmentedControl!
    
    var firstPageItem : [String : Any]!
    var itemTitle: String!
    var itemDescription: String! = ""
    var image : UIImage?
    var price : Int = 0
    var isSell = true
    
    
    var postRef : DocumentReference!
    var postsRef : CollectionReference!
    
    func uploadImageAndReturnURI() -> String{
        if image == nil{
            return ""
        }
        guard let image = image, let data = image.jpegData(compressionQuality: 1.0)
            else{
                return ""
        }
        let imageName = UUID().uuidString
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child(imageName)
        var imageURL = ""
        imageRef.putData(data, metadata: nil){
            (metadata, err) in
            if let err = err{
                print("STH went WRONG WHILE UPLOAD IMAGE \(err)")
            }
            imageRef.downloadURL {(url, error) in
                if let url = url {
                    print("url \(url)")
                    imageURL = "\(url)"
                    
                    self.postRef.updateData(["imageURI" : imageURL])
                }
            }
        }
        return imageURL
    }

    
    
    @IBAction func segmentSwiped(_ sender: Any) {
        isSell = !isSell
    }
    
    
    func uploadPost(){
        // upload post
        postRef = postsRef.addDocument(data: [
            "createdAt" :Timestamp.init(),
            "description" : itemDescription,
            "imageURI" : uploadImageAndReturnURI(),
            "isSell" : isSell,
            "modifiedAt":Timestamp.init(),
            "owner" : Auth.auth().currentUser!.uid,
            "price" : Double(price/100) + Double(price%100)/100,
            "sold" : false,
            "title" : itemTitle
            ])
        
        DispatchQueue.main.async {
            self.loadHomePage()
        }
        
    }
    
        func loadHomePage(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabController = storyBoard.instantiateViewController(withIdentifier: Constants.homeTabBarControllerIdentifier) as! UITabBarController
        view.window?.rootViewController = tabController
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        uploadPost()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemPriceTextField.delegate = self
        itemPriceTextField.placeholder = valueFormatter()
        itemTitle = (firstPageItem["title"] as! String)
        
        let descrip = firstPageItem["description"] as! String
        if descrip == ""{
            itemDescription = "This item doesn't have any description"
        }else{
            itemDescription = descrip
        }
        image = firstPageItem["image"] as? UIImage
        postsRef = Firestore.firestore().collection("Post")
    }

    
    // price formatter get from the Youtube vedio "Currency format input to UITextField in Swift"
    // https://www.youtube.com/watch?v=YBBNPH6JYxY
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let digit = Int(string){
            price = price * 10 + digit
            itemPriceTextField.text = valueFormatter()
        }
        if string == ""{
            price = price / 10
            itemPriceTextField.text = valueFormatter()
        }
        return false
    }
    
    func valueFormatter() -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        let displayPrice = Double(price/100) + Double(price % 100)/100
        return formatter.string(from: NSNumber(value: displayPrice))!
    }
    
    // How to Hide the keyboard In xCode
    // https://www.youtube.com/watch?v=l-Uup2lKw1Y
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        itemPriceTextField.resignFirstResponder()
        return (true)
    }
    
    
}
