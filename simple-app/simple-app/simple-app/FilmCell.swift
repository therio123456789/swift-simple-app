//
//  FilmCell.swift
//  simple-app
//
//  Created by Binh Van Nguyen on 11/19/18.
//  Copyright © 2018 Binh Van Nguyen. All rights reserved.
//

import UIKit

class FilmCell: UITableViewCell{

    @IBOutlet weak var filmTittleLabel: UILabel!
    @IBOutlet weak var filmImage: UIImageView!
    @IBOutlet weak var filmOverviewLabel: UILabel!
    
    func setFilm(film: Film) {
        filmImage.image = film.image
        filmTittleLabel.text = film.title
        filmOverviewLabel.text = film.overview
    }
}
