//
//  MoviesViewController.swift
//  SwiftFlicks
//
//  Created by Amie Kweon on 4/14/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

enum ViewMode {
    case Movie
    case DVD
}

class MoviesViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var announcementView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!

    let apiMoviesUrlString = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us"
    let apiDVDUrlString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us"

    var movies: [Movie]?
    var searchResult: [Movie]?
    var viewMode: ViewMode = .Movie

    var apiUrlString: String {
        get {
            return viewMode == .Movie ? apiMoviesUrlString : apiDVDUrlString
        }
    }

    var screenTitle: String {
        get {
            return viewMode == .Movie ? "Movies" : "DVD"
        }
    }

    var refreshControl = UIRefreshControl()
    var viewToggleButton: UIBarButtonItem?
    var isSearch = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = screenTitle
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        announcementView.hidden = true

        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.flicksLightGrayColor()
        tableView.separatorColor = UIColor.flicksLightGrayColor()
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.hidden = false

        collectionView.dataSource = self
        collectionView.hidden = true

        searchBar.delegate = self

        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)

//        var viewToggleView = UIButton(frame: CGRectMake(0, 0, 30, 30))
//        viewToggleView.addTarget(self, action: "toggleView", forControlEvents: UIControlEvents.TouchUpInside)
//        viewToggleView.setBackgroundImage(UIImage(named: "Grid"), forState: UIControlState.Normal)
//        viewToggleView.tintColor = UIColor.whiteColor()
//        viewToggleButton = UIBarButtonItem(customView: viewToggleView)

        viewToggleButton = UIBarButtonItem(image: UIImage(named: "Grid"), style: UIBarButtonItemStyle.Plain, target: self, action: "toggleView")
        self.navigationItem.rightBarButtonItem = viewToggleButton

        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchBar.resignFirstResponder()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - UISearchBarDelegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        isSearch = !searchBar.text.isEmpty
        if isSearch {
            let results = movies?.filter({ (movie) -> Bool in
                return movie.title?.lowercaseString.rangeOfString(searchBar.text.lowercaseString) != nil
            })

            searchResult = results
        } else {
            searchResult = []
        }
        tableView.reloadData()
    }

    func fetchData() {
        let url = NSURL(string: apiUrlString)!
        let request = NSURLRequest(URL: url)

        MBProgressHUD.showHUDAddedTo(view, animated: true)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) ->
            Void in
            if self.view == nil {
                return
            }
            if (error != nil) {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.announcementView.hidden = false
            } else {
                let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                if let json = json {
                    let movies = json["movies"] as? [NSDictionary]
                    if let movies = movies {
                        self.movies = Movie.moviesWithArray(movies)
                        self.tableView.reloadData()
                        self.collectionView.reloadData()
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                    }
                }
            }
        }
    }

    func refresh() {
        fetchData()
        refreshControl.endRefreshing()
    }

    func toggleView() {
        
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

extension MoviesViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            if let searchResult = searchResult {
                return searchResult.count
            }
        } else if let movies = movies {
            return movies.count
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell

        let movie = isSearch ? searchResult![indexPath.row] : movies![indexPath.row]
        cell.titleLabel.text = movie.title
        cell.synopsisLabel.text = movie.synopsis
        cell.posterView.loadAsync(movie.posterThumbnailUrl!)
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
    }
}

extension MoviesViewController : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearch {
            if let searchResult = searchResult {
                return searchResult.count
            }
        } else if let movies = movies {
            return movies.count
        }
        return 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieGridCell", forIndexPath: indexPath) as! MovieGridCell
        let movie = isSearch ? searchResult![indexPath.row] : movies![indexPath.row]
        cell.posterView.loadAsync(movie.posterThumbnailUrl!)
        cell.titleLabel.text = movie.title
        return cell
    }
}

extension MoviesViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
