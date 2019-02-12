//
//  MoviesViewController.swift
//  flix2.0
//
//  Created by Matthew Rodriguez on 2/11/19.
//  Copyright © 2019 Matthew Rodriguez. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var movies = [[String: Any]]()
    //var movies2: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         Recipe for adding a tableView:
         1) connect tableView outlet
         2) Add UITableViewDataSource, UITableViewDelegate
         3) tableView.dataSource = self
            tableView.delegate = self
         4) self.tableView.reloadData()
         */
        
        tableView.dataSource = self // these 2 enable the protocol functions to be called
        tableView.delegate = self
        tableView.rowHeight = 180 // set to cell height if not using autolayout
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.movies = dataDictionary["results"] as! [[String: Any]] // Casting
                self.tableView.reloadData()
                print(dataDictionary)
                
            }
        }
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell // recycles cells off-screen
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        cell.synopsisLabel.sizeToFit() // vertically align text
        
        let baseUrl = "https://image.tmdb.org/t/p/w300"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        // iOS has no default way to download images, so we need a 3rd party library (AlamofireImage)
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
