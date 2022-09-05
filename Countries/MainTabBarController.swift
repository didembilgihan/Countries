//
//  MainTabBarController.swift
//  Countries
//
//  Created by Didem Bilgihan on 4.09.2022.
//

import UIKit
import SwiftyJSON
import CoreData

class MainTabBarController: UITabBarController {
    
    var link = "https://wft-geo-db.p.rapidapi.com/v1/geo/countries?rapidapi-key=bfd86b0870msh32c44b7855eb093p1fc5b7jsnf266af99ac2e&limit=10"
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var models = [ListOfCountries]()


    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        getAllCountries()
        

        guard let tempViewControllers = viewControllers else {
            return
        }
        // Passing data to tab view controllers
        for (index, tab) in tempViewControllers.enumerated() {
            if let vc = tab as? HomeVC{
                vc.mCountryList = models
            }else if let vc = tab as? SavedVC{
                vc.mCountryList = models
            }
        }
    }
    
    
    //MARK: - Recieve GEOCities API Data & JSON Parsing
    func getData() {
        if let mURL = URL(string: link) {
            if let data = try? Data(contentsOf: mURL) {
                guard let json = try? JSON(data: data) else {
                    print("Error with JSON")
                    return
                }
                let total = json["data"].count
                for index in 0..<total {
                    let code = json["data"][index]["code"].string!
                    let name = json["data"][index]["name"].string!
                    let wikiDataId = json["data"][index]["wikiDataId"].string!
                    
                    //let mCountry = CountryManager(name: name, code: code, wikiDataId: wikiDataId, isSaved: false)
                    //mCountryList.append(mCountry)
                    if !isEntityAttributeExist(cCode: code){
                        let newCountry = ListOfCountries(context: context)
                        newCountry.countryName = name
                        newCountry.countryCode = code
                        newCountry.wikiDataId = wikiDataId
                        newCountry.isSaved = false
                        
                        do{
                            try context.save()
                        }catch{
                            print("Country could not fetched")
                        }
                    }
                }
            }
            
        }
        else {
            print("NSURL error")
        }
    }
    
    // MARK: - Updating isSaved value 
    func updateCountry(countryItem: ListOfCountries, isSaved: Bool){
        countryItem.isSaved = isSaved
        do{
            try context.save()
        }catch{
            print("Could not updated!")
        }
    }
    
    func isEntityAttributeExist(cCode: String) -> Bool{
        let fr = NSFetchRequest<ListOfCountries>(entityName: "ListOfCountries")
        fr.predicate = NSPredicate(format: "countryCode == %@", cCode)
        let res = try! context.fetch(fr)
        return res.count > 0 ? true : false
        
    }
    
    func getAllCountries(){
        do{
            models = try context.fetch(ListOfCountries.fetchRequest())
            
        }catch{
            print("Could not get countries")
        }
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
