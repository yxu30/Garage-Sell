//
//  continuePostUploadViewController.swift
//  Garage Sell
//
//  Created by Yuhong Xu on 5/24/20.
//  Copyright © 2020 Yuhong Xu. All rights reserved.
//

import UIKit

class ContinuePostUploadViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var itemPriceTextField: UITextField!
    @IBOutlet weak var sellOrDemandSelector: UISegmentedControl!
    @IBOutlet weak var uploadPostButton: UIBarButtonItem!
    
    var firstPageItem : [String : Any]!
    var itemTitle: String!
    var itemDescription: String! = ""
    var image : UIImage?
    
    var price : Int = 0
    
    
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
    }
    
    @objc fileprivate func uploadPhoto(){
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        // create new post
        
        // add post reference to this user
        
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
