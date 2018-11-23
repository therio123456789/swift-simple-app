//
//  FilmCell.swift
//  simple-app
//
//  Created by Binh Van Nguyen on 11/19/18.
//  Copyright © 2018 Binh Van Nguyen. All rights reserved.
//

import UIKit
import QuartzCore

class FilmCell: UITableViewCell{

    @IBOutlet weak var filmTittleLabel: UILabel!
    @IBOutlet weak var filmImage: UIImageView!
    @IBOutlet weak var filmOverviewLabel: UILabel!
    
    func setFilm(film: Film) {
        let rawImage: UIImage = Film.getImage(film.imageUrl)!
        filmImage.image = rawImage
        filmImage.makeRounded()
        filmTittleLabel.text = film.title
        filmOverviewLabel.text = film.overview
    }
}
extension UIImageView {
    func makeRounded() {
        let radius = self.frame.width/2.0
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
