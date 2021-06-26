//
//  FavEntity+CoreDataClass.swift
//  Apparty
//
//  Created by עודד האינה on 12/03/2021.
//
//

import Foundation
import CoreData

@objc(FavEntity)
public class FavEntity: NSManagedObject {
    
    
    convenience init(balcony: Bool,city: String,elavator: Bool,image: String,owner: String,rooms: String,size: String,street: String,type:String,price:String){
            self.init(context: FavCoreData.shared.context)
    
              self.balcony = balcony
              self.city = city
              self.elavator = elavator
              self.image = image
              self.owner = owner
              self.rooms = rooms
              self.size = size
              self.street = street
              self.type = type
              self.price = price
          }
    func isSame(app:Apertment) -> Bool{
        if app.City == self.city && (app.Image1 == self.image || app.Image2 == self.image) && app.Owner == self.owner && app.Price == self.price && app.Type == self.type && app.Size == self.size && app.Street == self.street && app.hasBalcony == self.balcony && app.hasElavator == self.elavator && app.Rooms == self.rooms {
            return true
        }
        return false
    }
    }

//  equatiable לחפש

//https://www.hackingwithswift.com/example-code/language/how-to-conform-to-the-equatable-protocol
