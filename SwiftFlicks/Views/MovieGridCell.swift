//
//  MovieGridCell.swift
//  SwiftFlicks
//
//  Created by Amie Kweon on 4/19/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class MovieGridCell: UICollectionViewCell {
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var metaLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = UIColor.flicksLightGrayColor()

        containerView.backgroundColor = UIColor.whiteColor()
        containerView.layer.cornerRadius = 3
        containerView.layer.borderColor = UIColor.flicksMediumGrayColor().CGColor
        containerView.layer.borderWidth = 1

        containerView.layer.shadowColor = UIColor.blackColor().CGColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowRadius = 3.0
        containerView.layer.shadowOffset = CGSizeMake(2.0, 2.0)
    }

    func setMovie(movie: Movie) {
        // Try medium first, and if there's an error, load thumbnail
        posterView.loadAsync(movie.posterMediumUrl!, animate: true) { (request, response, error) -> Void in
            if self.posterView.image == nil {
                self.posterView.loadAsync(movie.posterThumbnailUrl!, failure: nil)
            }
        }

        titleLabel.text = movie.title

        var ratingIcon = NSTextAttachment()
        ratingIcon.image = UIImage(named: movie.rating > 50 ? "Fresh" : "Rotten")
        var attachmentString = NSAttributedString(attachment: ratingIcon)

        var ratingString = NSMutableAttributedString(attributedString: attachmentString)
        var ratingTextString = NSAttributedString(string: " \(movie.rating!)% · \(movie.year!) · \(movie.mpaaRating!)")
        ratingString.appendAttributedString(ratingTextString)

        metaLabel.attributedText = ratingString
        metaLabel.sizeToFit()
    }

    func setHighlighted(highlighted: Bool, animated: Bool) {
        if highlighted {
            containerView.backgroundColor = UIColor.flicksHighlightColor()
            titleLabel.textColor = UIColor.whiteColor()
            metaLabel.textColor = UIColor.whiteColor()
        } else {
            containerView.backgroundColor = UIColor.whiteColor()
            titleLabel.textColor = UIColor.blackColor()
            metaLabel.textColor = UIColor.blackColor()
        }
        self.setNeedsDisplay()
    }
}
