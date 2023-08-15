//
//  WithDrawlViewController.swift
//  HelloThere_iOS
//
//  Created by 서보현 on 2023/07/27.
//

import UIKit
import Alamofire

class WithDrawlViewController: UIViewController {

    @IBOutlet weak var agreementGuideLabel: UILabel!
    @IBOutlet weak var agreementTextField: UITextField!
    @IBOutlet weak var agreementErrorMessage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        계정 삭제에 동의합니다 안내 문구 포인트 색 입히기
        let attributedStr = NSMutableAttributedString(string: agreementGuideLabel.text!)
        attributedStr.addAttribute(.foregroundColor, value: UIColor(red: 43/255, green: 203/255, blue: 165/255, alpha: 1), range: (agreementGuideLabel.text! as NSString).range(of: "계정 삭제에 동의합니다"))
        agreementGuideLabel.attributedText = attributedStr
    }
    
//    회원탈퇴 버튼
    @IBAction func didTapWithdrawalButton(_ sender: Any) {
        let urlAgreement = "http://3.37.126.149:8080/users?agreement=\(agreementTextField.text ?? "")"
        let encodedStr = urlAgreement.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! // 동의 문구가 한국어로 들어가므로
        let url = URL(string: encodedStr)!

        struct WithdrawalResult: Codable {
            let isSuccess: Bool
            let code: Int
            let message: String
            let result : String?
        }
        
        let header = HTTPHeaders([HTTPHeader(name: "Authorization", value: UserDefaults.standard.string(forKey: "accessToken") ?? "")])
        
        AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            switch response.result {
            case .success:
                guard let result = response.data else { return }
                do {
                    let json = try JSONDecoder().decode(WithdrawalResult.self, from: result)
//                        print(json)
                    
                    if json.isSuccess {
                        print("회원탈퇴 성공")
                        
                        let sheet = UIAlertController(title: nil, message: json.result, preferredStyle: .alert)
                        sheet.addAction(UIAlertAction(title: "확인", style: .default) { (action) in
                            
                            UserDefaults.standard.set(false, forKey: "isSignIn")
                            let nextStoryboard = UIStoryboard(name: "SignIn", bundle: nil)
                            let nextViewController = nextStoryboard.instantiateViewController(identifier: "SignIn")
                            nextViewController.modalPresentationStyle = .fullScreen
                            self.present(nextViewController, animated: true, completion: nil)
                            })
                        self.present(sheet, animated: true)
                        } else {
                            print("회원탈퇴 실패")
                            
                            let sheet = UIAlertController(title: nil, message: json.message, preferredStyle: .alert)
                            sheet.addAction(UIAlertAction(title: "확인", style: .default))
                            self.present(sheet, animated: true)
                        }
                    } catch{
                        print("회원탈퇴 실패")
                    }
                case .failure(let error):
                    print(error.errorDescription ?? "")
                default:
                    return
                }
            }
    }
}
