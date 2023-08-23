//
//  ViewController.swift
//  Mainpage
//
//  Created by 이권민 on 2023/08/02.
//

import UIKit
import Alamofire

class HomeTapViewController: UIViewController {

    
    
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
    var newBoardData: [BoardInfo] = []
    var hotBoardData: [BoardInfo] = []
    var userFeesData: [UserFeesInfo] = []
    var homeTerrierData:[BoardMainDTO] = []
    var marketPlaceData: [BoardMainDTO] = []
    var houseData: [HouseInfo] = []
    var address1: String?
    var address2: String?
    
    var houseId: Int = 1//차후 수정
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

    let accessToken = UserDefaults.standard.string(forKey: "accessToken")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if accessToken != nil {
                   fetchDataFromServer()
               } else {
                   showLoginScreen()
               }
           }
    
    func fetchDataFromServer() {
        fetchHotBoardData(with: accessToken!)
        fetchNewBoardData(with: accessToken!)
        fetchFeesData(with: accessToken!)
        fetchMarketplaceData(with: accessToken!)
        fetchHomeTerrierData(with: accessToken!)
        fetchHouseData(with: accessToken! )
        }

    func showLoginScreen() {
            // Storyboard에서 정의된 로그인 뷰 컨트롤러를 가져오기
            if let signInViewController = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController {
                // 로그인 화면을 모달로 표시
                signInViewController.modalPresentationStyle = .fullScreen
                present(signInViewController, animated: true, completion: nil)
            }
        }
    
    func fetchMarketplaceData(with accessToken: String) {
            let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]

            AF.request("https://hello-there.shop/board/market/main", headers: headers).responseDecodable(of: HomeTerrierResponse.self) { response in
                switch response.result {
                case .success(let marketplaceResponse):
                    self.marketPlaceData = marketplaceResponse.result
                                self.updateUI()

                case .failure(let error):
                    print("Error fetching marketplace data: \(error)")
                }
            }
        }
    
    func fetchHomeTerrierData(with accessToken: String) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]

        AF.request("https://hello-there.shop/board/hometerrier/main", headers: headers).responseDecodable(of: HomeTerrierResponse.self) { response in
            switch response.result {
            case .success(let homeTerrierResponse):
                // API 응답 데이터 처리
                self.homeTerrierData = homeTerrierResponse.result
                            self.updateUI()
                self.updateUI()

            case .failure(let error):
                print("Error fetching home terrier data: \(error)")
            }
        }
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
    func fetchHouseData(with accessToken: String) {
            let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]

            // 이 부분에서 houseId를 어떻게 가져올지에 따라 수정해야 합니다.
            // 예를 들어, address1 또는 address2를 통해 houseId를 가져올 수 있습니다.

            // houseId 가져오는 방식 예시:
            // let houseId = getHouseIdFromAddress(address1)

            let parameters: Parameters = ["houseId": houseId]

            AF.request("https://hello-there.shop/houses", parameters: parameters, headers: headers)
                .responseDecodable(of: HouseResponse.self) { response in
                    switch response.result {
                    case .success(let houseResponse):
                        self.houseData = houseResponse.result
                        self.updateUI()

                    case .failure(let error):
                        print("Error fetching house data: \(error)")
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

                // houseData로부터 정보를 가져와 UI를 업데이트합니다.
        if let houseInfo = houseData.first {
                    // houseName은 addressButton1으로 설정
        AddressButton1.setTitle(houseInfo.houseName, for: .normal)
                    // City, District, streetAddress를 addressButton2로 설정
        AddressButton2.setTitle("\(houseInfo.city) \(houseInfo.district) \(houseInfo.streetAddress)", for: .normal)
                }
        if hotBoardData.count >= 4 {
            PopularButton1.setTitle(hotBoardData[0].title, for: .normal)
            PopularButton2.setTitle(hotBoardData[1].title, for: .normal)
            PopularButton3.setTitle(hotBoardData[2].title, for: .normal)
            PopularButton4.setTitle(hotBoardData[3].title, for: .normal)
        }
        ManageExpense.text = "\(cost)"
        ManageImage.image = paymentCheck ? UIImage(named: "Paid") : UIImage(named: "NoPay")

        Happening.setBackgroundImage(checked ? UIImage(named: "NoHappening") : UIImage(named: "NewHappening"), for: .normal)

        for (index, data) in marketPlaceData.enumerated() {
            let imageView = HomeImage[index]
            if let imageUrl = URL(string: data.getS3Res.imgUrl),
               let imageData = try? Data(contentsOf: imageUrl),
               let image = UIImage(data: imageData) {
                imageView.image = image
            }
            let titleLabel = UILabel()
            titleLabel.text = data.title
            titleLabel.textAlignment = .center
            imageView.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
                titleLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
        }

        for (index, data) in homeTerrierData.enumerated() {
            let imageView = HomeImage[index]
            if let imageUrl = URL(string: data.getS3Res.imgUrl),
               let imageData = try? Data(contentsOf: imageUrl),
               let image = UIImage(data: imageData) {
                imageView.image = image
            }
            let titleLabel = UILabel()
            titleLabel.text = data.title
            titleLabel.textAlignment = .center
            imageView.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
                titleLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
    }



    @IBAction func ToFreeButton(_ sender: UIButton) {
        guard let freeBoardViewController = storyboard?.instantiateViewController(withIdentifier: "FreeBoardViewController") as? FreeBoardViewController else {
        return
    }
    freeBoardViewController.modalPresentationStyle = .fullScreen
    present(freeBoardViewController, animated: true, completion: nil)    }

    @IBAction func ToConflictButton(_ sender: UIButton) {
        let complainBoardViewController = storyboard?.instantiateViewController(withIdentifier: "ComplainBoardViewController") as? ComplainBoardViewController
                
            complainBoardViewController?.modalPresentationStyle = .fullScreen
        present(complainBoardViewController!, animated: true, completion: nil)
    }

    @IBAction func ToShareButton(_ sender: UIButton) {
        let shareBoardViewController = storyboard?.instantiateViewController(withIdentifier: "ShareBoardViewController") as? ShareBoardViewController
        
        shareBoardViewController?.modalPresentationStyle = .fullScreen
            present(shareBoardViewController!, animated: true, completion: nil)
    }

    @IBAction func ToMarketPlaceButton(_ sender: UIButton) {
        let shopBoardViewController = storyboard?.instantiateViewController(withIdentifier: "ShopBoardViewController") as? ShopBoardViewController
    
            shopBoardViewController?.modalPresentationStyle = .fullScreen
            present(shopBoardViewController!, animated: true, completion: nil)
    }

    @IBAction func ToInformationButton(_ sender: UIButton) {
        let infoBoardViewController = storyboard?.instantiateViewController(withIdentifier: "InfoBoardViewController") as? InfoBoardViewController
        
            infoBoardViewController?.modalPresentationStyle = .fullScreen
            present(infoBoardViewController!, animated: true, completion: nil)
    }

    @IBAction func ToPopularButton(_ sender: UIButton) {
        
    }

    @IBAction func ToQuestionButton(_ sender: UIButton) {
        let qnaBoardViewController = storyboard?.instantiateViewController(withIdentifier: "QnAViewController") as? QnAViewController
        
        qnaBoardViewController?.modalPresentationStyle = .fullScreen
        present(qnaBoardViewController!, animated: true, completion: nil)
    }

    @IBAction func ToSearchButton(_ sender: UIButton) {
        let searchViewController = storyboard?.instantiateViewController(withIdentifier: "SearchViewController")
        
            searchViewController?.modalPresentationStyle = .fullScreen
            present(searchViewController!, animated: true, completion: nil)
    }

    @IBAction func ToHappening(_ sender: UIButton) {
        let newHappeningViewController = storyboard?.instantiateViewController(withIdentifier: "NewHappeningViewController") as? NewHappeningViewController
        
            newHappeningViewController?.modalPresentationStyle = .fullScreen
            present(newHappeningViewController!, animated: true, completion: nil)
    }

    @IBAction func ToManageButton(_ sender: UIButton) {
        let manageViewController = storyboard?.instantiateViewController(withIdentifier: "ManageViewController") as? ManageViewController
        
            manageViewController?.modalPresentationStyle = .fullScreen
            present(manageViewController!, animated: true, completion: nil)
        }
}
struct HotBoardResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [BoardInfo]
}

struct NewBoardResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [BoardInfo]
}

struct BoardInfo: Codable {
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

struct HomeTerrierResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [BoardMainDTO]
}

struct BoardMainDTO: Codable {
    let boardId: Int
    let boardType: String
    let title: String
    let getS3Res: S3Resource
}

struct S3Resource: Codable {
    let imgUrl: String
    let fileName: String
}

struct HouseResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [HouseInfo]
}

struct HouseInfo: Codable {
    let houseId: Int
    let houseName: String
    let city: String
    let district: String
    let streetAddress: String
    let location: LocationInfo
}

struct LocationInfo: Codable {
    let lng: Double
    let lat: Double
}
