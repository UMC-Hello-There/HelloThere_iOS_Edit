//
//  SignInViewController.swift
//  HelloThere_iOS
//
//  Created by 우주대스타 on 2023-08-07.
//

import UIKit
import Alamofire

class SignInViewController: UIViewController {

    @IBOutlet weak var signInErrorMessageLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    로그인 버튼 클릭시
    @IBAction func didTapSignInButton(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else {
            signInErrorMessageLabel.text = "이메일을 입력해주세요"
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            signInErrorMessageLabel.text = "비밀번호를 입력해주세요"
            return }
        
//        로그인 성공 여부 확인
        checkLoginValidate(email: email, password: password)
    }
    
//    회원가입 버튼 클릭시 회원가입 페이지로 이동
    @IBAction func didTapSignUpButton(_ sender: Any) {
        let nextStoryBoard = UIStoryboard(name: "SignUp", bundle: nil)
        let nextViewController = nextStoryBoard.instantiateViewController(identifier: "SignUp")
        nextViewController.modalPresentationStyle = .fullScreen
        present(nextViewController, animated:true, completion: nil)
    }
    
//    로그인 성공 확인
    func checkLoginValidate(email:String, password:String){
        struct LoginResult: Codable {
            let isSuccess: Bool
            let code: Int
            let message: String
        }
        
        let body: Parameters = [
            "email" : email,
            "password" : password
        ]
        
        let url = "http://3.37.126.149:8080/users/log-in"
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default).responseJSON {
            response in
            switch response.result {
            case .success:
                guard let result = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let json = try decoder.decode(LoginResult.self, from: result)
//                    print(json)
//                    print(json.isSuccess)
                    if json.isSuccess {
//                        print("로그인 성공")
                        let defaults = UserDefaults.standard
                        defaults.set(true, forKey: "isSignIn")
                        defaults.set(email, forKey: "email")
                        defaults.set(password, forKey: "password")
                        self.signInErrorMessageLabel.text = "성공✅"
                    } else {
                        print("로그인 실패")
                        self.signInErrorMessageLabel.text = "존재하지 않는 회원입니다"
                    }
                } catch {
                    print("로그인 실패")
                    self.signInErrorMessageLabel.text = "존재하지 않는 회원입니다"
                }
            default:
                return
            }
        }
    }
}
