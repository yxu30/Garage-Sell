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
    
    var post: Post!
//    var postRef : DocumentReference!
    var postListener : ListenerRegistration!
    var uiImage : UIImage!
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var favoriateIconButton: UIButton!
    
    @IBOutlet weak var itemDescription: UITextView!
    
    var saved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        print("uri? \(post?.imageURI)")
    }
    @IBAction func favoriateOnPressed(_ sender: Any) {
        saved = !saved
        if saved{
            favoriateIconButton.tintColor = UIColor(red: 250/255, green: 0, blue: 0, alpha: 0.8)
            // update and async view
        }else{
            favoriateIconButton.tintColor = .opaqueSeparator
        }
    }
    
    func updateView() {
        setUsername()
        itemTitle.text = post?.title
        itemPrice.text = Utility.formatPrice(post!.price)
        itemDescription.text = post?.description
    }
    
    func setUsername(){
        let uid = post.owner
        let userRef = Firestore.firestore().collection(Constants.usersCollectionName).document(uid)
        userRef.addSnapshotListener { (documentSnapshot, error) in
            if let documentSnapshot = documentSnapshot{
                let data = documentSnapshot.data()
                self.username.text = (data!["name"] as! String)
            }else{
                print("Error giving user document \(error!)")
            }
        }
    }
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        if var imgString = post?.imageURI {
            
            showSpinner(onView: itemImageView)
            if imgString == ""{
                imgString = "https://homestaymatch.com/images/no-image-available.png"
            }
          if let imgUrl = URL(string: imgString) {
            DispatchQueue.global().async { // Download in the background
              do {
                let data = try Data(contentsOf: imgUrl)
                DispatchQueue.main.async { // Then update on main thread
                    self.removeSpinner()
                    self.itemImageView.image = UIImage(data: data)
                }
              } catch {
                print("Error downloading image: \(error)")
              }
            }
          }
        }
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        let uri = post?.imageURI
//        if uri == ""{
//            itemImageView.image = UIImage(named: Constants.noImage)
//            return
//        }
//
//        DispatchQueue.global().async { // Download in the background
//            if uri == ""{
//                DispatchQueue.main.async {
//                    self.removeSpinner()
//                    self.itemImageView.image = UIImage(named: Constants.noImage)
//                    return
//                }
//            }else{
//                // Get a reference to the storage service using the default Firebase App
//                let storage = Storage.storage()
//                let gsReference = storage.reference(forURL: self.post!.imageURI)
//                // Create a reference to the file you want to download
//                let islandRef = gsReference.child("images/\(self.post!.imageURI)")
//                // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
//                islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
//                    DispatchQueue.main.async {
//                        self.removeSpinner()
//                        if error != nil {
//                        // Uh-oh, an error occurred!
//                            self.itemImageView.image = UIImage(named: Constants.somethingWentWrong)
//                        } else {
//                            self.itemImageView.image = UIImage(data: data!)!
//                        }
//                    }
//                }
//
//          }
//        }
//    }

}

