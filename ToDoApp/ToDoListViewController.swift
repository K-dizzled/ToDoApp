//
//  ToDoListViewController.swift
//  ToDoApp
//
//  Created by Андрей on 15.11.2021.
//

import Foundation
import UIKit

class ToDoListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var tableView = UITableView()

    private lazy var viewController = {
        self.storyboard?.instantiateViewController(withIdentifier: "tdEdit") as! ViewController
    }()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TDItemCell
        
    
//
//        //Bottom Corners
//        let maskPathBottom = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 16.0, height: 16.0))
//        let shapeLayerBottom = CAShapeLayer()
//        shapeLayerBottom.frame = cell.bounds
//        shapeLayerBottom.path = maskPathBottom.cgPath

        if (indexPath.row == 0) {
            //Top Corners
            let maskPathTop = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 16.0, height: 16.0))
            let shapeLayerTop = CAShapeLayer()
            shapeLayerTop.frame = cell.bounds
            shapeLayerTop.path = maskPathTop.cgPath
            
            cell.layer.mask = shapeLayerTop
        }
//
//        if (indexPath.row == self.tableView(tableView, numberOfRowsInSection : indexPath.section) - 1) {
//            cell.layer.mask = shapeLayerBottom
//        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ToDoAppColors.magnoliaColor

        setTableView()
        setAddButton()
        setHeader()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.reloadData()
    }
    
    override func updateViewConstraints() {
        tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height).isActive = true
        super.updateViewConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateHeaderViewHeight(for: tableView.tableHeaderView)
        updateHeaderViewHeight(for: tableView.tableFooterView)
    }

    func updateHeaderViewHeight(for header: UIView?) {
        guard let header = header else { return }
        header.frame.size.height = header.systemLayoutSizeFitting(CGSize(width: view.bounds.width - 32.0, height: 0)).height
    }
    
    func setHeader() {
        let headerView = TDListHeader(frame: .zero)
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.backgroundColor = .clear
        
        let footerView = TDListHeaderFooter(frame: .zero)
        tableView.tableFooterView = footerView
        tableView.tableFooterView?.backgroundColor = .white
    }
    
    func setTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TDItemCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 66
        tableView.separatorColor = UIColor.gray
//        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.lastBaselineAnchor.constraint(equalTo: <#T##NSLayoutAnchor<NSLayoutYAxisAnchor>#>)
        
        guard let parent = self.view else { return }
        parent.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: 60),
            tableView.leadingAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor)
//            tableView.heightAnchor.constraint(equalToConstant: 2000)
        ])
    }
    
    func setAddButton() {
        let button = UIButton()
        button.setImage(UIImage(named: "add_button"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 25
        
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        guard let parent = self.view else { return }
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            button.widthAnchor.constraint(equalToConstant: 50),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.centerXAnchor.constraint(equalTo: parent.centerXAnchor)
        ])
        
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
    }
    
    @objc func addButtonPressed() -> Void {
        present(viewController, animated: true, completion: nil)
    }
}
