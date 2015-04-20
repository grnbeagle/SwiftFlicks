//
//  MovieDetailsViewController.swift
//  SwiftFlicks
//
//  Created by Amie Kweon on 4/17/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!

    var movie: Movie!

    let topPosition: CGFloat = 300

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = movie.title
        self.edgesForExtendedLayout = UIRectEdge.None

        if let thumbnailUrl = movie.posterMediumUrl {
            posterView.setImageWithURL(thumbnailUrl)
        }

        if let highResPosterUrl = movie.posterImageUrl {
            posterView.loadAsync(highResPosterUrl, animate: false, failure: nil)
        }

        var contentView = UIView(frame: CGRect(x: CGFloat(0), y: topPosition, width: view.frame.width, height: view.frame.height))
        contentView.backgroundColor = UIColor.blackColor()
        contentView.alpha = 0.75
        scrollView.addSubview(contentView)

        var contentWidth = view.frame.width - 30
        var titleLabel = UILabel(frame: CGRect(x: 15, y: 15, width: contentWidth, height: 20))
        titleLabel.text = movie.title!.uppercaseString
        titleLabel.textColor = UIColor.whiteColor()
        contentView.addSubview(titleLabel)

        var metaLabel = UILabel(frame: CGRect(x: 15, y: 45, width: contentWidth, height: 20))
        var ratingIcon = NSTextAttachment()
        ratingIcon.image = UIImage(named: movie.rating > 50 ? "Fresh" : "Rotten")
        var attachmentString = NSAttributedString(attachment: ratingIcon)

        var ratingString = NSMutableAttributedString(attributedString: attachmentString)
        var ratingTextString = NSAttributedString(string: " \(movie.rating!)% · \(movie.year!) · \(movie.mpaaRating!)")
        ratingString.appendAttributedString(ratingTextString)

        metaLabel.attributedText = ratingString
        metaLabel.textColor = UIColor.whiteColor()
        metaLabel.font = UIFont(name: metaLabel.font.fontName, size: 11)
        metaLabel.sizeToFit()
        contentView.addSubview(metaLabel)

        var contentLabel = UILabel(frame: CGRect(x: 15, y: 65, width: contentWidth, height: 20))
        contentLabel.textColor = UIColor.whiteColor()
        contentLabel.font = UIFont(name: contentLabel.font.fontName, size: 13)
        contentLabel.numberOfLines = 0

        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        var attrString = NSMutableAttributedString(string: movie.synopsis!)
        attrString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle,
            range: NSMakeRange(0, count(movie.synopsis!)))
        contentLabel.attributedText = attrString
        contentLabel.sizeToFit()
        contentView.addSubview(contentLabel)

        var navigationBarHeight = navigationController!.toolbar.frame.height
        var tabBarHeight = navigationController!.tabBarController?.tabBar.frame.height
        var statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height

        var scrollHeight = topPosition + contentView.frame.height - navigationBarHeight - tabBarHeight! - statusBarHeight
        scrollView.contentSize = CGSize(width: view.frame.width, height: scrollHeight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
