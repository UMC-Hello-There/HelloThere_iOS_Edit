//
//  AdQusViewController.swift
//  Mainpage
//
//  Created by 두근두근 코딩타임 on 2023/08/18.
//

import UIKit
import Alamofire

class AdQusViewController: UIViewController {
    @IBOutlet weak var PhoneNum1: UITextField!
    @IBOutlet weak var PhoneNum2: UITextField!
    @IBOutlet weak var PhoneNum3: UITextField!
    @IBOutlet weak var Content: UITextView!
    @IBOutlet weak var CheckBox1: UIButton!
    @IBOutlet weak var CheckBox2: UIButton!

    var checkBox1Selected: Bool = false
    var checkBox2Selected: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func Check1(_ sender: UIButton) {
        checkBox1Selected.toggle()
            let imageName = checkBox1Selected ? "checkmark.square" : "rectangle"
            CheckBox1.setImage(UIImage(named: imageName), for: .normal)
    }

    @IBAction func Check2(_ sender: UIButton) {
        checkBox2Selected.toggle()
            let imageName = checkBox2Selected ? "checkmark.square" : "rectangle"
            CheckBox2.setImage(UIImage(named: imageName), for: .normal)
    }

    @IBAction func SendQues(_ sender: UIButton) {
        guard checkBox1Selected && checkBox2Selected else {
            // 두 체크박스가 모두 선택되지 않았을 경우 처리
            return
        }

        // 옵셔널 텍스트 값들을 안전하게 해제
            guard let phoneNum1 = PhoneNum1.text, let phoneNum2 = PhoneNum2.text, let phoneNum3 = PhoneNum3.text, let content = Content.text else {
                // 어떤 텍스트 필드가 nil 값을 가지고 있는 경우 여기서 처리
                return
            }

            let phoneNumber = "\(phoneNum1)\(phoneNum2)\(phoneNum3)"
            
            sendAdvertisementInquiry(phoneNumber: phoneNumber, content: content)
    }

    func sendAdvertisementInquiry(phoneNumber: String, content: String) {
        let url = "https://hello-there.shop/user/notice"
        let parameters: [String: Any] = [
            "phoneNumber": phoneNumber,
            "content": content
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: ApiResponse.self) { response in
                switch response.result {
                case .success(let apiResponse):
                    print("API Response: \(apiResponse)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
}

struct ApiResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: String
}
