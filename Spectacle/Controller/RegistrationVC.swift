//
//  RegistrationVC.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-05-14.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit
import Firebase

class RegistrationVC: UIViewController {
    
    //MARK: - Class Properties
    let addPhotoBtn: UIButton = {
        let button = UIButton()
        
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        
        button.addTarget(self, action: #selector(addProfilePhotoBtnPressed), for: .touchUpInside)
        return button
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.init(name: "Courier", size: 20)
        
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.init(name: "Courier", size: 20)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.init(name: "Courier", size: 20)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let signUpBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2784313725, green: 0.5803921569, blue: 0.9450980392, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.init(name: "Courier-Bold", size: 30)
        button.layer.cornerRadius = 5.0
        
        button.addTarget(self, action: #selector(signUpBtnPressed), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    //MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(addPhotoBtn)
        addPhotoBtn.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        addPhotoBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
    }
    
    //MARK: - Custom Methods
    fileprivate func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpBtn])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: addPhotoBtn.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
    }
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            signUpBtn.isEnabled = true
            signUpBtn.backgroundColor = #colorLiteral(red: 0.2784313725, green: 0.5803921569, blue: 0.9450980392, alpha: 1)
        } else {
            signUpBtn.isEnabled = false
            signUpBtn.backgroundColor = #colorLiteral(red: 0.2274509804, green: 0.5764705882, blue: 0.9333333333, alpha: 0.5530019264)
        }
        
    }
    
    @objc func signUpBtnPressed() {
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = usernameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Failed to create user: \(error.localizedDescription)")
                return
            }
            print("Successfully created user:", user?.uid ?? "")
            
            guard let image = self.addPhotoBtn.imageView?.image else { return }
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
            
            let filename = NSUUID().uuidString
            Storage.storage().reference().child("profile_images").child(filename).putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    print("Failed to upload profile image:", error)
                    return
                }
                guard let profileImageURL = metadata?.downloadURL()?.absoluteString else { return }
                print("Successfully uploaded profile image", profileImageURL)
                
                guard let uid = user?.uid else { return }
                
                let dictionaryValues = ["username": username, "profileImageUrl": profileImageURL]
                let values = [uid: dictionaryValues]
                
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, ref) in
                    if let error = error {
                        print("Failed to save user info into DB:", error)
                        return
                    }
                    print("successfully saved user info into database")
                })

            })
        }
    }
    
    @objc func addProfilePhotoBtnPressed() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }

}

//MARK: - ImagePickerControllerDelegate & NavigationControllerDelegate

extension RegistrationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            addPhotoBtn.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            addPhotoBtn.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        addPhotoBtn.layer.cornerRadius = addPhotoBtn.frame.width / 2
        addPhotoBtn.layer.masksToBounds = true
        addPhotoBtn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        addPhotoBtn.layer.borderWidth = 2.0
        dismiss(animated: true, completion: nil)
    }
}


























