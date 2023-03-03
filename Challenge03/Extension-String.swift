//
//  Extension-String.swift
//  Challenge03
//
//  Created by Robert Hoover on 2023-02-24.
//

extension String {
    // https://en.wikipedia.org/wiki/Knuth–Morris–Pratt_algorithm
    func indices(of string: String) -> [Int] {
        guard !string.isEmpty else { return [] }
        
//        let search = self.utf8.map { $0 }
//        let word = string.utf8.map { $0 }
        let search = self.map { $0 }
        let word = string.map { $0 }
        
        var indices = [Int]()
        
        var m = 0, i = 0
        while m + i < search.count {
            if word[i] == search[m + i] {
                if i == word.count - 1 {
                    indices.append(m)
                    m += i + 1
                    i = 0
                } else {
                    i += 1
                }
            } else {
                m += 1
                i = 0
            }
        }
        
        return indices
    }
}
