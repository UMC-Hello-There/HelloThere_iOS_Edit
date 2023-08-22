//
//  SearchingPostsCell.swift
//  Mainpage
//
//  Created by 두근두근 코딩타임 on 2023/08/11.
//

import UIKit

class SearchingPostsCell: UITableViewCell {

    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Contents: UILabel!
    @IBOutlet weak var UploadedTime: UILabel!
    @IBOutlet weak var View: UILabel!
    @IBOutlet weak var CategoryId: UILabel!
    @IBOutlet weak var Comments: UILabel!
    @IBOutlet weak var Good: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
