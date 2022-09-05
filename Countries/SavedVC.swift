//
//  SavedVC.swift
//  Countries
//
//  Created by Didem Bilgihan on 4.09.2022.
//

import UIKit
import CoreData

class SavedVC: UIViewController {
    
    @IBOutlet weak var mTableView: UITableView!
    var homeVC = HomeVC()
    var mCountryList = [ListOfCountries]()
    var mCountry = [CountryManager]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mTableView.dataSource = self
        mTableView.delegate = self
        getSavedCountries()
    }
    
    // MARK: - Getting saved countries and store them in an array
    func getSavedCountries(){
        for country in mCountryList{
            if country.isSaved{
                let countryData = CountryManager(name: country.countryName!, code: country.countryCode!, wikiDataId: country.wikiDataId!, isSaved: country.isSaved)
                mCountry.append(countryData)
                
            }
        }
    }
    
    // MARK: - When countries isSaved situation changed the tableview and array reloaded
    
    override func viewDidAppear(_ animated: Bool) {
        refreshData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        refreshData()
    }
    
    func refreshData(){
        mCountry.removeAll()
        getSavedCountries()
        mTableView.reloadData()
        
    }
    
    //MARK: - When country save button clicked, the button image changed and core data updated
    @IBAction func manageSave(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.mTableView)
        let indxPath = mTableView.indexPathForRow(at: buttonPosition)
        //let cell = self.mTableView.cellForRow(at: indxPath!) as! CustomViewCell
        
        let filter = mCountry[indxPath!.row].code
        let fr = NSFetchRequest<ListOfCountries>(entityName: "ListOfCountries")
        fr.predicate = NSPredicate(format: "countryCode == %@", filter)
        let res = try! context.fetch(fr)
        if res.count > 0{
            res[0].isSaved = false
            print(res[0])
        }
        mCountry.remove(at: indxPath!.row)
        mTableView.reloadData()
    }
    
    // MARK: - Delegate
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = getIndexPathForSelectedRow() {
            let country = mCountry[indexPath.row]
            let fr = NSFetchRequest<ListOfCountries>(entityName: "ListOfCountries")
            fr.predicate = NSPredicate(format: "countryCode == %@", country.code)
            let res = try! context.fetch(fr)
            
            let detailViewController = segue.destination as! DetailVC
            detailViewController.mCountry = res[0]
        }
    }
    
}
// MARK: - Table View Functions
extension SavedVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return mCountry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomViewCell
        
        
        cell.savedCountryName.text = mCountry[indexPath.row].name
        cell.savedCountryButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        
        return cell
    }
    
    // MARK: - Find the selected row
    func getIndexPathForSelectedRow() -> IndexPath? {
        var indexPath: IndexPath?
        
        if mTableView.indexPathsForSelectedRows!.count > 0 {
            indexPath = mTableView.indexPathsForSelectedRows![0] as IndexPath
        }
        return indexPath
    }
    
}


