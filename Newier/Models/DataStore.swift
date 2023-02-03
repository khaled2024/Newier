//
//  DataStore.swift
//  Newier
//
//  Created by KhaleD HuSsien on 02/02/2023.

import Foundation

protocol DataStore: Actor {
    associatedtype D
    
    func save(_ current: D)
    func load()-> D?
}
actor PlistDataStore<T: Codable>: DataStore where T: Equatable{
    private var saved: T?
    let fileName: String
    init(fileName: String){
        self.fileName = fileName
    }
    private var dataURL: URL{
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("\(fileName).plist")
    }
    func save(_ current: T){
        if let saved = self.saved, saved == current{
            return
        }
        do {
            let enconder = PropertyListEncoder()
            enconder.outputFormat = .binary
            let date = try enconder.encode(current)
            try date.write(to: dataURL, options: [.atomic])
            self.saved = current
        } catch  {
            print(error.localizedDescription)
        }
    }
    func load() -> T? {
        do {
            let data = try Data(contentsOf: dataURL)
            let decoder = PropertyListDecoder()
            let current = try decoder.decode(T.self, from: data)
            self.saved = current
            return current
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
