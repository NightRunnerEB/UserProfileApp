//
//  DataController.swift
//  UserProfileApp
//
//  Created by Евгений Бухарев on 20.03.2024.
//

import Foundation
import CoreData
class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "UserProfile")
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved!")
        } catch {
            print("we could not save the data...")
        }
    }
    
    func addFood(context: NSManagedObjectContext) {
        let user = UserProfile(context: context)
        user.firstName = ""
        user.lastName = ""
        user.email = ""
        user.nickname = ""
        user.telegram = ""
        user.phone = ""
        user.patronymic = nil
        user.photo = nil
        
        save(context: context)
    }
    
    func editUser(user: UserProfile, firstName: String, lastName: String, email: String, nickname: String, telegram: String, phone: String, patronymic: String, context: NSManagedObjectContext) {
        user.firstName = firstName
        user.lastName = lastName
        user.email = email
        user.nickname = nickname
        user.telegram = telegram
        user.phone = phone
        user.patronymic = patronymic
        
        save(context: context)
    }
    
}
