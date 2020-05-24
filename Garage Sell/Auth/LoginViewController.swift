//
//  LoginViewController.swift
//  Garage Sell
//
//  Created by Yuhong Xu on 5/23/20.
//  Copyright © 2020 Yuhong Xu. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func setupStyle(){
        UIUtility.floatButton(loginButton)
        UIUtility.floatButton(signUpButton)
    }
    
    @IBAction func LoginButtonTapped(_ sender: Any) {
        let cleanedEmail = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedPassword = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        Auth.auth().signIn(withEmail: cleanedEmail!, password: cleanedPassword!) { (result, error) in
            if error != nil{
                self.errorMessageLabel.text = error?.localizedDescription
            }else{
                self.loadHomePage()
            }
            
            
        }
    
    }
    
    func loadHomePage(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabController = storyBoard.instantiateViewController(withIdentifier: Constants.homeTabBarControllerIdentifier) as! UITabBarController
        view.window?.rootViewController = tabController
    }

}
