//
//  ManageViewcontroller.swift
//  Mainpage
//
//  Created by 두근두근 코딩타임 on 2023/08/02.
//

import UIKit
import Alamofire
import DGCharts

class ManageViewController: UIViewController {
    @IBOutlet weak var MonthSelectButton: UIButton!
    @IBOutlet weak var expenseTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var BarChart: BarChartView!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var completeImageView: UIImageView!
    @IBOutlet weak var unpaidButton: UIButton!
    @IBOutlet weak var unpaidImageView: UIImageView!
    
    var selectedMonth: Int = 0
    var currentExpense: Double = 0.0
    var paymentStatus: Bool = false
    
    
    
    let accessToken = UserDefaults.standard.string(forKey: "accessToken")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 월 선택 버튼 설정
        setMonthSelectButton()
        setChartData()
        
    }
    
    @IBAction func sendExpenseToServer(_ sender: UIButton) {
        guard let accessToken = accessToken,
              let expenseText = expenseTextField.text,
              let expense = Double(expenseText) else {
                    // 필요한 정보가 없거나 유효하지 않은 입력이 있을 때 처리
                    return
                }
           
           // 사용자가 선택한 월에 해당하는 관리비 정보를 가져오는 코드 (fetchDataFromAPI로 가져온 관리비 정보를 사용)
        guard let userFeeId = getUserFeeIdForSelectedMonth(selectedMonth) else {
               // 해당 월의 관리비 정보를 찾을 수 없을 때 처리
               return
            }
           
           // 서버로 보낼 데이터 설정
           let paymentCheck = paymentStatus // 납부 상태를 사용
           // 다른 관리비 정보를 전송해야 하는 경우에도 데이터 설정
           
           // updateExpenseToAPI 메서드 호출
           updateExpenseToAPI(with: accessToken, userFeeId: userFeeId, cost: expense, paymentCheck: paymentCheck)
       }
    
    @IBAction func updateExpense(_ sender: UIButton) {
        guard let expenseText = expenseTextField.text, let expense = Double(expenseText) else {
                    // 유효하지 않은 입력일 경우 처리 (예를 들어, 숫자가 아닌 문자열이 입력된 경우)
                    }
                    return
            currentExpense = expense
                    RefreshChart()
    }
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        paymentStatus = true
                RefreshChart()
                updateUIForPaymentStatus()
    }
    
    @IBAction func unpaidButtonTapped(_ sender: UIButton) {
        paymentStatus = false
                RefreshChart()
                updateUIForPaymentStatus()
    }
    
    @IBAction func BackToMain(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    func updateUIForPaymentStatus() {
                if paymentStatus {
                    completeImageView.image = UIImage(named: "checkmark.square")
                    unpaidImageView.image = UIImage(named: "rectangle")
                } else {
                    completeImageView.image = UIImage(named: "rectangle")
                    unpaidImageView.image = UIImage(named: "checkmark.square")
                }
            }
        
    func getUserFeeIdForSelectedMonth(_ selectedMonth: Int) -> Int? {
        // fetchDataFromAPI로 가져온 관리비 정보 배열을 가정합니다.
       
        //해당 함수는 Lambda 함수 처리를 통해 API response 가 Success 일 경우에 동작합니다.
        //참고하세여! to LJH from CazYHOLICS
        
        var outputValue : Int? = 0
        
        fetchDataFromAPI(for: selectedMonth) { responseData in
            let manageInfos: [ManageInfo] = responseData
            
            // 선택한 월에 해당하는 관리비 정보를 찾습니다.
            if let selectedInfo = manageInfos.first(where: { $0.feeMonth == selectedMonth }) {
                outputValue = selectedInfo.id // 선택한 월의 userFeeId 반환
            } else {
                outputValue = nil // 선택한 월에 해당하는 관리비 정보를 찾지 못한 경우 nil 반환
            }
        } // fetchDataFromAPI는 관리비 정보 배열을 반환하는 메서드
        
        return outputValue
    }
    func setChartData() {
               let data = BarChartData()
               BarChart.data = data
           }
    func parseManageInfoResponse(_ jsonData: Data) -> [ManageInfo] {
            do {
                let manageInfos = try JSONDecoder().decode([ManageInfo].self, from: jsonData)
                return manageInfos
            } catch {
                print("JSON 파싱 오류: \(error)")
                return []
            }
        }
    
    func fetchDataFromAPI(for month: Int, @escaping onSuccess : ([ManageInfo]) -> Void) {
        guard let accessToken = accessToken else {
            print("AccessToken이 없습니다.")
            return
        }

        // 현재 년도를 가져오기
        let currentDate = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: currentDate)

        // API 호출을 위한 URL 생성
        let apiURL = "https://hello-there.shop/user-fees/detail"

        // 파라미터 설정 (feeYear와 feeMonth)
        let parameters: [String: Any] = [
            "feeYear": year, // 현재 년도를 사용
            "feeMonth": month // 선택한 월을 설정
        ]

        // 헤더 설정 (Authorization 토큰)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]

        // Alamofire를 사용하여 GET 요청 보내기
        AF.request(apiURL, method: .get, parameters: parameters, headers: headers).responseJSON { [weak self] response in
            switch response.result {
            case .success(let data):
                // API 요청이 성공한 경우 데이터를 처리합니다.
                if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) {
                    // API 응답 데이터를 파싱하여 관리비 정보로 변환
                    if let manageInfos = self?.parseManageInfoResponse(jsonData) {
                        // 파싱된 데이터를 사용하여 UI를 업데이트합니다.
                        onSuccess(manageInfos)
                    }
                
                }
            case .failure(let error):
                // API 요청이 실패한 경우 에러를 처리합니다.
                print("API 요청 실패: \(error)")
            }
        }
    }


       // API 호출 메서드 - PATCH 요청
       func updateExpenseToAPI(with accessToken: String?, userFeeId: Int, cost: Double, paymentCheck: Bool) {
           guard let accessToken = accessToken else {
               print("AccessToken이 없습니다.")
               return
               
           }
           
           // API 호출을 위한 URL 생성
           let apiURL = "https://hello-there.shop/user-fees/\(userFeeId)"
           
           // Body에 보낼 파라미터 설정
           let parameters: [String: Any] = [
               "cost": cost,
               "paymentCheck": paymentCheck
           ]
           
           // 헤더 설정 (Authorization 토큰)
           let headers: HTTPHeaders = [
               "Authorization": "Bearer \(accessToken)"
           ]
           
           // Alamofire를 사용하여 PATCH 요청 보내기
           AF.request(apiURL, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { [weak self] response in
               switch response.result {
               case .success(let data):
                   // API 요청이 성공한 경우 데이터를 처리합니다.
                   if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) {
                       do {
                           // JSON 데이터를 파싱하여 업데이트된 관리비 정보로 변환
                           let updatedManageInfo = try JSONDecoder().decode(ManageInfo.self, from: jsonData)
                           
                           // 업데이트된 관리비 정보를 사용하여 UI를 업데이트합니다.
                           // 예시: self?.updateUI(with: updatedManageInfo)
                       } catch {
                           print("JSON 파싱 오류: \(error)")
                       }
                   }
               case .failure(let error):
                   // API 요청이 실패한 경우 에러를 처리합니다.
                   print("API 요청 실패: \(error)")
               }
           }
       }
    func setMonthSelectButton(){
        let optionClosure = { [weak self] (action: UIAction) in
                if action.title != "월 선택", let month = Int(action.title) {
                    self?.selectedMonth = month
                    print(action.title)
                    
                    // 월을 선택한 후 fetchDataFromAPI 메서드 호출
                    //자기 여기에 월 추가하래.. 근데 없어서 일단 주석 처리 했어
//                    self?.fetchDataFromAPI()
                    self?.RefreshChart()

                }
            }
                
        MonthSelectButton.menu = UIMenu(children : [
    UIAction(title: "월 선택", handler: optionClosure),
    UIAction(title : "1월", handler: optionClosure),
    UIAction(title : "2월", handler: optionClosure),
    UIAction(title : "3월", handler: optionClosure),
    UIAction(title : "4월", handler: optionClosure),
    UIAction(title : "5월", handler: optionClosure),
    UIAction(title : "6월", handler: optionClosure),
    UIAction(title : "7월", handler: optionClosure),
    UIAction(title : "8월", handler: optionClosure),
    UIAction(title : "9월", handler: optionClosure),
    UIAction(title : "10월", handler: optionClosure),
    UIAction(title : "11월", handler: optionClosure),
    UIAction(title : "12월", handler: optionClosure)])
    MonthSelectButton.showsMenuAsPrimaryAction = true
    MonthSelectButton.changesSelectionAsPrimaryAction = true
    }
    
    // 서버에서 데이터를 가져와서 차트를 업데이트합니다.
        func RefreshChart() {
            // 서버에서 관리비 데이터를 가져와서 해당 월과 이전 2개월의 데이터를 생성합니다.
            let currentMonth = Calendar.current.component(.month, from: Date())
            let selectedMonthIndex = currentMonth - 3 ..< currentMonth // 선택 월과 이전 2개월

            var entries = [BarChartDataEntry]()
            var maxYValue: Double = 0 // y축 최대 값 초기화

            for i in selectedMonthIndex {
                let yValue: Double
                if i == currentMonth - 1 {
                    // 선택 월의 경우 임시적으로 변경된 관리비를 사용합니다.
                    yValue = currentExpense
                } else {
                    yValue = Double.random(in: 0...100) // 임의의 관리비 데이터 (0부터 100 사이의 값)
                }
                maxYValue = max(maxYValue, yValue) // 최대 값 갱신

                entries.append(BarChartDataEntry(x: Double(i), y: yValue))
            }

            let dataSet = BarChartDataSet(entries: entries, label: "월별 데이터")
            dataSet.colors = [UIColor(red: 69/255, green: 207/255, blue: 148/255, alpha: 1.0)] // 그래프 색상 설정

            // 납부 여부에 따라 그래프 색상 변경
            if paymentStatus {
                dataSet.colors = [UIColor(red: 243/255, green: 72/255, blue: 34/255, alpha: 1.0)] // 미납인 경우 색상 변경
            } else {
                dataSet.colors = [UIColor(red: 69/255, green: 207/255, blue: 148/255, alpha: 1.0)] // 완납인 경우 색상 변경
            }

            dataSet.valueTextColor = UIColor.white // 값 텍스트 색상 설정

            let data = BarChartData(dataSet: dataSet)

            // x축 설정
            BarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: selectedMonthIndex.map { "\($0)월" }) // x축 레이블 포맷 설정

            // y축 설정
            BarChart.leftAxis.axisMinimum = 0 // y축 최소 값 설정
            BarChart.leftAxis.axisMaximum = maxYValue + 10 // y축 최대 값 설정 (최대 값보다 약간 높게 설정)

            BarChart.data = data
        }
    }
struct ManageInfo: Codable {
    let id: Int
    let feeYear: Int
    let feeMonth: Int
    let cost: Double
    let paymentCheck: Bool
}
