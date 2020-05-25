//
//  PostUploadViewController.swift
//  Garage Sell
//
//  Created by Yuhong Xu on 5/24/20.
//  Copyright © 2020 Yuhong Xu. All rights reserved.
//

import UIKit

class PostUploadViewController: UIViewController {

    @IBOutlet weak var scrollableImageView: UIView!
    @IBOutlet weak var itemTitle: UITextField!
    @IBOutlet weak var itemDescription: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    var didUserSelectedImages = false
    var images = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if didUserSelectedImages{
            // display button
        }else{
            // display scrollable imageView
        }
        
        UIUtility.floatButton(continueButton)
    }
    
    @IBAction func continuePressed(_ sender: Any) {
        // check if title is empty
        if itemTitle.text == ""{
            let alertController = UIAlertController(title: "Title cannot be empty ", message: "Please type the title.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        if itemDescription.text == ""{
            itemDescription.text = "This item doesn't have any description"
        }
        
        // if image == null
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.itemUploadContinueIdentifier{
            (segue.destination as! ContinuePostUploadViewController).firstPageItem = ["title" : itemTitle.text! as String,
                                                                                      "description" : itemDescription.text! as String,
                "images": images]
        }
    }
    
    

}
