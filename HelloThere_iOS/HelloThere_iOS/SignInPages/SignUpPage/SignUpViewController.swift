//
//  SignUpViewController.swift
//  HelloThere_iOS
//
//  Created by 우주대스타 on 2023-08-07.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailErrorMessage: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorMessage: UILabel!
    @IBOutlet weak var checkPasswordTextField: UITextField!
    @IBOutlet weak var checkPasswordErrorMessage: UILabel!
    @IBOutlet weak var nicknamTextField: UITextField!
    @IBOutlet weak var nicknameErrorMessage: UILabel!
    
    var email: String = ""
    var password: String = ""
    var checkPassword: String = ""
    var nickname: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        회원가입 버튼
        signUpButton.layer.cornerRadius = 45
        signUpButton.layer.masksToBounds = true
        signUpButton.contentHorizontalAlignment = .center
        signUpButton.contentVerticalAlignment = .center
        
//        비밀번호 및 비밀번호 확인 텍스트 필드 입력 인식
        self.passwordTextField.addTarget(self, action: #selector(self.passwordTextFieldDidChanged(_:)), for: .editingChanged)
        self.checkPasswordTextField.addTarget(self, action: #selector(self.passwordCheckTextFieldDidChanged(_:)), for: .editingChanged)
    }
    
    
//    이메일 중복 버튼 클릭
    @IBAction func didTapEmailValidateButton(_ sender: Any) {
        email = emailTextField.text ?? ""
        if email.isEmpty {
            emailErrorMessage.text = "이메일 형식이 올바르지 않습니다."
            emailErrorMessage.textColor = UIColor.red
        } else {
            isEmailValidate(email: email) // 이메일 형식 및 중복 확인
        }
    }

    func isEmailValidate(email: String) {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let emailCheck = emailTest.evaluate(with: email)
        
        let urlEmail = "https://hello-there.shop/users/check-email?email=\(email)"
        
        if emailCheck {
            AF.request(urlEmail, method: .get).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    let isSuccess = json["result"]
                    if isSuccess.rawValue as! Bool{
//                        print("사용가능한 이메일")
                        self.emailErrorMessage.text = "사용가능한 이메일입니다"
                        self.emailErrorMessage.textColor =  UIColor(red: 43/255, green: 203/255, blue: 165/255, alpha: 1)
                    }else {
//                        print("사용불가능한 이메일")
                        self.emailErrorMessage.text = "사용불가능한 이메일입니다"
//                        self.emailErrorMessage.text = json["message"] as! String
                        self.emailErrorMessage.textColor = UIColor.red
                    }
                case .failure(let error):
                    print(error.errorDescription ?? "")
                default :
                    fatalError()
                }
            }
        } else {
            emailErrorMessage.text = "이메일 형식이 올바르지 않습니다."
            emailErrorMessage.textColor = UIColor.red
        }
    }
    
//    패스워드 형식 체크
    @IBAction func passwordTextFieldDidChanged(_ sender: UITextField) {
        password = passwordTextField.text ?? ""
        
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])[A-Za-z\\d$@$!%*?&]{6,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        let passwordCheck =  passwordTest.evaluate(with: password)
        
        if passwordCheck {
            passwordErrorMessage.text = "사용가능한 비밀번호 입니다"
            passwordErrorMessage.textColor = UIColor(red: 43/255, green: 203/255, blue: 165/255, alpha: 1)
        } else {
            passwordErrorMessage.text = "대소문자, 숫자, 조합, 6자 이상 입력해주세요"
            passwordErrorMessage.textColor = UIColor.systemRed
        }
    }
            
//    패스워드 확인 형식 체크 및 패스워드가 같은지 확인
    @IBAction func passwordCheckTextFieldDidChanged(_ sender: UITextField) {
        if !(self.passwordTextField.text?.isEmpty ?? true) &&
            !(self.checkPasswordTextField.text?.isEmpty ?? true) &&
            isSameBothTextField(first: passwordTextField, second: checkPasswordTextField){
            checkPassword = checkPasswordTextField.text!
            checkPasswordErrorMessage.text = "비밀번호가 일치합니다"
            checkPasswordErrorMessage.textColor = UIColor(red: 43/255, green: 203/255, blue: 165/255, alpha: 1)
        } else {
            checkPasswordErrorMessage.text = "비밀번호가 일치하지 않습니다"
            checkPasswordErrorMessage.textColor = UIColor.systemRed
        }
    }
    
    func isSameBothTextField(first: UITextField, second: UITextField) -> Bool {
        if (first.text == second.text){
            return true
        } else {
            return false
        }
    }
    
//    닉네임 중복 확인
    @IBAction func didTapNicknameValidateButton(_ sender: Any) {
        nickname = nicknamTextField.text ?? ""
        if nickname.isEmpty{
            nicknameErrorMessage.text = "닉네임을 입력해주세요"
            nicknameErrorMessage.textColor = UIColor.red
        } else {
            isNicknameValidate(nickname: nickname)
        }
    }
    
    func isNicknameValidate(nickname: String) {
        let urlNickname = "https://hello-there.shop/users/check-nickname?nickName=\(nickname)"
        let encodedStr = urlNickname.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! // 닉네임이 한국어로 들어가는 경우
        let url = URL(string: encodedStr)!
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print(json)
                let isSuccess = json["result"]

                if isSuccess.rawValue as! Bool{
                    self.nicknameErrorMessage.textColor = UIColor(red: 43/255, green: 203/255, blue: 165/255, alpha: 1)
                    self.nicknameErrorMessage.text = "사용가능한 닉네임입니다"
                }else {
                    self.nicknameErrorMessage.text = "사용 중인 닉네임입니다"
                    self.nicknameErrorMessage.textColor = UIColor.red
                }
            case .failure(let error):
                print(error.errorDescription ?? "")
            default :
                fatalError()
            }
        }
    }
    
    
//    다음 버튼 이동
    @IBAction func didTapSignUpButton(_ sender: Any) {
        isSignUpValidate(nickName: nickname, email: email, password: password, passwordChk: checkPassword)
    }
    
    func isSignUpValidate(nickName:String, email:String, password:String, passwordChk:String){
        let url = "https://hello-there.shop/users"
        struct SignUpResult: Codable {
            let isSuccess: Bool
            let code: Int
            let message: String
//            let result : data
        }
//        struct data: Codable {
//            let userId: Int
//            let nickName: String
//        }
        let body: Parameters = [
            "nickName" : nickName,
            "email" : email,
            "password" : password,
            "passwordChk" : passwordChk
        ]
            AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default).responseJSON {
                response in
                switch response.result {
                case .success:
                    guard let result = response.data else { return }
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(SignUpResult.self, from: result)
//                        print(json)
//                        print(json.isSuccess)
                        if json.isSuccess {
//                            print("회원가입 성공")
                            let nextStoryBoard = UIStoryboard(name: "SignUpGuide", bundle: nil)
                            guard let nextViewController = nextStoryBoard.instantiateViewController(identifier: "SignUpGuide")
                                as? SignUpGuideViewController else { return }
                            nextViewController.userNickname = nickName
                            nextViewController.modalPresentationStyle = .fullScreen
                            self.present(nextViewController, animated: true, completion: nil)
                        } else {
//                            print("회원가입 실패")
                        }
                    } catch{
                        print("회원가입 실패")
                    }
                case .failure(let error):
                    print(error.errorDescription ?? "")
                default:
                    return
                }
            }
    }
}
