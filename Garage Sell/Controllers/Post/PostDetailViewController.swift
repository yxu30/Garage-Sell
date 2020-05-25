//
//  DetailViewController.swift
//  Garage Sell
//
//  Created by Yuhong Xu on 5/18/20.
//  Copyright © 2020 Yuhong Xu. All rights reserved.
//

import UIKit
import Firebase


class PostDetailViewController: UIViewController {
    
    var post: Post?
    var postRef : DocumentReference!
    var postListener : ListenerRegistration!
    var noImage = UIImage(named: "noImageFound.jpeg")
    
    @IBOutlet weak var username: UIButton!
    @IBOutlet var itemImages: [UIImageView]!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemTitle: UILabel!
    
    @IBOutlet weak var itemDescription: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    func updateView() {
        // user
        // images
        itemTitle.text = post?.title
        itemPrice.text = Utility.formatPrice(post!.price)
        itemDescription.text = post?.description
    }
    
    @objc fileprivate func downloadPhoto(){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        postListener = postRef.addSnapshotListener({(documentSnapshot, error) in
            if let error = error{
                print ("Error getting photoRef \(error)")
                return
            }else if !documentSnapshot!.exists{
                return
            }
            self.post = Post(documentSnapshot: documentSnapshot!)
            // if it is my post, then show the edit on the nav bar
            
//            if DataFile.getEmail() == self.photo?.email {
//                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.showEditDialog))
//                    }
            self.updateView()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if var imgString = photo?.url {
//            showSpinner(onView: imageView)
//            if imgString == ""{
//                imgString = noImage
//            }
//          if let imgUrl = URL(string: imgString) {
//            DispatchQueue.global().async { // Download in the background
//              do {
//                let data = try Data(contentsOf: imgUrl)
//                DispatchQueue.main.async { // Then update on main thread
//                    self.removeSpinner()
//                    self.imageView.image = UIImage(data: data)
//                }
//              } catch {
//                print("Error downloading image: \(error)")
//              }
//            }
//          }
//        }
    }
    
    


    // code of showSpinner and removeSpinner come from the web page
    // http://brainwashinc.com/2017/07/21/loading-activity-indicator-ios-swift/
    
    var vSpinner : UIView?
    
    func showSpinner(onView : UIImageView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
}

