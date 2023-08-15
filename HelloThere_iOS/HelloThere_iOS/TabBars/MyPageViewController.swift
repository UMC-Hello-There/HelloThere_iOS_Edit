//
//  MyPageViewController.swift
//  HelloThere_iOS
//
//  Created by 서보현 on 2023/07/23.
//

import UIKit
import Alamofire

class MyPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nicknameTextField: UITextView!

    let data = [["주소 인증","비밀번호 변경"],["푸시알림 설정","쪽지 설정"],["내 게시물","내가 댓글 단 게시물"],["로그아웃", "회원 탈퇴"]]
    let header = ["계정","설정","커뮤니티","기타"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        닉네임 라벨 (api연결해서 닉네임 띄울 예정)
        nicknameTextField.text = "새유저"
        
        profileImg.layer.cornerRadius = profileImg.frame.height/2
        profileImg.layer.borderWidth = 1
        profileImg.clipsToBounds = true
        
        
      
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 35
       
        
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    
//    닉네임 변경 버튼을 클릭했을 때
    @IBAction func didTapModifiedNicknameButton(_ sender: Any) {
        let urlNickname = "http://3.37.126.149:8080/users/nickname?nickName=\(nicknameTextField.text ?? "")"
        let encodedStr = urlNickname.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! // 닉네임이 한국어로 들어가는 경우
        let url = URL(string: encodedStr)!

        struct nicknameModifiedResult: Codable {
            let isSuccess: Bool
            let code: Int
            let message: String
            let result : String?
        }

    let header = HTTPHeaders([HTTPHeader(name: "Authorization", value: UserDefaults.standard.string(forKey: "accessToken") ?? "")])

        AF.request(url, method: .patch, encoding: JSONEncoding.default, headers: header).responseJSON {
                response in
                switch response.result {
                case .success:
                    guard let result = response.data else { return }
                    do {
                        let decoder = JSONDecoder()
                        let json = try decoder.decode(nicknameModifiedResult.self, from: result)
                        print(json)
                        if json.isSuccess {
                            print("닉네임 변경 성공")
                            self.sendMessage(text: "닉네임이 변경되었습니다")
                        } else {
                            self.sendMessage(text: json.message)
                            self.nicknameTextField.text = ""
                        }
                    } catch{
                        print("닉네임 변경 실패")
                    }
                case .failure(let error):
                    print(error.errorDescription ?? "")
                default:
                    return
                }
            }
    }
    
    
    func sendMessage(text: String) {
        let sheet = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(sheet, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: .none)
        
        cell.textLabel?.text = data[indexPath.section][indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return header.count
    }
    

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        header.textLabel?.frame = header.bounds
        
    
    }
    


    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30.0
    }
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {

        view.tintColor = UIColor.lightGray

    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = view as? UITableViewHeaderFooterView
        
        if footer?.contentView == nil {
            
            footer?.contentView.backgroundColor = .lightGray
        }
        
        return footer
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //performSegue(withIdentifier: "showChangePw", sender: nil)
        switch indexPath.section {
            case 0:
                switch indexPath.row{
                    case 0: self.performSegue(withIdentifier: "showAddressAuth", sender: nil)
                    case 1: self.performSegue(withIdentifier: "showChangePw", sender: nil)
                    default:
                        return
                }
            case 1:
                switch indexPath.row{
                    case 0: self.performSegue(withIdentifier: "showSetAlarm", sender: nil)
                    case 1: self.performSegue(withIdentifier: "showSetMessage", sender: nil)
                    default:
                        return
            }
            
        case 2:
            switch indexPath.row{
                case 0: self.performSegue(withIdentifier: "showMyPost", sender: nil)
                case 1: self.performSegue(withIdentifier: "showMyComments", sender: nil)
                default:
                    return
        }
        case 3:
            switch indexPath.row{
            
            case 1:self.performSegue(withIdentifier: "showWithDrawl", sender: nil)
            case 0:
                let sheet = UIAlertController(title: nil, message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
                sheet.addAction(UIAlertAction(title: "네", style: .default) {
                    (action) in
                    
                    let url = "http://3.37.126.149:8080/users/log-out"
                    
                    struct SignOutResult: Codable {
                        let isSuccess: Bool
                        let code: Int
                        let message: String
                        let result : String
                    }
                    
                    let header = HTTPHeaders([HTTPHeader(name: "Authorization", value: UserDefaults.standard.string(forKey: "accessToken") ?? "")])
                    
//                    let headers = HTTPHeaders([header])
                    AF.request(url, method: .post, encoding: JSONEncoding.default, headers: header).responseJSON {
                        response in
                        switch response.result {
                        case .success:
                            guard let result = response.data else { return }
                            do {
                                let json = try JSONDecoder().decode(SignOutResult.self, from: result)
                                print(json)
                                if json.isSuccess {
                                    print("로그아웃 성공")
                                    
                                    UserDefaults.standard.set(false, forKey: "isSignIn")
                                            
                                    let nextStoryboard = UIStoryboard(name: "SignIn", bundle: nil)
                                    let nextViewController = nextStoryboard.instantiateViewController(identifier: "SignIn")
                                    nextViewController.modalPresentationStyle = .fullScreen
                                    self.present(nextViewController, animated: true, completion: nil)
                                } else {
                                    print("로그아웃 실패")
                                }
                            } catch{
                                print("로그아웃 실패")
                            }
                        case .failure(let error):
                            print(error.errorDescription ?? "")
                        default:
                            return
                        }
                    }
                })
                sheet.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
                self.present(sheet, animated: true)
            default:
                return
            }
            
        
            
            
            

                //case 2: self.performSegue(withIdentifier: "facialAnalysis", sender: nil)

                default:

                    return

        }
        
        
    }
}
