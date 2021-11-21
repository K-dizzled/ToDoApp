//
//  TDListHeader.swift
//  ToDoApp
//
//  Created by Андрей on 16.11.2021.
//

import Foundation
import UIKit

class TDListHeaderFooter: UIView {

    let label = UILabel(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Новое"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = ToDoAppColors.middleGreyColor
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.heightAnchor.constraint(equalToConstant: 66),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    
        self.layer.cornerRadius = 16
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TDListHeader: UIView {
    private let label = UILabel(frame: .zero)
    private let topNavBar = UIView(frame: .zero)
    private let freeView = UIView(frame: .zero)
    let doneCount = UILabel(frame: .zero)
    let showButton = UIButton(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Мои дела"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .black
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            label.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        addSubview(topNavBar)
        topNavBar.translatesAutoresizingMaskIntoConstraints = false
        topNavBar.backgroundColor = .clear
        NSLayoutConstraint.activate([
            topNavBar.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 19),
            topNavBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            topNavBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            topNavBar.heightAnchor.constraint(equalToConstant: 25),
        ])
        
        topNavBar.addSubview(doneCount)
        doneCount.text = "Выполнено - 5"
        doneCount.translatesAutoresizingMaskIntoConstraints = false
        doneCount.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        doneCount.textColor = ToDoAppColors.middleGreyColor
        NSLayoutConstraint.activate([
            doneCount.centerYAnchor.constraint(equalTo: topNavBar.centerYAnchor),
            doneCount.leadingAnchor.constraint(equalTo: topNavBar.leadingAnchor)
        ])
        
        topNavBar.addSubview(showButton)
        showButton.setTitle("Показать", for: .normal)
        showButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        showButton.setTitleColor(ToDoAppColors.blueColor, for: .normal)
        showButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showButton.centerYAnchor.constraint(equalTo: topNavBar.centerYAnchor),
            showButton.trailingAnchor.constraint(equalTo: topNavBar.trailingAnchor),
        ])
        
        addSubview(freeView)
        freeView.translatesAutoresizingMaskIntoConstraints = false
        freeView.backgroundColor = .clear
        NSLayoutConstraint.activate([
            freeView.topAnchor.constraint(equalTo: topNavBar.bottomAnchor),
            freeView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            freeView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            freeView.heightAnchor.constraint(equalToConstant: 12),
            freeView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
