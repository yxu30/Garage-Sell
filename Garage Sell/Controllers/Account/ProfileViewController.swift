//
//  ProfileViewController.swift
//  Garage Sell
//
//  Created by Yuhong Xu on 5/24/20.
//  Copyright © 2020 Yuhong Xu. All rights reserved.
//

import UIKit
import Firebase


class ProfileViewController: UIViewController {
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var contactEmail: UILabel!
    
    var userRef: DocumentReference!
    var uid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = Auth.auth().currentUser!.uid as String
        let fs = Firestore.firestore()
        userRef = fs.collection(Constants.usersCollectionName).document(uid)
        print(userRef.documentID)
        getAccountEmail()
        updateView()
    }

    func getAccountEmail(){
        email.text = Auth.auth().currentUser?.email
    }
    
    func updateView(){
        retriveCorrectUsername()
        retriveCorrectContactEmailField()
    }
    
    @IBAction func editUsernameTapped(_ sender: Any) {
        showDialog("Change Username?", "Do you want to change username?", "username", updateUsername)
    }
    
    func updateUsername(_ username : String){
        userRef.updateData(["name": username])
    }
    
    func retriveCorrectUsername(){
        userRef.addSnapshotListener { (documentSnapshot, error) in
            if let documentSnapshot = documentSnapshot{
                let data = documentSnapshot.data()
                self.username.text = (data!["name"] as! String)
            }else{
                print("Error giving user document \(error!)")
            }
        }
    }
    

    @IBAction func editContactEmailTapped(_ sender: Any) {
        // show edit dialog
        showDialog("Change contact email?", "", "new email", updateContactEmail)
    }
    
    
    func updateContactEmail(_ newEmail: String){
        userRef.updateData(["contactEmail": newEmail])
    }
    
    func retriveCorrectContactEmailField(){
        userRef.addSnapshotListener { (documentSnapshot, error) in
            if let documentSnapshot = documentSnapshot{
                let data = documentSnapshot.data()
                print(data)
                self.contactEmail.text = (data!["contactEmail"] as! String)
            }else{
                print("Error giving user document \(error!)")
            }
        }
    }
    
    func showDialog(_ title: String, _ message: String, _ textFieldPlaceholder: String, _ tempFunc: @escaping (String)->Void){
        let alertController = UIAlertController(title: title,
        message: message,
        preferredStyle: .alert)
        
        alertController.addTextField{(textField) in textField.placeholder = textFieldPlaceholder
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default) { (UIAlertAction) in
            let textField = alertController.textFields![0] as UITextField
            tempFunc(textField.text!)
        }
        
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
