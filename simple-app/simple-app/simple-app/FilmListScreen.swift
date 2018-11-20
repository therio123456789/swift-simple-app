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
    
    @IBOutlet weak var filmTable: UITableView!
    var films: [Film] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        films = createArray()
    }
    
    func createArray() -> [Film] {
        var filmsTemp: [Film] = []
        let film1 = Film(image: #imageLiteral(resourceName: "img1"), title: "Pic 1")
        filmsTemp.append(film1)
        return filmsTemp
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
