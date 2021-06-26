//
//  DataBase.swift
//  Apparty
//
//  Created by עודד האינה on 07/03/2021.
//

import Foundation
import CoreData

class Database{

    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "Apparty")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Out of disk space")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //computed var:
    var context: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    //singleton:
    private init(){/*No instances from outside theclass (PRIVATE)*/}
    static let shared = Database()

    
   
    //methods:
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
    func delete(apartment:FavApar){
        context.delete(apartment)
        saveContext()
    }


    func save(apartment:FavApar){
        //in the future we can add some code here to save the object to another database
        //since this is a managed object -> context.save saves the object
        saveContext()
    }

    func getFav()-> [FavApar]{
        //1) fetch request
        let request: NSFetchRequest<FavApar> = FavApar.fetchRequest()

        //2) execute:
//        if let people = try? context.fetch(request){
//            return people
//        }
        //consider fatalError()
        return  []
    }

}
