
    //
    //  SignupViewController.swift
    //  Garage Sell
    //
    //  Created by Yuhong Xu on 5/23/20.
    //  Copyright © 2020 Yuhong Xu. All rights reserved.
    //

    import UIKit
    import Firebase


    class SignupViewController: UIViewController {


        @IBOutlet weak var emailTextfield: UITextField!
        @IBOutlet weak var passwordTextfield: UITextField!
        @IBOutlet weak var passwordReEnterTextfield: UITextField!
        @IBOutlet weak var usernameTextfield: UITextField!
        
        @IBOutlet weak var errorMassageLabel: UILabel!
        
        @IBOutlet weak var signupButton: UIButton!
        
        @IBAction func SignupTapped(_ sender: Any) {
          // validatefield
            let cleanedEmail = emailTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanedUsername = usernameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanedPassword = passwordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanedReEnteredPassword = passwordReEnterTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let error = validateFields(cleanedEmail, cleanedPassword, cleanedReEnteredPassword, cleanedUsername)
            
            if error != nil{
                showErrorMassage(error!)
            }else{
                Auth.auth().createUser(withEmail: cleanedEmail!, password: cleanedPassword!){
                    (result, err) in
                    if err != nil{
                        print(err)
                        self.showErrorMassage("error creating user")
                    }else{
                        let db = Firestore.firestore()
                        let uid = Auth.auth().currentUser?.uid
                        db.collection(Constants.usersCollectionName).document(uid!).setData([
                            "PIDs" : [],
                            "contactEmail" : cleanedEmail! as String,
                            "contactPhone" : "",
                            "name" : cleanedUsername! as String
                        ]){(error) in
                            if error != nil{
                                self.showErrorMassage("Something wrong here")
                            }
                        }
                        
                        self.loadHomePage()
            
                    }
                }
            }
        }
        
        func loadHomePage(){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tabController = storyBoard.instantiateViewController(withIdentifier: Constants.homeTabBarControllerIdentifier) as! UITabBarController
            view.window?.rootViewController = tabController
        }
        
        func showErrorMassage(_ errorMassage: String){
            errorMassageLabel.text = errorMassage
        }
        
        func validateFields(_ cleanedEmail: String?, _ cleanedPassword: String?, _ cleanedReEnteredPassword: String?, _ cleanedUsername: String?) -> String? {
            
            if cleanedEmail == "" || cleanedPassword == "" ||
            cleanedReEnteredPassword == "" || cleanedUsername == ""{
                return "Please fill all fields"
            }
            if !isPasswordValid(cleanedPassword!){
                return "Please make sure the length of the password is at least 6 characters"
            }
            
            return nil
        }
        
        func isPasswordValid(_ password : String) -> Bool{
            return password.count >= 6
         }
        
            
        override func viewDidLoad() {
            super.viewDidLoad()
            setupStyle()
        }
        
        func setupStyle(){
            UIUtility.floatButton(signupButton)
        }
        
}
