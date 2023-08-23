//
//  BoardMainViewController.swift
//  HelloThere_iOS
//
//  Created by 서보현 on 2023/08/08.
//

import UIKit

class BoardMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    @IBOutlet weak var tv: UITableView!
    
    
    let data = ["자유 소통 게시판", "갈등 소통 게시판", "정보 공유 게시판", "공구 나눔 게시판", "중고 장터 게시판", "질문 게시판", "나만의 홈테리어"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tv.delegate = self
        tv.dataSource = self
        
        swipeRecognizer()
    }
    
    func swipeRecognizer() {
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            self.view.addGestureRecognizer(swipeRight)
            
        }
        
        @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                switch swipeGesture.direction{
                case UISwipeGestureRecognizer.Direction.right:
                    // 스와이프 시, 원하는 기능 구현.
                    self.dismiss(animated: true, completion: nil)
                default: break
                }
            }
        }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        
        cell.detailTextLabel?.text = nil
        
        return cell
        
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
            case 0: self.performSegue(withIdentifier: "showFree", sender: nil)
            case 1: self.performSegue(withIdentifier: "showComplain", sender: nil)
            case 2: self.performSegue(withIdentifier: "showInfo", sender: nil)
            case 3: self.performSegue(withIdentifier: "showShare", sender: nil)
            case 4: self.performSegue(withIdentifier: "showShop", sender:  nil)
            case 5: self.performSegue(withIdentifier: "showQnA", sender: nil)
            case 6: self.performSegue(withIdentifier: "showMyHome", sender: nil)
             
            default:
                return

        }
    }
    




}
    

