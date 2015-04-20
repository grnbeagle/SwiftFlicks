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

enum DisplayMode {
    case Listing
    case Grid
}

class MoviesViewController: UIViewController, UITableViewDelegate, UICollectionViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var announcementView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!

    let apiMoviesUrlString = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us"
    let apiDVDUrlString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us"
    var displayModeListIcon: UIImage?
    var displayModeGridIcon: UIImage?

    var movies: [Movie]?
    var searchResult: [Movie]?
    var viewMode: ViewMode = .Movie
    var displayMode: DisplayMode = .Listing

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
    var refreshControlGrid = UIRefreshControl()
    var viewToggleButton: UIBarButtonItem?
    var isSearch = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = screenTitle
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        displayModeListIcon = UIImage(named: "List")
        displayModeGridIcon = UIImage(named: "Grid")

        announcementView.hidden = true

        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.flicksLightGrayColor()
        tableView.separatorColor = UIColor.flicksLightGrayColor()
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.flicksLightGrayColor()

        searchBar.delegate = self

        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)

        refreshControlGrid.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refreshControlGrid)

        viewToggleButton = UIBarButtonItem(image: displayModeGridIcon, style: UIBarButtonItemStyle.Plain, target: self, action: "toggleDisplayMode")
        self.navigationItem.rightBarButtonItem = viewToggleButton

        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                self.searchBar.hidden = true
            } else {
                let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                self.searchBar.hidden = false
                if let json = json {
                    let movies = json["movies"] as? [NSDictionary]
                    if let movies = movies {
                        self.movies = Movie.moviesWithArray(movies)
                        self.updateCollectionViews()
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                    }
                }
            }
        }
    }

    func refresh() {
        fetchData()
        refreshControl.endRefreshing()
        refreshControlGrid.endRefreshing()
    }

    func toggleDisplayMode() {
        displayMode = displayMode == .Listing ? .Grid : .Listing
        updateCollectionViews()
    }

    func updateCollectionViews() {
        if displayMode == .Listing {
            collectionView.hidden = true
            viewToggleButton!.image = displayModeGridIcon
            self.tableView.reloadData()
        } else {
            collectionView.hidden = false
            viewToggleButton!.image = displayModeListIcon
            self.collectionView.reloadData()
        }
        tableView.hidden = !collectionView.hidden
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var movie: Movie
        if displayMode == .Listing {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)!
            movie = movies![indexPath.row]
        } else {
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPathForCell(cell)!
            movie = movies![indexPath.row]
        }
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        movieDetailsViewController.movie = movie
    }

    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchBar.resignFirstResponder()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        performSegueWithIdentifier("detailSegue", sender: cell)
    }
}

extension MoviesViewController: UISearchBarDelegate {
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
        if displayMode == .Listing {
            tableView.reloadData()
        } else {
            collectionView.reloadData()
        }
    }
}

extension MoviesViewController: UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = isSearch ? searchResult![indexPath.row] : movies![indexPath.row]
        cell.setMovie(movie)
        return cell
    }
}

extension MoviesViewController: UICollectionViewDataSource {
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieGridCell", forIndexPath: indexPath) as! MovieGridCell
        let movie = isSearch ? searchResult![indexPath.row] : movies![indexPath.row]
        cell.setMovie(movie)
        return cell
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2 - 15, height: 230)
    }
}

