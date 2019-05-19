//
//  ViewController.swift
//  MoviesApiTask
//
//  Created by Alon Shlider on 23/04/2019.
//  Copyright © 2019 Alon Shlider. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD

class MoviesViewController: UITableViewController {
    
    let base_url = "https://api.androidhive.info/json/movies.json"
    let context = PersistanceService.context
    var moviesArray = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9469962326, blue: 0.4312847056, alpha: 1)
        if loadData(){
            print("loading items from local presistancy")
        } else {
            print("fetching new data from api")
            dataFetchFromMoviesApi()
        }
        tableView.estimatedRowHeight = 180
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
    }
    
    
    
    //MARK: - TableView Delegate Method
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showMovieDetails", sender: moviesArray[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = moviesArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! TableViewCell
        cell.title.text = "Title: \(movie.title)"
        cell.rating.text = "Rating: \(String(movie.rating))"
        cell.releaseYear.text = "Release Year: \(String(movie.releaseYear))"
        cell.genre.text = "Genre: \(String(movie.genre[0]))"
        cell.movieImage.downloaded(from: movie.image)
        
        cell.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray.count
    }
    
    //MARK: - Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetails" {
            let movieVC = segue.destination as! MovieDetailsViewController
            movieVC.selectedMovie = sender as? Movie
        }
    }
    
    
    
    //MARK: - Data Fetching Method
    
    func dataFetchFromMoviesApi(){
        httpRequest(urlForRequest: base_url) { [weak self] (data: Data?, error: Error?) in
            if error == nil { //no error - continue
                if let moviesData = data { //un-wrapping the data object
                    let decoder = JSONDecoder()
                    do {
                        let responseArray = try decoder.decode([Movie].self, from: moviesData)
                        //print(responseArray)
                        DispatchQueue.main.async {
                            self?.moviesArray = responseArray
                            self?.moviesArray.sort(by: {$0.releaseYear > $1.releaseYear})
                            
                            for movie in self!.moviesArray {
                                let movieModel = MovieModel(context: self!.context)
                                movieModel.title = movie.title
                                movieModel.releaseYear = String(movie.releaseYear)
                                movieModel.rating = String(movie.rating)
                                movieModel.genre = movie.genre[0]
                                movieModel.image = movie.image
                            }
                            PersistanceService.saveContext()
                            self?.tableView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                }
            } else {
                //error fetching data
                print(error?.localizedDescription ?? "error with no description")
            }
        }
    }
    
    //MARK: - Http Request
    
    private func httpRequest(urlForRequest: String, completion: @escaping (Data?, Error?) -> Void){
        guard let url = URL(string: urlForRequest) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data: Data?, urlResponse: URLResponse?, error: Error?) in
            if error == nil {
                //task was succfull
                completion(data, nil)
            } else {
                //task was unsuccessfull
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func saveData(){
        do {
            try context.save()
        } catch {
            print("error saving context, \(error.localizedDescription)")
        }
    }
    
    func loadData() ->Bool{
        let fetchRequest: NSFetchRequest<MovieModel> = MovieModel.fetchRequest()
        do {
            let movies = try PersistanceService.context.fetch(fetchRequest)
            print(movies.count)
            if movies.count == 0 {return false}
            for movie in movies {
                let title = movie.title!
                let rating = Float(movie.rating!)!
                let image = movie.image!
                let genre = [movie.genre!]
                let releaseYear = Int(movie.releaseYear!)!
                let newMovie = Movie(title: title, image: image, rating: rating, releaseYear: releaseYear, genre: genre)
                self.moviesArray.append(newMovie)
//                print("movies array count: \(moviesArray.count)")
//                print("successfully loaded items")
            }
            moviesArray.sort(by: {$0.releaseYear > $1.releaseYear})
            SVProgressHUD.dismiss()
            return true

        } catch {
            print("error fetching from core data, \(error)")
            return false
        }
    }
}







