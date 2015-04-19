//
//  Movie.swift
//  SwiftFlicks
//
//  Created by Amie Kweon on 4/18/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import Foundation

class Movie {

    var title: String?
    var synopsis: String?
    var posterThumbnailUrl: NSURL?
    var postImageUrl: NSURL?

    init() {

    }

    convenience init(dictionary: NSDictionary) {
        self.init()

        title = dictionary["title"] as? String
        synopsis = dictionary["synopsis"] as? String

        var thumbnailUrlString = dictionary.valueForKeyPath("posters.detailed") as? String

        if let thumbnailUrlString = thumbnailUrlString {
            posterThumbnailUrl = NSURL(string: thumbnailUrlString)

            // Workaround to getting high res poster image
            var posterUrlString = thumbnailUrlString.stringByReplacingOccurrencesOfString("tmb", withString: "ori")
            var range = posterUrlString.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
            if let range = range {
                posterUrlString = posterUrlString.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
            }
            println(posterUrlString)
            postImageUrl = NSURL(string: posterUrlString)
        }
    }

    class func moviesWithArray(array: [NSDictionary]) -> [Movie]{
        var movies: [Movie] = []
        for item in array {
            movies.append(Movie(dictionary: item))
        }
        return movies
    }
}