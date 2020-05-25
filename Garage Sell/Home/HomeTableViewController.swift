//
//  MasterViewController.swift
//  Garage Sell
//
//  Created by Yuhong Xu on 5/18/20.
//  Copyright © 2020 Yuhong Xu. All rights reserved.
//

import UIKit
import Firebase

class ItemTableVeiwCell: UITableViewCell{
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
//    var categoryController :categoryController!
    
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
                (segue.destination as! PostDetailViewController).postRef = postsRef.document(posts[indexPath.row].id)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.itemCellIdentifier , for: indexPath) as! ItemTableVeiwCell
        let post = posts[indexPath.row] as Post
        cell.itemTitle.text = post.title
        // if no image attached with post
        cell.itemDescription.text = post.description
        cell.itemImage.image = UIImage(named: "noImageFound.jpeg")
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

