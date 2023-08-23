//
//  ChatTabViewController.swift
//  HelloThere_iOS
//
//  Created by 서보현 on 2023/07/23.
//

import UIKit

class ChatTabViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chattingList: UITableView!
    
    @IBOutlet weak var chattingName: UILabel!
    @IBOutlet weak var chattingPreview: UILabel!
    @IBOutlet weak var chattingLastTime: UILabel!
    
    @IBOutlet weak var prototype: UITableView!
    
    let chattingRoomNameList = ["테스트 채팅방1", "테스트 채팅방1"]
    let time = ["오후 2:42", "오후 2:51"]
    let content = ["테스트용입니다", "테스트용입니다"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chattingList.delegate = self
        chattingList.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = chattingList(
////        cell.textLabel?.text = data[indexPath.section][indexPath.row]
////        return cell
        let cell = chattingList.dequeueReusableCell(withIdentifier: "chattingCell", for: indexPath)
//        cell.chattingName.text = chattingRoomNameList[indexPath.row]
//        cell.chattingPreview.text = time[indexPath.row]
//        cell.chattingLastTime.text = content[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.row {

        case 0:
            let nextStoryBoard = UIStoryboard(name: "ChatList", bundle: nil)
            let nextViewController = nextStoryBoard.instantiateViewController(identifier: "ChatList")
            nextViewController.modalPresentationStyle = .fullScreen
            present(nextViewController, animated:true, completion: nil)
//            self.performSegue(withIdentifier: "ChatList", sender: nil)

        default:
            return

        }

    }


}

