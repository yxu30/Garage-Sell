//
//  MasterViewController.swift
//  Garage Sell
//
//  Created by Yuhong Xu on 5/18/20.
//  Copyright © 2020 Yuhong Xu. All rights reserved.
//

import UIKit
import Firebase

class ItemTableViewCell: UITableViewCell{
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
}


class HomeTableViewController: UITableViewController {
    var detailViewController: PostDetailViewController? = nil
    var posts = [Post]()
    var postsRef: CollectionReference!
    var postListener: ListenerRegistration!
    var isSellingPage = true
    
    var somethingWentWrong = UIImage(named: "SometingWentWrong.png")
    var noImage = UIImage(named: "noImageFound.jpeg")
    
    var vSpinner = [UIView?](repeating: nil, count: 100)
    
    @IBOutlet weak var homeSearchBar: UISearchBar!
    
    var sellingItemColors = UIColor.init(red: 30.0/255, green: 124.0/255, blue: 51.0/255, alpha: 0.28)
    var demandItemColors = UIColor.init(red: 124.0/255, green: 30.0/255, blue: 30.0/255, alpha: 0.28)
    var backgroundColor: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postsRef = Firestore.firestore().collection("Post")
        backgroundColor = sellingItemColors
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readAllData()
    }
    
    func showSpinner(onView : UIImageView, index : Int) {
        let spinnerView = UIView.init(frame: onView.bounds)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        vSpinner[index] = spinnerView
    }
    
    func removeSpinner(index : Int) {
        DispatchQueue.main.async {
            self.vSpinner[index]?.removeFromSuperview()
            self.vSpinner[index] = nil
        }
    }
    
    func showImage(_ itemImageView : UIImageView, _ url : String?, index : Int) {
        if var imgString = url {
            showSpinner(onView: itemImageView, index: index)
            if imgString == ""{
                imgString = "https://homestaymatch.com/images/no-image-available.png"
            }
          if let imgUrl = URL(string: imgString) {
            DispatchQueue.global().async { // Download in the background
              do {
                let data = try Data(contentsOf: imgUrl)
                DispatchQueue.main.async { // Then update on main thread
                    self.removeSpinner(index : index)
                    itemImageView.image = UIImage(data: data)
                }
              } catch {
                print("Error downloading image: \(error)")
              }
            }
          }
        }
    }

//
//    func downloadPhoto(_ imageRef : String) -> UIImage{
//        // Get a reference to the storage service using the default Firebase App
//        let storage = Storage.storage()
//        let urlReference = storage.reference(forURL: imageRef)
//
//        // Create a reference to the file you want to download
//        let islandRef = urlReference.child("images/\(imageRef)")
//
//        var image = UIImage()
//        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
//        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
//            if error != nil {
//            // Uh-oh, an error occurred!
//            image = self.somethingWentWrong!
//          } else {
//            // Data for "images/island.jpg" is returned
//            image = UIImage(data: data!)!
//          }
//        }
//        return image
//    }
//
    func readAllData(){
        postListener = postsRef.order(by: "modifiedAt", descending: true).limit(to: 50).addSnapshotListener{
            (querySnapshot, error) in
            if let querySnapshot = querySnapshot{
                self.posts.removeAll()
                querySnapshot.documents.forEach{ (documentSnapshot) in
                    print(documentSnapshot.data())
                    let p = Post(documentSnapshot: documentSnapshot)
                    if self.isSellingPage == p.isSell{
                       self.posts.append(p)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
    @IBAction func segementSwiped(_ sender: Any) {
        isSellingPage = !isSellingPage
        if isSellingPage{
            backgroundColor = sellingItemColors
        }else{
            backgroundColor = demandItemColors
        }
        readAllData()
    }
    
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.itemDetailIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
                (segue.destination as! PostDetailViewController).post = posts[indexPath.row]
            }
        }
    }
    

    // MARK: - Table View

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.itemCellIdentifier , for: indexPath) as! ItemTableViewCell
        let post = posts[indexPath.row] as Post
        cell.itemTitle.text = post.title
        // if no image attached with post
        cell.itemDescription.text = post.description
        
//        if post.imageURI == ""{
//            cell.itemImage.image = noImage
//        }else{
//            cell.itemImage.image = downloadPhoto(post.imageURI)
//        }
        
        showImage(cell.itemImage, posts[indexPath.row].imageURI, index : indexPath.row)
        
        
        cell.itemPrice.text = Utility.formatPrice(posts[indexPath.row].price)
        cell.backgroundColor = backgroundColor
        
        cell.layer.cornerRadius = 16
        cell.layer.borderWidth = 5.0
        cell.layer.borderColor = UIColor.white.cgColor

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return posts[indexPath.row].isSell == isSellingPage
    }
}

