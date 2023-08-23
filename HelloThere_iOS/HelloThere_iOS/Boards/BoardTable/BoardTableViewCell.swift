//
//  BoardTableViewCell.swift
//  HelloThere_iOS
//
//  Created by 서보현 on 2023/08/09.
//

import UIKit

class BoardTableViewCell: UITableViewCell {
    
    static let identifier = "BoardTableViewCell"

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblNumCom: UILabel!
    @IBOutlet weak var lblNumGood: UILabel!
    
    @IBOutlet weak var lblContent: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblNumWatch: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    
    
    static func nib() -> UINib {
           return UINib(nibName: "BoardTableViewCell", bundle: nil)
       }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
