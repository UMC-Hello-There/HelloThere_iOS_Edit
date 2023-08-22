//
//  SignUpGuideViewController.swift
//  HelloThere_iOS
//
//  Created by 우주대스타 on 2023-08-08.
//

import UIKit

class SignUpGuideViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var userMessage: UILabel!
    
    var userNickname: String = "새유저"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        버튼 둥글게
        nextButton.layer.cornerRadius = 30
        nextButton.layer.masksToBounds = true
        
//        유저 환영 메세지
        userMessage.text = "\(userNickname)님, 반가워요\n가입을 진심으로 환영합니다"
    }
    
//    다음 버튼 이동
    @IBAction func didTapNextButton(_ sender: Any) {
        let nextStoryBoard = UIStoryboard(name: "AddressVerification", bundle: nil)
        let nextViewController = nextStoryBoard.instantiateViewController(identifier: "AddressVerification")
        nextViewController.modalPresentationStyle = .fullScreen
        present(nextViewController, animated: true, completion: nil)
    }
}
