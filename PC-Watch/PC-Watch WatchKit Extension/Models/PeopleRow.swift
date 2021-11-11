//
//  PeopleRow.swift
//  PC-Watch WatchKit Extension
//
//  Created by Emma Allegrucci on 8/27/20.
//  Copyright © 2020 Infinite Options. All rights reserved.
//

import Foundation

struct PeopleRow: Identifiable {
    let id = UUID()
    var cells = [Cell]()

    init(cells: [Cell]) {
        self.cells = cells
    }
}

extension PeopleRow {
    static func populate(people: [ImportantPerson]) -> [PeopleRow] {
        var rows = [PeopleRow]()
        var i = 0
        var col = 0
        while i < people.count {
            let dif = people.count - 1 - i
            if dif > 2 {
                if (col % 2 == 0) {
                    rows.append(PeopleRow(cells: [Cell(person: people[i]), Cell(person: people[i+1]), Cell(person: people[i+2])]))
                    i+=3
                    col+=1
                } else {
                    rows.append(PeopleRow(cells: [Cell(person: people[i]), Cell(person: people[i+1]), Cell(person: people[i+2]), Cell(person: people[i+3])]))
                    i+=4
                    col+=1
                }
            } else if dif == 2 {
                rows.append(PeopleRow(cells: [Cell(person: people[i]), Cell(person: people[i+1]), Cell(person: people[i+2])]))
                i+=3
            } else if dif == 1 {
                rows.append(PeopleRow(cells: [Cell(person: people[i]), Cell(person: people[i+1])]))
                i+=2
            } else {
                rows.append(PeopleRow(cells: [Cell(person: people[i])]))
                i+=1
            }
        }
        return rows
    }
}

struct Cell: Identifiable {
    let id = UUID()
    var person: ImportantPerson

    init(person: ImportantPerson) {
        self.person = person
    }
}
