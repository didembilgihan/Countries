//
//  ListOfCountries+CoreDataProperties.swift
//  
//
//  Created by Didem Bilgihan on 4.09.2022.
//
//

import Foundation
import CoreData


extension ListOfCountries {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListOfCountries> {
        return NSFetchRequest<ListOfCountries>(entityName: "ListOfCountries")
    }

    @NSManaged public var countryName: String?
    @NSManaged public var countryCode: String?
    @NSManaged public var wikiDataId: String?
    @NSManaged public var isSaved: Bool

}
