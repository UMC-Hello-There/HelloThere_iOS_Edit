//
//  NewPostsCell.swift
//  Mainpage
//
//  Created by 두근두근 코딩타임 on 2023/08/18.
//

import UIKit

class NewPostsCell: UITableViewCell {

    @IBOutlet weak var Body: UILabel!
    @IBOutlet weak var Category: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
