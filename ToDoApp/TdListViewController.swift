//
//  TDList.swift
//  ToDoApp
//
//  Created by Андрей on 29.10.2021.
//

import Foundation
import UIKit

class TdListViewController : UITableView, UITableViewDelegate, UITableViewDataSource {
    
    
    var list = FileCache()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todo = list.tdList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TDCell") as! TDCell
        
        cell.setTodo(todo: todo)
        return cell
    }
}
