//
//  continuePostUploadViewController.swift
//  Garage Sell
//
//  Created by Yuhong Xu on 5/24/20.
//  Copyright © 2020 Yuhong Xu. All rights reserved.
//

import UIKit

class ContinuePostUploadViewController: UIViewController {

    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var sellOrDemandSelector: UISegmentedControl!
    @IBOutlet weak var uploadPost: UIBarButtonItem!
    
    var firstPageItem : [String : Any]!
    var itemTitle: String!
    var itemDescription: String! = ""
    var images = [UIImageView]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemTitle = firstPageItem["title"] as! String
        itemDescription = firstPageItem["description"] as! String
        images = firstPageItem["images"] as! [UIImageView]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
