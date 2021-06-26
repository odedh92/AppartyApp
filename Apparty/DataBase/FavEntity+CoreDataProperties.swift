//
//  FavEntity+CoreDataProperties.swift
//  Apparty
//
//  Created by עודד האינה on 12/03/2021.
//
//

import Foundation
import CoreData


extension FavEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavEntity> {
        return NSFetchRequest<FavEntity>(entityName: "FavEntity")
    }

    @NSManaged public var city: String
    @NSManaged public var street: String
    @NSManaged public var price: String
    @NSManaged public var owner: String
    @NSManaged public var rooms: String
    @NSManaged public var elavator: Bool
    @NSManaged public var balcony: Bool
    @NSManaged public var image: String
    @NSManaged public var size: String
    @NSManaged public var type: String

}
extension FavEntity : Identifiable {

}
