//
//  MessageManager.swift
//  HelloThere_iOS
//
//  Created by 우주대스타 on 2023-08-11.
//

import Foundation
import UIKit

final class Manager:UIViewController
{
    
    func MessageManager(text: String){
        let sheet = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "확인", style: .default))
        present(sheet, animated: true)
    }
}
