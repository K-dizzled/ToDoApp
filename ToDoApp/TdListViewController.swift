//
//  TDList.swift
//  ToDoApp
//
//  Created by Андрей on 29.10.2021.
//

import Foundation
import UIKit

class TdListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var TDTableView: UITableView!
    
    var list : FileCache = FileCache()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todo = list.toDoList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TDCell") as! TDCell
        
        cell.setTodo(todo: todo)
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list.addNewTD(ToDoItem(text: "Сделать", importance: Importance.ordinary))
        
        TDTableView.delegate = self
        TDTableView.dataSource = self
        
    }
}
