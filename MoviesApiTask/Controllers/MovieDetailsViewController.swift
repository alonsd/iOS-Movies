//
//  MovieDetailsViewController.swift
//  MoviesApiTask
//
//  Created by Alon Shlider on 30/04/2019.
//  Copyright © 2019 Alon Shlider. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieReleaseYear: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    var selectedMovie : Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(selectedMovie.description())
        setLabels()
    }
    
    func setLabels(){
        movieTitle.text = "Title: \(selectedMovie.title)"
        movieGenre.text = "Genre: \(selectedMovie.genre[0])"
        movieRating.text = "Rating: \(String(selectedMovie.rating))"
        movieReleaseYear.text = "Release Year: \(String(selectedMovie.releaseYear))"
        movieImage.downloaded(from: selectedMovie.image)
    }

}
