//
//  Extension-String.swift
//  Challenge03
//
//  Created by Robert Hoover on 2023-02-24.
//

// MARK: - extensions
extension String {
    func indices(for letter: String) -> [Int] {
        guard !letter.isEmpty else { return [] }
        
        let stringArray = self.map { String($0) }  // convert string to array of string
        var positionsArray = [Int]()
        
        for i in 0..<stringArray.count {
            if letter == stringArray[i] {
                positionsArray.append(i)
            } else {
                continue
            }
        }
        
        return positionsArray
    }
}

