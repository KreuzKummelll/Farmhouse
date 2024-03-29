//
//  Persistence.swift
//  Farmhouse
//
//  Created by Andrew McLane on 06.05.20.
//  Copyright © 2020 Andrew McLane. All rights reserved.
//

import Foundation
import Combine



fileprivate struct Envelope: Codable {
    let farmers: [PublicFarm]
}

class Persistence {
    var localFile: URL {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("farms.json")
        print("Just in case \(fileURL)")
        return fileURL
    }
    
    var defaultFile: URL {
        return Bundle.main.url(forResource: "default", withExtension: "json")!
    }
    
    private func clear() {
        try? FileManager.default.removeItem(at: localFile)
    }
    
    func load() -> AnyPublisher<[PublicFarm], Never> {
        if FileManager.default.fileExists(atPath: localFile.standardizedFileURL.path) {
            return Future<[PublicFarm], Never> { promise in
                self.load(self.localFile) { farmers in
                    DispatchQueue.main.async {
                        promise(.success(farmers))
                    }
                }
            }.eraseToAnyPublisher()
        } else {
            return loadDefault()
        }
    }
    
    func save(farmers: [PublicFarm]) {
        let envelope = Envelope(farmers: farmers)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(envelope)
        try! data.write(to: localFile)
    }
    
    func loadSynchronously(_ file: URL) -> [PublicFarm] {
        do {
            let data = try Data(contentsOf: file)
            let envelope = try JSONDecoder().decode(Envelope.self, from: data)
            return envelope.farmers
        } catch {
            clear()
            return loadSynchronously(defaultFile)
        }
    }
    
    private func load(_ file: URL, completion: @escaping ([PublicFarm]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let farmers = self.loadSynchronously(file)
            completion(farmers)
        }
    }
    
    func loadDefault(synchronous: Bool = false) -> AnyPublisher<[PublicFarm], Never> {
        if synchronous {
            return Just<[PublicFarm]>(loadSynchronously(defaultFile))   .eraseToAnyPublisher()
        }
        return Future<[PublicFarm], Never> { promise in
            self.load(self.defaultFile) { farmers in
                DispatchQueue.main.async {
                    promise(.success(farmers))
                }
            }
        }.eraseToAnyPublisher()
    }
}
