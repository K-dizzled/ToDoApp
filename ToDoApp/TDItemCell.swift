//
//  TDItemCell.swift
//  ToDoApp
//
//  Created by Андрей on 15.11.2021.
//

import Foundation
import UIKit

class TDItemCell: UITableViewCell {
    private var item: ToDoItem?
    private let completeButton = UIButton()
    private let labelStackView = UIStackView()
    private let itemLabel = UILabel()
    private let dateLabel = UILabel()
    private let calendarImage = UIImageView(image: UIImage(named: "calendar"))
    private let bottomBorder = UIView()
    private let tagStack = UIStackView()
    private let view = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Coder not implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
        
//        view.backgroundColor = .cyan
        //setCompleteButton()
        self.textLabel?.text = "Дело"
        self.detailTextLabel?.text = "25 января"
        self.imageView?.image = UIImage(named: "done_unchecked")
        
        contentView.addSubview(view)
    }
    
    func setCompleteButton() {
        let button = UIButton()
        button.setImage(UIImage(named: "done_unchecked"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 25
        
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            button.widthAnchor.constraint(equalToConstant: 24),
            button.heightAnchor.constraint(equalToConstant: 24),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}
