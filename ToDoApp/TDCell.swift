//
//  TDCell.swift
//  ToDoApp
//
//  Created by Андрей on 29.10.2021.
//

import Foundation
import UIKit

class TDCell : UITableViewCell {
    @IBOutlet weak var doneCheckbox: UIButton!
    @IBOutlet weak var importanceMarker: UILabel!
    
    @IBOutlet weak var taskStack: UIStackView!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var taskDate: UILabel!
    
    @IBOutlet weak var openButton: UIButton!
    
    func setTodo(todo: ToDoItem) {
        taskLabel.text = todo.text
        taskDate.isHidden = true
        importanceMarker.isHidden = true
    }
}
