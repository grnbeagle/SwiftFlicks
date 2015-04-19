//
//  MoviesViewController.swift
//  SwiftFlicks
//
//  Created by Amie Kweon on 4/14/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var announcementView: UIView!

    var movies: [Movie]?
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        announcementView.hidden = true

        let urlString = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us"
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)

        MBProgressHUD.showHUDAddedTo(view, animated: true)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) ->
            Void in
            if self.view == nil {
                return
            }
            if (error != nil) {
                // show announcement view
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.announcementView.hidden = false
            } else {
                let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                if let json = json {
                    let movies = json["movies"] as? [NSDictionary]
                    if let movies = movies {
                        self.movies = Movie.moviesWithArray(movies)
                        self.tableView.reloadData()
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                    }
                }
            }
        }
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell

        let movie = movies![indexPath.row]
        cell.titleLabel.text = movie.title
        cell.synopsisLabel.text = movie.synopsis
        cell.posterView.loadAsync(movie.posterThumbnailUrl!)

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        let movie = movies![indexPath.row]

        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        movieDetailsViewController.movie = movie
    }

}
