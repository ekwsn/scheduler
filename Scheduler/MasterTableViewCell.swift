//
//  MasterTableViewCell.swift
//  Scheduler
//
//  Created by Lok on 01/09/2015.
//  Copyright (c) 2015 Lok. All rights reserved.
//

import UIKit

class MasterTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var inviteesLabel: UILabel!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var hostLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
