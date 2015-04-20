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
    @IBOutlet weak var metaLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = UIColor.flicksLightGrayColor()
        containerView.backgroundColor = UIColor.whiteColor()

        containerView.layer.cornerRadius = 3
        containerView.layer.borderColor = UIColor.flicksMediumGrayColor().CGColor
        containerView.layer.borderWidth = 1

        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setMovie(movie: Movie) {
        titleLabel.text = movie.title
        synopsisLabel.text = movie.synopsis
        posterView.image = nil

        // Try medium first, and if there's an error, load thumbnail
        posterView.loadAsync(movie.posterMediumUrl!, animate: true) { (request, response, error) -> Void in
            if self.posterView.image == nil {
                self.posterView.loadAsync(movie.posterThumbnailUrl!, failure: nil)
            }
        }

        var ratingIcon = NSTextAttachment()
        ratingIcon.image = UIImage(named: movie.rating > 50 ? "Fresh" : "Rotten")
        var attachmentString = NSAttributedString(attachment: ratingIcon)

        var ratingString = NSMutableAttributedString(attributedString: attachmentString)
        var ratingTextString = NSAttributedString(string: " \(movie.rating!)% · \(movie.year!) · \(movie.mpaaRating!)")
        ratingString.appendAttributedString(ratingTextString)

        metaLabel.attributedText = ratingString
        metaLabel.sizeToFit()
    }

    override func setHighlighted(highlighted: Bool, animated: Bool) {
        if highlighted {
            containerView.backgroundColor = UIColor.flicksHighlightColor()
            titleLabel.textColor = UIColor.whiteColor()
            metaLabel.textColor = UIColor.whiteColor()
            synopsisLabel.textColor = UIColor.whiteColor()
        } else {
            containerView.backgroundColor = UIColor.whiteColor()
            titleLabel.textColor = UIColor.blackColor()
            metaLabel.textColor = UIColor.blackColor()
            synopsisLabel.textColor = UIColor.blackColor()
        }
    }



}
