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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!

    var movie: Movie!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = movie.title
        synopsisLabel.text = movie.synopsis
        posterView.setImageWithURL(movie.posterThumbnailUrl)

        if let highResPosterUrl = movie.postImageUrl {
            posterView.loadAsync(highResPosterUrl, animate: false)
        }
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
