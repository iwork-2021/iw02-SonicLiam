//
//  TodoTableViewCell.swift
//  MyToDo
//
//  Created by Liam on 2021/10/31.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var state: UILabel!
}
