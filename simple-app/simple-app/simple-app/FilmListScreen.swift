//
//  FilmListScreen.swift
//  simple-app
//
//  Created by Binh Van Nguyen on 11/19/18.
//  Copyright © 2018 Binh Van Nguyen. All rights reserved.
//

import UIKit

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
        let film2 = Film(image: #imageLiteral(resourceName: "img2"), title: "Pic 2")
        filmsTemp.append(film1)
        filmsTemp.append(film2)
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
        
        print(cell)
        
        cell.setFilm(film: film)
        
        return cell
    }
}
