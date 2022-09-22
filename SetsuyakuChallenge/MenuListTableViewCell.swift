//
//  MenuListTableViewCell.swift
//  SetsuyakuChallenge
//
//  Created by Johnny Toda on 2022/09/22.
//

import UIKit

final class MenuListTableViewCell: UITableViewCell {
    @IBOutlet private weak var titileLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
