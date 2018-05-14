//
//  RegistrationVC.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-05-14.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController {
    
    let addPhotoBtn: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.init(name: "Courier", size: 20)
        return textField
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.init(name: "Courier", size: 20)
        return textField
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.init(name: "Courier", size: 20)
        return textField
    }()
    
    let signUpBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.5764705882, blue: 0.8941176471, alpha: 1)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.init(name: "Courier-Bold", size: 30)
        button.layer.cornerRadius = 5.0
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(addPhotoBtn)
        addPhotoBtn.heightAnchor.constraint(equalToConstant: 140).isActive = true
        addPhotoBtn.widthAnchor.constraint(equalToConstant: 140).isActive = true
        addPhotoBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addPhotoBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        
        setupInputFields()
    }
    
    fileprivate func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpBtn])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: addPhotoBtn.bottomAnchor, constant: 20),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            stackView.heightAnchor.constraint(equalToConstant: 200)
            ])
    }
    

}








