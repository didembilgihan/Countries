//
//  DetailVC.swift
//  Countries
//
//  Created by Didem Bilgihan on 4.09.2022.
//

import UIKit

import Alamofire
import SVGKit
import CoreData
import SwiftyJSON

class DetailVC: UIViewController {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var detailTitle: UINavigationItem!
    @IBOutlet weak var countryCode: UILabel!
    
    var wikiURL = "https://www.wikidata.org/wiki/"
    
    var cUrl = "https://wft-geo-db.p.rapidapi.com/v1/geo/countries/"
    var apiKey = "?rapidapi-key=bfd86b0870msh32c44b7855eb093p1fc5b7jsnf266af99ac2e"
    var imageUrL: String = ""
    var mCountry = ListOfCountries()
    @IBOutlet weak var savedCountry: UIBarButtonItem!
    
    var mTabBar = MainTabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTitle.title = mCountry.countryName
        countryCode.text = mCountry.countryCode
        
        wikiURL += mCountry.wikiDataId ?? ""
        
        cUrl = cUrl + mCountry.countryCode!
        cUrl += apiKey
        
        if mCountry.isSaved{
            savedCountry.image = UIImage(systemName: "star.fill")
        }else{
            savedCountry.image = UIImage(systemName: "star")
        }
        
        // Loading image view
       
        AF.request(cUrl).response { [self]  response in
            debugPrint("Response: \(response)")
            if let data = response.data {
                guard let json = try? JSON(data: data) else {
                    print("Error with JSON")
                    return
                }
                imageUrL = json["data"]["flagImageUri"].string!
                let mySVGImage: SVGKImage = SVGKImage(contentsOf: URL(string: imageUrL))
                DispatchQueue.main.async {
                    self.countryImage.image = mySVGImage.uiImage
                    //self.countryImage.image =  UIImage(data: data)
                }
            }
        }
    }
    
    
    //MARK: - When country save button clicked, the button image changed and core data updated
    @IBAction func manageSaved(_ sender: UIBarButtonItem) {
        if !mCountry.isSaved{
            sender.image = UIImage(systemName: "star.fill")
            mTabBar.updateCountry(countryItem: mCountry, isSaved: true)
        }else{
            sender.image = UIImage(systemName: "star")
            mTabBar.updateCountry(countryItem: mCountry, isSaved: false)
        }
    }
    
    // MARK: - Navigation / WikiData link send to InformationVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "wikiInfo"{
            let informationVC = segue.destination as! InformationVC
            informationVC.wikiURL = wikiURL
        }
    }
    
    // MARK: - Unwind Segue
    @IBAction func unwindToDetail(_ segue: UIStoryboardSegue) {
        
    }
}
