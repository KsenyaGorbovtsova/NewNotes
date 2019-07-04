//
//  FileNotebook.swift
//  NoteStepik
//
//  Created by Gorbovtsova Ksenya on 18/06/2019.
//  Copyright © 2019 Gorbovtsova Ksenya. All rights reserved.
//

import Foundation


class FileNotebook {
    
    public private(set) var noteCollection = Set<Note>()
    
    public func add (_ note: Note) {
        noteCollection.insert(note)
    }
    
    public func remove(with uid: String) {
        if let removeIndex = noteCollection.firstIndex(where: {$0.uid == uid}) {
            noteCollection.remove(at: removeIndex)
            
        }
    }
    
    public func writeIntoFile(note: [Note]) {
        
        for x in note {
            x.json.writeJson()
        }
    }
    public func loadFromFile() {
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            let file = "noteCollection.txt"
            let fileURL = path.appendingPathComponent(file)

            do{
                let data = try Data(contentsOf: fileURL, options: [])
                
                do {
                    if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] {
                        for item in dict {
                            if  let note = Note.parse(json: item) {
                                noteCollection.insert(note)
                            }
                        }
                    }
                } catch {
                    
                }
                
            }catch{
                print("reading error")
            }
        }
    }
    
}
    
extension Dictionary {
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    func write (text: String, filename: URL) {
        do {
            try text.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("failed to write")
        }
    }
    func writeJson() {
         if let path =
            FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let newFile = path.appendingPathComponent("noteCollection.txt")
        
            if(!FileManager.default.fileExists(atPath:newFile.path)){
                FileManager.default.createFile(atPath: newFile.path, contents: nil, attributes: nil)
                write(text: json, filename: newFile)
            }else{
            write(text: json, filename: newFile)
            }
        }
    }
    
}

