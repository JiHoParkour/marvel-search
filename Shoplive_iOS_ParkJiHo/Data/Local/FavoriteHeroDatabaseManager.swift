//
//  DBManager.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/23/24.
//

import Foundation
import SQLite3

final class FavoriteHeroDatabaseManager {
    
    static let shared = FavoriteHeroDatabaseManager()
    private var db: OpaquePointer?
    private let databaseName = "favoriteHeros"
    private let tableName = "favoriteHeros"
    private let lock = NSLock()
    
    private init() {
        do {
            self.db = try createDatabase(with: databaseName)
        } catch(let error){
            print(error.localizedDescription)
        }
    }
    
    deinit {
        sqlite3_close(db)
    }
}

// MARK: - Create

extension FavoriteHeroDatabaseManager {
    private func createDatabase(with name: String) throws -> OpaquePointer? {
        var db: OpaquePointer? = nil
        
        do {
            let dbPath: String = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            ).appendingPathComponent("\(name).sqlite").path
            
            if sqlite3_open_v2(dbPath, &db, SQLITE_OPEN_CREATE|SQLITE_OPEN_READWRITE|SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK {
                return db
            }
            
        } catch {
            throw DatabaseError.databaseCreateError
        }
        return nil
    }
    
    func createTable() throws {
        let query = """
               CREATE TABLE IF NOT EXISTS \(tableName)(
               id INTEGER PRIMARY KEY AUTOINCREMENT,
               hero_id INTEGER,
               name TEXT NOT NULL,
               description TEXT,
               thumbnail_path TEXT
               );
               """
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) != SQLITE_DONE {
                throw DatabaseError.tableCreateError(self.db?.errorMessage)
            }
        } else {
            throw DatabaseError.tableCreateError(self.db?.errorMessage)
        }
        sqlite3_finalize(statement)
    }
}

// MARK: - Read

extension FavoriteHeroDatabaseManager {
    func readFavoriteHeros() throws -> [FavoriteHero] {
        let query: String = "SELECT * FROM \(tableName);"
        var statement: OpaquePointer? = nil
        var result: [FavoriteHero] = []
        
        if sqlite3_prepare(self.db, query, -1, &statement, nil) != SQLITE_OK {
            throw DatabaseError.sqlitePrepareFail(self.db?.errorMessage)
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = sqlite3_column_int(statement, 1)
            let name = String(cString: sqlite3_column_text(statement, 2))
            let description = String(cString: sqlite3_column_text(statement, 3))
            let thumbnailPath = String(cString: sqlite3_column_text(statement, 4))
            
            result.append(FavoriteHero(id: Int(id),
                                       name: name,
                                       description: description,
                                       thumbnailPath: thumbnailPath))
        }
        sqlite3_finalize(statement)
        return result
    }
    
    func readOldestFavoriteHero() throws -> FavoriteHero {
        let query: String = "SELECT * FROM \(tableName) ORDER BY id LIMIT 1;"
        var statement: OpaquePointer?
        
        defer {
            sqlite3_finalize(statement)
        }
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_ROW {
                let heroID = sqlite3_column_int(statement, 1)
                let name = String(cString: sqlite3_column_text(statement, 2))
                let description = String(cString: sqlite3_column_text(statement, 3))
                let thumbnailPath = String(cString: sqlite3_column_text(statement, 4))
                
                return FavoriteHero(id: Int(heroID),
                                    name: name,
                                    description: description,
                                    thumbnailPath: thumbnailPath)
            } else {
                throw DatabaseError.sqliteStepFail(self.db?.errorMessage)
            }
        } else {
            throw DatabaseError.sqlitePrepareFail(self.db?.errorMessage)
        }
    }
    
    func readFavoriteHero(with heroID: Int) throws -> FavoriteHero {
        let query: String = "SELECT * FROM \(tableName) WHERE hero_id == \(heroID);"
        var statement: OpaquePointer?
        
        defer {
            sqlite3_finalize(statement)
        }
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_ROW {
                let heroID = sqlite3_column_int(statement, 1)
                let name = String(cString: sqlite3_column_text(statement, 2))
                let description = String(cString: sqlite3_column_text(statement, 3))
                let thumbnailPath = String(cString: sqlite3_column_text(statement, 4))
                
                return FavoriteHero(id: Int(heroID),
                                    name: name,
                                    description: description,
                                    thumbnailPath: thumbnailPath)
            } else {
                throw DatabaseError.sqliteStepFail(self.db?.errorMessage)
            }
        } else {
            throw DatabaseError.sqlitePrepareFail(self.db?.errorMessage)
        }
    }
}

// MARK: - Update

extension FavoriteHeroDatabaseManager {
    func insertFavoriteHero(heroID: Int,
                            name: String,
                            description: String,
                            thumbnailPath: String) throws -> FavoriteHero {
        
        var statement: OpaquePointer? = nil
        lock.lock()
        defer {
            lock.unlock()
            sqlite3_finalize(statement)
        }
        
        let insertQuery = "INSERT INTO \(tableName) (id, hero_id, name, description, thumbnail_path) VALUES (?, ?, ?, ?, ?);"
        
        if sqlite3_prepare_v2(self.db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 2, Int32(heroID))
            sqlite3_bind_text(statement, 3, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (description as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, (thumbnailPath as NSString).utf8String, -1, nil)
        } else {
            throw DatabaseError.sqliteBindingError(self.db?.errorMessage)
        }
        
        if sqlite3_step(statement) == SQLITE_DONE {
            return try readFavoriteHero(with: heroID)
        } else {
            throw DatabaseError.sqliteStepFail(self.db?.errorMessage)
        }
    }
}

// MARK: - Delete

extension FavoriteHeroDatabaseManager {
    func deleteFavoriteHero(with heroID: Int) throws -> Int {
        lock.lock()
        defer {
            lock.unlock()
        }
        
        let willBeDeletedHero = try readFavoriteHero(with: heroID)
        let query = "DELETE FROM \(tableName) WHERE hero_id = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(heroID))
            if sqlite3_step(statement) != SQLITE_DONE {
                throw DatabaseError.sqliteStepFail(self.db?.errorMessage)
            }
        } else {
            throw DatabaseError.sqlitePrepareFail(self.db?.errorMessage)
        }
        sqlite3_finalize(statement)
        
        return willBeDeletedHero.id
    }
    
    func deleteOldestFavoriteHero() throws -> Int {
        lock.lock()
        defer {
            lock.unlock()
        }
        
        let willBeDeletedHero = try readOldestFavoriteHero()
        let query = "DELETE FROM \(tableName) ORDER BY id LIMIT 1;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) != SQLITE_DONE {
                throw DatabaseError.sqliteStepFail(self.db?.errorMessage)
            }
        } else {
            throw DatabaseError.sqlitePrepareFail(self.db?.errorMessage)
        }
        sqlite3_finalize(statement)
        return willBeDeletedHero.id
    }
}
