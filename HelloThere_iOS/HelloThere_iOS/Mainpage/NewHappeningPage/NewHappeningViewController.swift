//
//  NewHappeningViewController.swift
//  Mainpage
//
//  Created by 두근두근 코딩타임 on 2023/08/14.
//

import UIKit
import Alamofire

class NewHappeningViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var NewHappeningTable: UITableView!
    
    var notifications: [NotificationItem] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            NewHappeningTable.delegate = self
            NewHappeningTable.dataSource = self
            
            fetchNotifications()
        }
    
    @IBAction func BackToMain(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    func fetchNotifications() {
            let apiURL = "https://hello-there.shop/users/notice"
            
            AF.request(apiURL, method: .get)
                .validate()
                .responseDecodable(of: NotificationResponse.self) { response in
                    switch response.result {
                    case .success(let notificationResponse):
                        self.notifications = notificationResponse.result
                        self.NewHappeningTable.reloadData()
                    case .failure(let error):
                        print("API Request Failed: \(error)")
                    }
                }
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return notifications.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NewPostsCell
            let notification = notifications[indexPath.row]
            
            cell.Body.text = notification.body
            cell.Category.text = convertBoardTypeToKorean(boardType: notification.boardType) ?? ""
            
            return cell
        }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           // Remove the default cell separator inset
           if cell.responds(to: #selector(getter: UIView.preservesSuperviewLayoutMargins)) {
               cell.preservesSuperviewLayoutMargins = false
           }
           
           // Set the cell separator to be full width
           if cell.responds(to: #selector(getter: UIView.layoutMargins)) {
               cell.layoutMargins = UIEdgeInsets.zero
           }
           
           // Remove separator insets for the cell if needed
           if cell.responds(to: #selector(getter: UITableViewCell.separatorInset)) {
               cell.separatorInset = UIEdgeInsets.zero
           }
       }
   

        
        // API 응답 데이터 모델
        struct NotificationResponse: Decodable {
            let isSuccess: Bool
            let code: Int
            let message: String
            let result: [NotificationItem]
        }
        
        // 알림 데이터 모델
        struct NotificationItem: Decodable {
            let noticeId: Int
            let title: String
            let body: String
            let boardType: String?
            let createTime: String
        }
        
        // 게시판 타입을 한글로 변환하는 함수
        func convertBoardTypeToKorean(boardType: String?) -> String? {
            guard let boardType = boardType else {
                return nil
            }
            
            switch boardType {
            case "FREE_BOARD":
                return "자유 소통 게시판"
            case "CONFLICT_BOARD":
                return "갈등관리 소통 게시판"
            case "SHARE_BOARD":
                return "공구, 나눔 게시판"
            case "MARKET_PLACE_BOARD":
                return "중고 장터 게시판"
            case "INFORMATION_BOARD":
                return "정보 게시판"
            case "QUESTION_BOARD":
                return "질문 게시판"
            default:
                return boardType // 해당하지 않는 경우 그대로 반환
            }
        }
    }
