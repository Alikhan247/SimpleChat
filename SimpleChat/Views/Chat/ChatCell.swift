//
//  ChatCell.swift
//  SimpleChat
//
//  Created by Alikhan Nursapayev on 4/13/20.
//  Copyright © 2020 Alikhan Nursapayev. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
