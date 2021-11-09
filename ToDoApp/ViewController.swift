//
//  ViewController.swift
//  ToDoApp
//
//  Created by Андрей on 22.10.2021.
//

import UIKit

class ToDoAppColors {
    static let mainBackgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    static let lightGreyColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    static let middleGreyColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    static let blueColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
}

final class ViewController: UIViewController {
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
    
    private var todo : ToDoItem!
    var isTextFieldEmpty : Bool = true
    private lazy var dateFormatter : DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        df.dateFormat = "dd MMMM y"
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK:- Initialize UI
        initializeUI()
        
        //MARK:- initialize to-do
        todo = ToDoItem(text: "", importance: Importance.ordinary)
    }
    
    func initializeUI() {
        //MARK:- text field setup
        tdTextField.backgroundColor = .white
        tdTextField.layer.backgroundColor = ToDoAppColors.mainBackgroundColor.cgColor
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
        isTextFieldEmpty = true
        
        //MARK:- importance picker setup
        prioritySwitcher.selectedSegmentIndex = 1
        
        //MARK:- separator setup
        settingsSeparator.layer.backgroundColor = ToDoAppColors.lightGreyColor.cgColor
        settingsSeparator2.layer.backgroundColor = ToDoAppColors.lightGreyColor.cgColor
        settingsSeparator2.isHidden = true

        //MARK:- settings section setup
        tdSettingsStack.backgroundColor = .white
        tdSettingsStack.layer.backgroundColor = ToDoAppColors.mainBackgroundColor.cgColor
        tdSettingsStack.layer.cornerRadius = 16
        
        //MARK:- delete button setup
        deleteTDButton.backgroundColor = .white
        deleteTDButton.layer.backgroundColor = ToDoAppColors.mainBackgroundColor.cgColor
        deleteTDButton.layer.cornerRadius = 16
        deleteTDButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        deleteTDButton.setTitleColor(ToDoAppColors.middleGreyColor, for: .normal)
        
        //MARK:- save button setup
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        saveButton.setTitleColor(ToDoAppColors.middleGreyColor, for: .normal)
        
        //MARK:- save button interaction handler
        saveButton.addTarget(self, action: #selector(didButtonClick), for: .touchUpInside)
        
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cancelButton.setTitleColor(ToDoAppColors.blueColor, for: .normal)
        
        //MARK:- deadline switch interaction handler
        datePicker.isHidden = true
        deadlineSwitcher.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        //MARK:- deadline label setup
        pickedDeadlineDate.isHidden = true
        pickedDeadlineDate.textColor = ToDoAppColors.blueColor
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.actionTapped(_:)))
        pickedDeadlineDate?.isUserInteractionEnabled = true
        pickedDeadlineDate?.addGestureRecognizer(tapAction)
        
        //MARK:- date picker interaction handler
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        
    }
    
    @objc func didButtonClick(_ sender: UIButton) {
        let prIndex = prioritySwitcher.selectedSegmentIndex
        switch prIndex {
            case 0:
                todo.setImportance(.low)
            case 1:
                todo.setImportance(.ordinary)
            case 2:
                todo.setImportance(.high)
            default:
                print("Bad to-do exception")
        }
        
        if !self.isTextFieldEmpty {
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
        pickedDeadlineDate.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func actionTapped(_ sender: UITapGestureRecognizer) {
        let shown = datePicker.isHidden
        
        datePicker.isHidden = !shown
        settingsSeparator2.isHidden = !shown
    }
}

extension ViewController : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            textView.text = "Что нужно сделать?"
            textView.textColor = UIColor.lightGray
            saveButton.setTitleColor(ToDoAppColors.middleGreyColor, for: .normal)
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            isTextFieldEmpty = true
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
         else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            saveButton.setTitleColor(ToDoAppColors.blueColor, for: .normal)
            textView.textColor = UIColor.black
            textView.text = text
            isTextFieldEmpty = false
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
