//
//  PostUploadViewController.swift
//  Garage Sell
//
//  Created by Yuhong Xu on 5/24/20.
//  Copyright © 2020 Yuhong Xu. All rights reserved.
//

import UIKit
import Firebase

class PostUploadViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var photoUploadView: UIView!
    
    @IBOutlet weak var itemTitle: UITextField!
    @IBOutlet weak var itemDescription: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var imagePickerButton: UIButton!
    
    
    var postsRef : CollectionReference!
    
    var image : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIUtility.floatButton(continueButton)
    }
    
    
    @IBAction func addPhotoButtonPressed(_ sender: Any) {
        showImagePickerController()
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
        // if image == null
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.itemUploadContinueIdentifier{
            (segue.destination as! ContinuePostUploadViewController).firstPageItem = ["title" : itemTitle.text! as String,
                                                                                      "description" : itemDescription.text! as String,
                                                                                      "image": image as UIImage?]
        }
    }
}


//  This snip of code about picking image with UIImagePickerController comes from Youtube Video
// "Pick Image with UIImagePickerController in Swift"
// https://www.youtube.com/watch?v=JYkj1UmQ6_g&t=294s

extension PostUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func showImagePickerController(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            imagePickerButton.setImage(editedImage, for: .normal)
            image = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imagePickerButton.setImage(originalImage, for: .normal)
            image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
}
