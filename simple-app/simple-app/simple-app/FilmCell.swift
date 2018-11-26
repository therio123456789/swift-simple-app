//
//  FilmCell.swift
//  simple-app
//
//  Created by Binh Van Nguyen on 11/19/18.
//  Copyright © 2018 Binh Van Nguyen. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire
import AlamofireImage

class FilmCell: UITableViewCell{
    
    @IBOutlet weak var filmTittleLabel: UILabel!
    @IBOutlet weak var filmPoster: UIImageView!
    @IBOutlet weak var filmOverviewLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    let FAVOURITE_ICON_ACTIVE = "icon_star_active"
    let FAVOURITE_ICON_INACTIVE = "icon_star_inactive"
    let ACTIVE_COLOR = UIColor(red:0.95, green:0.71, blue:0.00, alpha:1.0)
    let INACTIVE_COLOR = UIColor(red:0.44, green:0.44, blue:0.44, alpha:1.0)
    
    var film: Film?
    
    func setFilm(film: Film) {
        self.film = film
        setupFavouriteButton(button: favouriteButton, isActive: film.isFavourite())
        loadImage(imageView: filmPoster, imageUrl: film.posterImageUrl)
        roundImageView(imageView: filmPoster)
        filmTittleLabel.text = film.title
        filmOverviewLabel.text = film.overview
    }
    
    fileprivate func setupFavouriteButton(button: UIButton,isActive: Bool) {
        setFavouriteButtonIcon(button: favouriteButton, isActive: self.film!.isFavourite())
        favouriteButton.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
    }
    
    fileprivate func setFavouriteButtonIcon(button: UIButton,isActive: Bool) {
        if isActive {
            self.favouriteButton.setImage(UIImage(imageLiteralResourceName: FAVOURITE_ICON_ACTIVE), for: .normal)
            self.favouriteButton.tintColor = ACTIVE_COLOR
        } else {
            self.favouriteButton.setImage(UIImage(imageLiteralResourceName: FAVOURITE_ICON_INACTIVE), for: .normal)
            self.favouriteButton.tintColor = INACTIVE_COLOR
        }
    }
    
    @objc func handleMarkAsFavorite() {
        self.film!.setFavourite(favourite: !self.film!.isFavourite())
        setFavouriteButtonIcon(button: favouriteButton, isActive: self.film!.isFavourite())
    }
    
    fileprivate func loadImage(imageView: UIImageView, imageUrl: String) {
        Alamofire.request(imageUrl).responseImage {
            response in
            if let image = response.result.value {
                imageView.image = image
            }
        }
    }
    
    private func roundImageView(imageView: UIImageView) {
        imageView.makeRounded()
    }
}

extension UIImageView {
    func makeRounded() {
        let radius = self.frame.width/2.0
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
