//
//  ChangePasswordViewController.swift
//  HelloThere_iOS
//
//  Created by 서보현 on 2023/07/23.
//

import UIKit
import Alamofire

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var exPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordChkTextField: UITextField!
    
    let manager = Manager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    변경버튼
    @IBAction func didTapPasswordModifiedButton(_ sender: Any) {
        let url = "http://3.37.126.149:8080/users/password"
        
        struct PasswordModifiedResult: Codable {
            let isSuccess: Bool
            let code: Int
            let message: String
            let result : String?
        }
        
        let body: Parameters = [
            "exPassword" : exPasswordTextField.text ?? "",
            "newPassword" : newPasswordTextField.text ?? "",
            "newPasswordChk" : newPasswordChkTextField.text ?? "",
        ]
        
        let header = HTTPHeaders([HTTPHeader(name: "Authorization", value: UserDefaults.standard.string(forKey: "accessToken") ?? "")])
        
//        api 요청
        if manager.checkPasswordValidate(password: newPasswordTextField.text ?? "") {
            AF.request(url, method: .patch, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON {
                response in
                switch response.result {
                case .success:
                    guard let result = response.data else { return }
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(PasswordModifiedResult.self, from: result)
//                        print(json)
                        
                        if json.isSuccess {
                            print("비밀번호 변경 성공")
                            self.sendMessage(text: json.result!)
                            self.clearPassword()
                        } else {
                            self.sendMessage(text: json.message)
                            self.clearPassword()
                            print("비밀번호 변경 실패")
                        }
                    } catch{
                        print("비밀번호 변경 실패")
                    }
                case .failure(let error):
                    print(error.errorDescription ?? "")
                default:
                    return
                }
            }
        } else {
            sendMessage(text: "비밀번호 형식이 맞지 않습니다")
            clearPassword()
        }
    }
    
    
    func sendMessage(text: String) {
        let sheet = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(sheet, animated: true)
    }
    
    func clearPassword() {
        exPasswordTextField.text = ""
        newPasswordTextField.text = ""
        newPasswordChkTextField.text = ""
    }
}
