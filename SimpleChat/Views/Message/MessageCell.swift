//
//  MessageCell.swift
//  SimpleChat
//
//  Created by Alikhan Nursapayev on 4/13/20.
//  Copyright © 2020 Alikhan Nursapayev. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var bubble: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bubble.layer.cornerRadius = bubble.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
