//
//  Apartments.swift
//  Apparty
//
//  Created by Oded haina on 07/02/2021.
//

import Foundation
import Firebase

public class Apertment : Codable {
    internal init(City: String? = nil, Street: String? = nil, Rooms: String? = nil, Price: String? = nil, Type: String? = nil, name: String? = nil, Image1: String? = nil, Image2: String? = nil, Size: String? = nil, hasBalcony: Bool? = nil, hasElavator: Bool? = nil, Owner: String? = nil,PhoneNumber: String? = nil) {
        self.City = City
        self.Street = Street
        self.Rooms = Rooms
        self.Price = Price
        self.Type = Type
        self.name = name
        self.Image1 = Image1
        self.Image2 = Image2
        self.Size = Size
        self.hasBalcony = hasBalcony
        self.hasElavator = hasElavator
        self.Owner = Owner
        self.PhoneNumber = PhoneNumber
    }
    
    var City : String?
    var Street : String?
    var Rooms : String?
    var Price : String?
    var `Type` : String?
    var name: String?
    var Image1: String?
    var Image2: String?
    var Size : String?
    var hasBalcony : Bool?
    var hasElavator : Bool?
    var Owner : String?
    var PhoneNumber : String?
    
    

}
