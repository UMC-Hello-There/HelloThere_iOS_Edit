//
//  SearchViewController.swift
//  Mainpage
//
//  Created by 두근두근 코딩타임 on 2023/08/07.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var searchResults: [GetBoardRes] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        customizeSearchBar()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none // TableView의 구분선을 없앱니다.

    }
    @IBAction func BackToMain(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func customizeSearchBar() {
            searchBar.showsCancelButton = false
            searchBar.enablesReturnKeyAutomatically = true
            searchBar.returnKeyType = .search
            
            // 검색 바의 텍스트 필드 가져오기
                    let textFieldInsideSearchBar = searchBar.searchTextField
                    
                    // 텍스트 필드 커스텀 설정
                    textFieldInsideSearchBar.backgroundColor = UIColor(red: 0xFC/255.0, green: 0xFC/255.0, blue: 0xFC/255.0, alpha: 1.0)
                    textFieldInsideSearchBar.layer.borderWidth = 2.0 // 테두리 굵게 설정
                    textFieldInsideSearchBar.layer.borderColor = UIColor(red: 0x2B/255.0, green: 0xCB/255.0, blue: 0xA5/255.0, alpha: 1.0).cgColor
                    textFieldInsideSearchBar.layer.cornerRadius = 20 // 더 둥글게 설정
                    textFieldInsideSearchBar.clipsToBounds = true

                    // clearButton 이미지 변경
                    if let clearButton = textFieldInsideSearchBar.value(forKey: "_clearButton") as? UIButton,
                        let clearImage = UIImage(named: "Image 5") {
                        clearButton.setImage(clearImage, for: .normal)
                    }
                    
                    if let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
                        // 돋보기 아이콘의 색상 변경
                        glassIconView.tintColor = UIColor(red: 0x2B/255.0, green: 0xCB/255.0, blue: 0xA5/255.0, alpha: 1.0)
                        
                        // 이미지 뷰의 위치를 조절하여 간격을 둔다
                        let rightOffset: CGFloat = 30.0
                                    let newFrame = CGRect(x: glassIconView.frame.origin.x + rightOffset, y: glassIconView.frame.origin.y, width: glassIconView.frame.size.width, height: glassIconView.frame.size.height)
                                    glassIconView.frame = newFrame                }
        searchBar.layer.borderWidth = 0
           searchBar.layer.borderColor = UIColor.clear.cgColor
                }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            searchPosts(keyword: searchText)
        }
        searchBar.resignFirstResponder()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchingPostsCell
            let post = searchResults[indexPath.row]
        
        // Title에서 keyword와 일치하는 부분을 다른 색상으로 표시
            if let keyword = searchBar.text, !keyword.isEmpty,
               let range = post.title.range(of: keyword, options: .caseInsensitive) {
                let attributedTitle = NSMutableAttributedString(string: post.title)
                attributedTitle.addAttribute(.foregroundColor, value: UIColor(red: 0x2B/255.0, green: 0xCB/255.0, blue: 0xA5/255.0, alpha: 1.0), range: NSRange(range, in: post.title))
                cell.Title.attributedText = attributedTitle
            } else {
                cell.Title.text = post.title
            }
            
            // Content에서 keyword와 일치하는 부분을 다른 색상으로 표시
            if let keyword = searchBar.text, !keyword.isEmpty,
               let range = post.content.range(of: keyword, options: .caseInsensitive) {
                let attributedContent = NSMutableAttributedString(string: post.content)
                attributedContent.addAttribute(.foregroundColor, value: UIColor(red: 0x2B/255.0, green: 0xCB/255.0, blue: 0xA5/255.0, alpha: 1.0), range: NSRange(range, in: post.content))
                cell.Contents.attributedText = attributedContent
            } else {
                cell.Contents.text = post.content
            }
        // createTime에서 양끝에 소괄호 추가
                cell.UploadedTime.text = "(\(post.createTime))"
                
                // view는 "조회수 /view" 형식으로 표시
                cell.View.text = "조회수 \(post.view)"
                
                // boardType에 따라 한글로 변환
                cell.CategoryId.text = convertBoardTypeToKorean(boardType: post.boardType)
                
                // commentCount와 likeCount는 기존 코드 그대로 유지
                cell.Comments.text = String(describing: post.commentCount)
                cell.Good.text = String(describing: post.likeCount)
        // UITableViewCell의 하단 구분선 설정
            if indexPath.row == searchResults.count - 1 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0) // 하단 구분선만 나타나도록 설정
            } else {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) // 하단 구분선이 나타나지 않도록 설정
            }
                
        return cell
    }

    func searchPosts(keyword: String) {
        let baseURL = "https://hello-there.shop"
        let apiPath = "/board/search"
        let apiURL = baseURL + apiPath
        
        let parameters: [String: Any] = ["keyword": keyword]
        
        AF.request(apiURL, method: .get, parameters: parameters)
            .validate()
            .responseDecodable(of: APIResponse.self) { response in
                switch response.result {
                case .success(let apiResponse):
                    self.searchResults = apiResponse.result
                    self.tableView.reloadData()
                case .failure(let error):
                    print("API Request Failed: \(error)")
                }
            }
    }
}

// boardType을 한글로 변환하는 함수
    func convertBoardTypeToKorean(boardType: String) -> String {
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
            return boardType // 만약 해당하지 않는 경우 그대로 반환
        }
    }

// API 응답 데이터 모델
struct APIResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [GetBoardRes]
}

// 게시물 데이터 모델
struct GetBoardRes: Decodable {
    let boardId: Int
    let boardType: String
    let createDate: String
    let createTime: String
    let nickName: String
    let title: String
    let content: String
    let view: Int
    let commentCount: Int
    let likeCount: Int
}

extension UIImage {
    func resized(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
}


