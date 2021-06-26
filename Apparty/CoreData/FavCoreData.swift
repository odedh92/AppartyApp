//
//  FavCoreData.swift
//  Apparty
//
//  Created by עודד האינה on 12/03/2021.


import CoreData

class FavCoreData{

    lazy var persistentContainer: NSPersistentContainer = {
    
        let container = NSPersistentContainer(name: "FavApartment")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Out of disk space")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    var context: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    private init(){}
    static let shared = FavCoreData()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func delete(favApp: FavEntity){
        context.delete(favApp)
        saveContext()
    }
    func save(favApp: FavEntity){
        saveContext()
    }
    func getFavApp()-> [FavEntity]{
        let request: NSFetchRequest<FavEntity> = FavEntity.fetchRequest()
        if let favApp = try? context.fetch(request){
            return favApp
        }
        return  []
    }
}
