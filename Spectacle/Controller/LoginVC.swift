//
//  LoginVC.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-05-16.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    //MARK: - Class Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let logoContainerView: UIView = {
        let view = UIView()
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        logoImageView.contentMode = .scaleAspectFill

        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.backgroundColor = #colorLiteral(red: 0.3215686275, green: 0.5607843137, blue: 0.9450980392, alpha: 1)
        return view
    }()
    
    let dontHaveAccountBtn: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedStringKey.font: UIFont.init(name: "Courier", size: 14) ?? UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedStringKey.font: UIFont.init(name: "Courier-Bold", size: 14) ?? UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.3215686275, green: 0.5607843137, blue: 0.9450980392, alpha: 1)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(showRegistrationVC), for: .touchUpInside)
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
    
    let loginBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2274509804, green: 0.5764705882, blue: 0.9333333333, alpha: 0.5530019264)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.init(name: "Courier-Bold", size: 30)
        button.layer.cornerRadius = 5.0
        
        button.addTarget(self, action: #selector(loginBtnPressed), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    //MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        view.addSubview(dontHaveAccountBtn)
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        dontHaveAccountBtn.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        setupInputFields()
    }
    
    //MARK: - Custom Methods
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginBtn])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
    }
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            loginBtn.isEnabled = true
            loginBtn.backgroundColor = #colorLiteral(red: 0.2784313725, green: 0.5803921569, blue: 0.9450980392, alpha: 1)
        } else {
            loginBtn.isEnabled = false
            loginBtn.backgroundColor = #colorLiteral(red: 0.2274509804, green: 0.5764705882, blue: 0.9333333333, alpha: 0.5530019264)
        }
    }
    
    @objc func loginBtnPressed() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Failed to sign in with email:", error)
                return
            }
            print("Successfully logged back in with user:", user?.uid ?? "")
            
            guard let mainTabVC = UIApplication.shared.keyWindow?.rootViewController as? MainTabVC else { return }
            mainTabVC.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func showRegistrationVC() {
        let registrationVC = RegistrationVC()
        navigationController?.pushViewController(registrationVC, animated: true)
    }
}
