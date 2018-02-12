//
//  Realm+Helper.swift
//  AccountApp
//
//  Created by Chen Kuan Chung on 2018/01/21.
//  Copyright © 2018年 william. All rights reserved.
//

import RealmSwift
import Foundation

class RealmHelper {
    static func objects<T: Object>(_ type: T.Type) -> Results<T>? {
        do {
            let realm = try Realm()
            return realm.objects(type)
        } catch let error {
            print("Query error : \(error.localizedDescription)")
        }
        return nil
    }
    static func deleteAll() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch let error {
            print("Delete all error : \(error.localizedDescription)")
        }
        
    }
    
    static func isContain(_ date: Date) -> Bool {
        let result = RealmHelper.objects(Account.self)?.filter("date == %@", date)
        return result?.count != 0
    }
}

extension Object {
    func add() {
        do {
            let realm  = try Realm()
            try realm.write {
                realm.add(self)
            }
        } catch let error {
            print("Write error : \(error.localizedDescription)")
        }
        
    }
    
    func update(completionHandler: () -> Void) {
        do {
            let realm = try Realm()
            try realm.write(completionHandler)
        } catch let error {
            print("Update error: \(error.localizedDescription)")
        }
    }
    
    func delete() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(self)
            }
        } catch let error {
            print("Delete error: \(error.localizedDescription)")
        }
       
    }
    
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
    
}
