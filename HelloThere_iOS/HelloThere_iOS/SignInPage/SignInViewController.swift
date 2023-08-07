//
//  SignInViewController.swift
//  HelloThere_iOS
//
//  Created by 우주대스타 on 2023-08-07.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    회원가입 버튼 클릭시 회원가입 페이지로 이동
    @IBAction func didTapSignUpButton(_ sender: Any) {
        let nextStoryBoard = UIStoryboard(name: "SignUp", bundle: nil)
        let nextViewController = nextStoryBoard.instantiateViewController(identifier: "SignUp")
        nextViewController.modalPresentationStyle = .fullScreen
        present(nextViewController, animated:true, completion: nil)
    }
}
