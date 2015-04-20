//
//  MovieCell.swift
//  SwiftFlicks
//
//  Created by Amie Kweon on 4/16/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = UIColor.flicksLightGrayColor()

        containerView.layer.cornerRadius = 3
        containerView.layer.borderColor = UIColor.flicksMediumGrayColor().CGColor
        containerView.layer.borderWidth = 1

        containerView.layer.shadowColor = UIColor.blackColor().CGColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowRadius = 3.0
        containerView.layer.shadowOffset = CGSizeMake(2.0, 2.0)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
