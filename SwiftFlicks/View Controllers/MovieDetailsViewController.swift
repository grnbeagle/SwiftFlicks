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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = movie.title

        posterView.setImageWithURL(movie.posterThumbnailUrl)

        if let highResPosterUrl = movie.postImageUrl {
            posterView.loadAsync(highResPosterUrl, animate: false)
        }

        var topPosition: CGFloat = 350
        var contentView = UIView(frame: CGRect(x: CGFloat(0), y: topPosition, width: view.frame.width, height: view.frame.height))
        contentView.backgroundColor = UIColor.blackColor()
        contentView.alpha = 0.75
        scrollView.addSubview(contentView)

        var contentLabel = UILabel(frame: CGRect(x: 15, y: 15, width: 290, height: 20))
        contentLabel.text = movie.synopsis
        contentLabel.textColor = UIColor.whiteColor()
        contentLabel.numberOfLines = 0
        contentLabel.sizeToFit()

        contentView.addSubview(contentLabel)

        var scrollHeight = topPosition + contentView.frame.height - navigationController!.toolbar.frame.height
        scrollView.contentSize = CGSize(width: 320, height: scrollHeight)

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
