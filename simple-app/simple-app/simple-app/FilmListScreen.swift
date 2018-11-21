//
//  FilmListScreen.swift
//  simple-app
//
//  Created by Binh Van Nguyen on 11/19/18.
//  Copyright © 2018 Binh Van Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class FilmListScreen: UIViewController {
    
    let URL_GET_DATA = "http://www.mocky.io/v2/5bf3bce23100002c00619909"
    
    let HOST_IMAGE = "http://image.tmdb.org/t/p/w500"
    
    @IBOutlet weak var filmTable: UITableView!
    var films = [Film]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDataCompletion(completion: {
            (filmsTemp) in
            self.films = filmsTemp
            self.filmTable.reloadData()
        })
    }
    
    func createDataCompletion(completion:@escaping (_ filmsTemp: [Film]) ->()) {
        var filmsTemp = [Film]()
        Alamofire.request(URL_GET_DATA).responseJSON { response in
            switch(response.result) {
            case .success(_):
                if let json = response.result.value {
                    filmsTemp = self.getFilmArray(json)
                }
                completion(filmsTemp)
                break
            case .failure(_):
                completion(filmsTemp)
                break;
            }
        }
    }
    
    fileprivate func getImage(_ imageUrl: String) -> UIImage? {
        if let url = URL(string: imageUrl) {
            do {
                let data = try Data(contentsOf: url)
                return UIImage(data: data)
            } catch let err {
                print("Error: \(err.localizedDescription)")
            }
        }
        return UIImage()
    }
    
    fileprivate func createFilmArray(_ data: Data) -> [Film] {
        var filmsTemp = [Film]()
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
            {
                for i in 0..<jsonArray.count {
                    let film = self.getFilmObject(jsonArray, i)
                    filmsTemp.append(film)
                }
            } else {
                print("Bad Json")
            }
        } catch let error as NSError {
            print(error)
        }
        return filmsTemp
    }
    
    fileprivate func getFilmArray(_ json: Any) -> [Film] {
        let data = "\(json)".data(using: .utf8)!
        return createFilmArray(data)
    }
    
    fileprivate func getFilmObject(_ jsonArray: [[String : Any]], _ i: Int) -> Film {
        let filmData = jsonArray[i]
        let filmTitle: String = "\(String(describing: filmData["title"]!))"
        let filmUrl: String = self.HOST_IMAGE+"\(String(describing: filmData["poster_path"]!))"
        return Film(image: self.getImage(filmUrl)!, title: filmTitle)
    }
    
}

extension FilmListScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let film = films[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCell") as! FilmCell
        
        cell.setFilm(film: film)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
}
