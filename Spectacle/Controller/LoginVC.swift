//
//  LoginVC.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-05-16.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    let signUpBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account? Sign Up.", for: .normal)
        button.addTarget(self, action: #selector(showRegistrationVC), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        view.addSubview(signUpBtn)
        signUpBtn.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    }
    
    @objc func showRegistrationVC() {
        let registrationVC = RegistrationVC()
        navigationController?.pushViewController(registrationVC, animated: true)
    }
}
