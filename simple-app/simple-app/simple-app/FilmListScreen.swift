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
import SwiftGifOrigin

class FilmListScreen: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    let LOADING_ASSET_NAME = "loading"
    
    let URL_GET_DATA = "http://www.mocky.io/v2/5bf3bce23100002c00619909"
    
    let HOST_IMAGE = "http://image.tmdb.org/t/p/w500"
    
    let CELL_IDENTIFIER = "FilmCell"
    
    let CELL_HEADER_TITLE_FONT = "Time New Roman"
    
    let HEIGHT_FOR_ROW: CGFloat = 125
    
    let HEIGHT_FOR_SECTION_HEADER: CGFloat = 20
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingImage: UIImageView!
    @IBOutlet weak var filmTable: UITableView!
    
    var films = [Film]()
    var filmGroup: [String: [Film]] = [:]
    var groupTitles: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareForData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            (self.filmGroup, self.groupTitles) = self.getGroupFilm(films: self.films)
            self.filmTable.reloadData()
            return
        }
        let currentFilm = films.filter { (film) -> Bool in
            film.title.lowercased().contains(searchText.lowercased())
        }
        
        (self.filmGroup, self.groupTitles) = self.getGroupFilm(films: currentFilm)
        self.filmTable.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            (self.filmGroup, self.groupTitles) = self.getGroupFilm(films: films)
            self.filmTable.reloadData()
        case 1:
            let currentFilm = films.filter { (film) ->
                Bool in
                film.isFavourite()
            }
            (self.filmGroup, self.groupTitles) = self.getGroupFilm(films: currentFilm)
            self.filmTable.reloadData()
        default:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tableBound = self.filmTable.bounds
        let searchBarFrame = self.searchBar.frame
        
        self.searchBar.frame = CGRect(x: tableBound.origin.x, y: tableBound.origin.y, width: searchBarFrame.size.width, height: searchBarFrame.size.height)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (filmGroup[groupTitles[section]]?.count)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filmGroup.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return groupTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groupTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as? UITableViewHeaderFooterView
        headerView?.textLabel?.font = UIFont(name: CELL_HEADER_TITLE_FONT, size: 20)
        headerView?.textLabel?.textColor = UIColor.darkGray
        headerView?.textLabel?.textAlignment = NSTextAlignment.right
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEIGHT_FOR_SECTION_HEADER
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let film = filmGroup[groupTitles[indexPath.section]]![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER) as! FilmCell
        
        cell.setFilm(film: film)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HEIGHT_FOR_ROW
    }
    
    fileprivate func prepareForData() {
        filmTable.isHidden = true
        loadingImage.isHidden = false
        self.loadingImage.image = UIImage.gif(asset: LOADING_ASSET_NAME)
        createDataCompletion(completion: {
            (filmsTemp) in
            self.films = filmsTemp
            (self.filmGroup, self.groupTitles) = self.getGroupFilm(films: self.films)
            self.filmTable.reloadData()
            self.filmTable.isHidden = false
            self.loadingImage.isHidden = true
        })
    }
    
    fileprivate func getGroupFilm(films: [Film]) -> ([String: [Film]], [String]) {
        let filmGroup = self.createFilmGroupByTitle(films)
        let groupTitles = Array(filmGroup.keys).sorted {
            $0 < $1
        }
        return (filmGroup, groupTitles)
    }
    
    fileprivate func createFilmGroupByTitle(_ filmsTemp: [Film]) -> [String: [Film]] {
        let filmsSorted = self.sortArrayByAlphabet(filmsRaw: filmsTemp)
        var filmGroupTemp: [String: [Film]] = [:]
        var groupTitle = ""
        var filmsInGroup: [Film] = []
        for i in 0..<filmsSorted.count {
            let firstChar = getFirstLetterTitle(filmsSorted[i].title)
            
            if isFirstIndex(index: i) {
                groupTitle = firstChar
            }
            
            if groupTitle != firstChar {
                filmGroupTemp[groupTitle] = filmsInGroup
                filmsInGroup = []
                groupTitle = firstChar
                filmsInGroup.append(filmsSorted[i])
            } else {
                filmsInGroup.append(filmsSorted[i])
            }
            
            if isLastIndex(index: i, array: filmsSorted) {
                filmGroupTemp[groupTitle] = filmsInGroup
            }
        }
        return filmGroupTemp
    }
    
    fileprivate func isFirstIndex(index: Int) -> Bool {
        return index == 0
    }
    
    fileprivate func isLastIndex(index: Int, array: [Any]) -> Bool {
        return index == array.count - 1
    }
    
    fileprivate func getFirstLetterTitle(_ text: String) -> String {
        return String(text.prefix(1))
    }
    
    fileprivate func sortArrayByAlphabet( filmsRaw: [Film]) -> [Film] {
        return filmsRaw.sorted {
            $0.title < $1.title
        }
    }
    
    fileprivate func createDataCompletion(completion:@escaping (_ filmsTemp: [Film]) ->()) {
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
        let filmTitle: String = "\(String(describing: filmData[Film.TITLE]!))"
        let filmPosterUrl: String = self.HOST_IMAGE + "\(String(describing: filmData[Film.POSTER]!))"
        let filmOverview: String = "\(String(describing: filmData[Film.OVERVIEW]!))"
        return Film(imageUrl: filmPosterUrl, title: filmTitle, overview: filmOverview)
    }
}

extension UIImage {
    public class func gif(asset: String) -> UIImage? {
        if let asset = NSDataAsset(name: asset) {
            return UIImage.gif(data: asset.data)
        }
        return nil
    }
}
