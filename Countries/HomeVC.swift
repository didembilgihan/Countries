//
//  ViewController.swift
//  Countries
//
//  Created by Didem Bilgihan on 4.09.2022.
//

import UIKit
import CoreData
import SwiftyJSON

class HomeVC: UIViewController {

    @IBOutlet weak var mTableView: UITableView!
    
    //MARK: - Creating Context for Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var mCountryList = [ListOfCountries]()
    var mTabBar = MainTabBarController()

    override func viewDidLoad() {
        super.viewDidLoad()
        mTableView.delegate = self
        mTableView.dataSource = self
        
    }
    
    
    // MARK: - When View Controller appear again, the table view reloaded for any change in Core Data
    override func viewDidAppear(_ animated: Bool) {
        mTableView.reloadData()
    }
    // MARK: - Unwind Segue
    @IBAction func unwindToMainVC(_ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.source
        mTableView.reloadData()
    }
    
    //MARK: - When country save button clicked, the button image changed and core data updated
    @IBAction func manageSave(_ sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.mTableView)
        let indxPath = mTableView.indexPathForRow(at: buttonPosition)
        //let cell = self.mTableView.cellForRow(at: indxPath!) as! CustomViewCell
        
        if !mCountryList[indxPath!.row].isSaved{
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
            mTabBar.updateCountry(countryItem: mCountryList[indxPath!.row], isSaved: true)
        }else{
            sender.setImage(UIImage(systemName: "star"), for: .normal)
            mTabBar.updateCountry(countryItem: mCountryList[indxPath!.row], isSaved: false)
        }
    }
    
    // MARK: - Delegate / The selected country information pass to DetailVC controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = getIndexPathForSelectedRow() {
            let country = mCountryList[indexPath.row]
            let detailViewController = segue.destination as! DetailVC
            detailViewController.mCountry = country
        }
    }


}


// MARK: - Table View Functions
extension HomeVC: UITableViewDataSource, UITableViewDelegate{
    // MARK: - Table View Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mCountryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomViewCell
        
        let country = mCountryList[indexPath.row]
        cell.homeCountryName.text = country.countryName
        
        if country.isSaved{
            cell.homeCountryButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }else{
            cell.homeCountryButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
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



