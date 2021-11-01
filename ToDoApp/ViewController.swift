//
//  ViewController.swift
//  ToDoApp
//
//  Created by Андрей on 22.10.2021.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var tdTextField: UITextView!
    @IBOutlet weak var tdSettingsStack: UIStackView!
    @IBOutlet weak var deleteTDButton: UIButton!
    
    @IBOutlet weak var prioritySwitcher: UISegmentedControl!
    
    @IBOutlet weak var settingsSeparator: UIView!
    @IBOutlet weak var settingsSeparator2: UIView!
    @IBOutlet weak var deadlinePickerStack: UIStackView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var deadlineSwitcher: UISwitch!
    @IBOutlet weak var pickedDeadlineDate: UILabel!
    
    var todo : ToDoItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK:- text field setup
        tdTextField.backgroundColor = .white
        tdTextField.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        tdTextField.layer.cornerRadius = 16
        tdTextField.textContainer.lineFragmentPadding = 0
        tdTextField.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        tdTextField.font = UIFont.systemFont(ofSize: 17)
        
        //MARK:- placeholder setup
        self.tdTextField.delegate = self
        tdTextField.text = "Что нужно сделать?"
        tdTextField.textColor = UIColor.lightGray
        tdTextField.becomeFirstResponder()
        tdTextField.selectedTextRange = tdTextField.textRange(from: tdTextField.beginningOfDocument,
                                                              to: tdTextField.beginningOfDocument)
        
        //MARK:- importance picker setup
        prioritySwitcher.selectedSegmentIndex = 1
        
        //MARK:- separator setup
        settingsSeparator.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        settingsSeparator2.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        settingsSeparator2.isHidden = true

        //MARK:- settings section setup
        tdSettingsStack.backgroundColor = .white
        tdSettingsStack.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        tdSettingsStack.layer.cornerRadius = 16
        
        //MARK:- delete button setup
        deleteTDButton.backgroundColor = .white
        deleteTDButton.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        deleteTDButton.layer.cornerRadius = 16
        deleteTDButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        deleteTDButton.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.3), for: .normal)
        
        //MARK:- save button setup
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        saveButton.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.3), for: .normal)
        
        //MARK:- save button interaction handler
        saveButton.addTarget(self, action: #selector(didButtonClick), for: .touchUpInside)
        
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cancelButton.setTitleColor(UIColor(red: 0, green: 0.478, blue: 1, alpha: 1), for: .normal)
        
        //MARK:- deadline switch interaction handler
        datePicker.isHidden = true
        deadlineSwitcher.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        //MARK:- deadline label setup
        pickedDeadlineDate.isHidden = true
        pickedDeadlineDate.textColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.actionTapped(_:)))
        pickedDeadlineDate?.isUserInteractionEnabled = true
        pickedDeadlineDate?.addGestureRecognizer(tapAction)
        
        //MARK:- date picker interaction handler
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        
        //MARK:- initialize to-do
        todo = ToDoItem(text: "", importance: Importance.ordinary)
    }
    
    @objc func didButtonClick(_ sender: UIButton) {
        let prIndex = prioritySwitcher.selectedSegmentIndex
        switch prIndex {
            case 0:
                todo.setImportance(Importance.low)
            case 1:
                todo.setImportance(Importance.ordinary)
            case 2:
                todo.setImportance(Importance.high)
            default:
                print("Bad to-do exception")
        }
        
        if tdTextField.textColor != UIColor.lightGray {
            todo.setText(tdTextField.text)
        } else {
            todo.setText("")
        }
        
        if(deadlineSwitcher.isOn) {
            todo.setDeadline(datePicker.date)
        } else {
            todo.setDeadline(nil)
        }
        
        print("""
            Saved changes:
            Text is now: \(todo.text)
            Importance is now: \(todo.importance)
            Deadline is now: \(String(describing: todo.deadline))\n
            """)
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        let hasDeadline = mySwitch.isOn
        
        if(hasDeadline) {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.dateFormat = "dd MMMM y"
            datePicker.isHidden = false
            pickedDeadlineDate.text = dateFormatter.string(from: datePicker.date)
            pickedDeadlineDate.isHidden = false
            settingsSeparator2.isHidden = false
        } else {
            datePicker.isHidden = true
            pickedDeadlineDate.isHidden = true
            settingsSeparator2.isHidden = true
        }
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM y"
        pickedDeadlineDate.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func actionTapped(_ sender: UITapGestureRecognizer) {
        let shown = datePicker.isHidden
        
        datePicker.isHidden = !shown
        settingsSeparator2.isHidden = !shown
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            textView.text = "Что нужно сделать?"
            textView.textColor = UIColor.lightGray
            saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            saveButton.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.3), for: .normal)
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
         else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            saveButton.setTitleColor(UIColor(red: 0, green: 0.478, blue: 1, alpha: 1), for: .normal)
            textView.textColor = UIColor.black
            textView.text = text
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}

