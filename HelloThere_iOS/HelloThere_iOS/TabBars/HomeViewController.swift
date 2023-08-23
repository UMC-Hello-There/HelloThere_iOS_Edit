//
//  ViewController.swift
//  Mainpage
//
//  Created by 이권민 on 2023/08/02.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {

    
    
    @IBOutlet weak var AddressButton1: UIButton!
    @IBOutlet weak var AddressButton2: UIButton!

    @IBOutlet weak var PopularButton1: UIButton!
    
    @IBOutlet weak var PopularButton2: UIButton!
    @IBOutlet weak var PopularButton3: UIButton!
    @IBOutlet weak var PopularButton4: UIButton!
    @IBOutlet weak var FreeButton: UIButton!
    @IBOutlet weak var ShareButton: UIButton!
    @IBOutlet weak var ConflictButton: UIButton!
    @IBOutlet weak var InformationButton: UIButton!
    @IBOutlet weak var QuestionButton: UIButton!
    @IBOutlet weak var MarketPlaceButton: UIButton!
    @IBOutlet weak var ManageExpense: UILabel!
    @IBOutlet weak var ManageImage: UIImageView!
    @IBOutlet weak var Happening: UIButton!
    @IBOutlet var HomeImage: [UIImageView]!
    @IBOutlet var UsedImage: [UIImageView]!
    var newBoardData: [NewBoardInfo] = []
    var hotBoardData: [HotBoardInfo] = []
    var userFeesData: [UserFeesInfo] = []
    
    var address1: String?
    var address2: String?
    
    var popularPosts: [String] = []
    var freePosts: [String] = []
    var conflictPosts: [String] = []
    var sharePosts: [String] = []
    var marketplacePosts: [String] = []
    var informationPosts: [String] = []
    var questionPosts: [String] = []
    
    var cost: Int = 0
    var paymentCheck: Bool = false
    
    var checked: Bool = false
    
    let accessToken: String = "abc"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       // if let accessToken = TokenManager.shared.getAccessToken() {
            // 엑세스 토큰을 사용하여 서버에 요청 또는 다른 작업 수행
        //} else {
            // 엑세스 토큰이 없는 경우, 로그인 화면으로 이동 등의 처리
        //}
        fetchDataFromServer()
    }
    
    func fetchDataFromServer() {
        fetchHotBoardData(with: accessToken)
        fetchNewBoardData(with: accessToken)
        fetchFeesData(with: accessToken)
        }

    
    func fetchHotBoardData(with accessToken: String) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]

        AF.request("hello-there.shop/board/hot/main", headers: headers).responseDecodable(of: HotBoardResponse.self) { response in
            switch response.result {
            case .success(let hotBoardResponse):
                self.hotBoardData = hotBoardResponse.result
                self.updateUI()

            case .failure(let error):
                print("Error fetching hot board data: \(error)")
            }
        }
    }

    func fetchNewBoardData(with accessToken: String) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]

        AF.request("hello-there.shop/board/new", headers: headers).responseDecodable(of: NewBoardResponse.self) { response in
            switch response.result {
            case .success(let newBoardResponse):
                self.newBoardData = newBoardResponse.result
                self.updateUI()

            case .failure(let error):
                print("Error fetching new board data: \(error)")
            }
        }
    }
    
    func fetchFeesData(with accessToken: String) {
        let currentDate = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        let parameters: Parameters = ["feeYear": year, "feeMonth": month]

        AF.request("hello-there.shop/user-fees", parameters: parameters, headers: headers)
            .responseDecodable(of: UserFeesResponse.self) { response in
                switch response.result {
                case .success(let userFeesResponse):
                    self.userFeesData = userFeesResponse.result
                    self.updateUI()
                case .failure(let error):
                    print("Error fetching Fees data: \(error)")
                }
            }
    }
        
    
    func updateUI() {
        AddressButton1.setTitle(address1, for: .normal)
        AddressButton2.setTitle(address2, for: .normal)
        if hotBoardData.count >= 4 {
                PopularButton1.setTitle(hotBoardData[0].title, for: .normal)
                PopularButton2.setTitle(hotBoardData[1].title, for: .normal)
                PopularButton3.setTitle(hotBoardData[2].title, for: .normal)
                PopularButton4.setTitle(hotBoardData[3].title, for: .normal)
            }
        ManageExpense.text = "\(cost)"
        ManageImage.image = paymentCheck ?
        UIImage(named: "스크린샷 2023-07-18 오후 9.19.03") : UIImage(named: "스크린샷 2023-07-18 오후 9.17.54")
        
        
        Happening.setBackgroundImage(checked ? UIImage(named: "2023-08-01 오후 4.19.09") : UIImage(named: "스크린샷 2023-07-18 오후 8.34.42"), for: .normal)


        if newBoardData.count >= 6 {
               FreeButton.setTitle(newBoardData[0].title, for: .normal)
               ConflictButton.setTitle(newBoardData[1].title, for: .normal)
               ShareButton.setTitle(newBoardData[2].title, for: .normal)
               MarketPlaceButton.setTitle(newBoardData[3].title, for: .normal)
               InformationButton.setTitle(newBoardData[4].title, for: .normal)
               QuestionButton.setTitle(newBoardData[5].title, for: .normal)
           }
    }

    @IBAction func ToFreeButton(_ sender: UIButton) {
        // 자유 소통 게시판으로 화면 전환하는 로직을 구현하세요.
    }

    @IBAction func ToConflictButton(_ sender: UIButton) {
        // 갈등 소통 게시판으로 화면 전환하는 로직을 구현하세요.
    }

    @IBAction func ToShareButton(_ sender: UIButton) {
        // 공구 나눔 게시판으로 화면 전환하는 로직을 구현하세요.
    }

    @IBAction func ToMarketPlaceButton(_ sender: UIButton) {
        // 중고장터 게시판으로 화면 전환하는 로직을 구현하세요.
    }

    @IBAction func ToInformationButton(_ sender: UIButton) {
        // 정보공유 게시판으로 화면 전환하는 로직을 구현하세요.
    }

    @IBAction func ToPopularButton(_ sender: UIButton) {
        
    }

    @IBAction func ToQuestionButton(_ sender: UIButton) {
        
    }

    @IBAction func ToSearchButton(_ sender: UIButton) {
        guard let searchViewController = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else {
                return
            }
            searchViewController.modalPresentationStyle = .fullScreen
            present(searchViewController, animated: true, completion: nil)
    }

    @IBAction func ToHappening(_ sender: UIButton) {
        guard let newHappeningViewController = storyboard?.instantiateViewController(withIdentifier: "NewHappeningViewController") as? NewHappeningViewController else {
                return
            }
            newHappeningViewController.modalPresentationStyle = .fullScreen
            present(newHappeningViewController, animated: true, completion: nil)
    }

    @IBAction func ToManageButton(_ sender: UIButton) {
        guard let manageViewController = storyboard?.instantiateViewController(withIdentifier: "ManageViewController") as? ManageViewController else {
                return
            }
            manageViewController.modalPresentationStyle = .fullScreen
            present(manageViewController, animated: true, completion: nil)
        }
}
struct HotBoardResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [HotBoardInfo]
}

struct HotBoardInfo: Codable {
    let boardId: Int
    let boardType: String
    let title: String
}

struct NewBoardResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [NewBoardInfo]
}

struct NewBoardInfo: Codable {
    let boardId: Int
    let boardType: String
    let title: String
}

struct UserFeesResponse: Codable{
    let isSuccess: Bool
    let code: Int
    let message: String
    let result:[UserFeesInfo]
    
}
struct UserFeesInfo: Codable{
    let id: Int
    let feeYear: Int
    let feeMonth: Int
    let cost: Double
    let paymentCheck: Bool
}
