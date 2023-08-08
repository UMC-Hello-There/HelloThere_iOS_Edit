//
//  SignUpViewController.swift
//  HelloThere_iOS
//
//  Created by 우주대스타 on 2023-08-07.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorMessage: UILabel!
    @IBOutlet weak var checkPasswordTextField: UITextField!
    @IBOutlet var checkPasswordErrorMessage: UIView!
    @IBOutlet weak var nicknamTextField: UITextField!
    @IBOutlet weak var nicknameErrorMessage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        회원가입 버튼 둥글게
        signUpButton.layer.cornerRadius = 45
        signUpButton.layer.masksToBounds = true
        signUpButton.contentHorizontalAlignment = .center
        signUpButton.contentVerticalAlignment = .center
        
//        비밀번호 및 비밀번호 확인 텍스트 필드 입력 인식
//        self.passwordTextField.addTarget(self, action: #selector(self.PasswordTextFieldDidChanged(_:)), for: .editingChanged)
//        self.checkPasswordTextField.addTarget(self, action: #selector(self.passwordCheckTextFieldDidChanged(_:)), for: .editingChanged)
    }
    
//    이메일 중복 확인 버튼
    @IBAction func isEmailValidate(_ sender: Any) {
    }
    
    
//    닉네임 중복 확인 버튼
    @IBAction func isNicknameValidate(_ sender: Any) {
    }
    
//    다음 버튼 이동
    @IBAction func didTapSignUpButton(_ sender: Any) {
        let nextStroyBoard = UIStoryboard(name: "SignUpGuide", bundle: nil)
        let nextViewController = nextStroyBoard.instantiateViewController(identifier: "SignUpGuide")
        nextViewController.modalPresentationStyle = .fullScreen
        present(nextViewController, animated: true, completion: nil)
    }
}
