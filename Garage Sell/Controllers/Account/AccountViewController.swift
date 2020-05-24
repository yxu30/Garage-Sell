//
//  AccountViewController.swift
//  Garage Sell
//
//  Created by Yuhong Xu on 5/24/20.
//  Copyright © 2020 Yuhong Xu. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        do{
            try! Auth.auth().signOut()
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let loginController = storyBoard.instantiateViewController(withIdentifier: Constants.loginViewControllerIdentifier) as! LoginViewController
                    view.window?.rootViewController = loginController
        } catch let error{
            print("logout error \(error)")
        }
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
