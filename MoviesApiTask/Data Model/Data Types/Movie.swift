//
//  Movie.swift
//  MoviesApiTask
//
//  Created by Alon Shlider on 25/04/2019.
//  Copyright © 2019 Alon Shlider. All rights reserved.
//

import Foundation

struct Movie : Codable {
    var title : String
    var image : String
    var rating : Float
    var releaseYear : Int
    var genre : [String]
    
    func description() -> String{
        return ("Title: \(title) \nImage URL: \(image) \nRating: \(rating) \nRelease Year: \(releaseYear) \nGenre: \(genre[0])")
    }
}
