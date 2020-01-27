//
//  FactTableViewCell.swift
//  iOSProject
//
//  Created by SINCY on 27/01/20.
//  Copyright © 2020 SINCY. All rights reserved.
//

import UIKit

class FactCell: UITableViewCell {
    
    static let reuseIdentifier = "FactCell"
    
    @IBOutlet weak var factImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        factImageView?.accessibilityIdentifier = "factImageView"
        titleLabel?.accessibilityIdentifier = "titleLabel"
        descLabel?.accessibilityIdentifier = "descLabel"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
