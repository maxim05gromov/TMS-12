//
//  editorViewController.swift
//  HW12
//
//  Created by Максим Громов on 02.08.2024.
//

import UIKit

class EditorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return interests.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(label)
        label.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 16).isActive = true
        
        label.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        if indexPath.section == 0 && indexPath.row == 0{
            label.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: 16).isActive = true
            label.text = "Добавить"
        } else if indexPath.section == 1{
            let button = UIButton()
            cell.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: 0).isActive = true
            button.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            button.widthAnchor.constraint(equalToConstant: 50).isActive = true
            label.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: 16).isActive = true
            button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
            label.text = interests[indexPath.row]
        }
        label.textColor = .black
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0{
            showAlert()
        }else{
            showAlert(index: indexPath.row)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    func showAlert(index: Int? = nil){
        let alert = UIAlertController(title: "Добавить интересы", message: "Введите новый интерес", preferredStyle: .alert)
        alert.addTextField()
        if let index{
            alert.textFields?.first?.text = interests[index]
        }
        let action = UIAlertAction(title: "Добавить", style: .default) { _ in
            guard let text = alert.textFields?.first?.text else {return}
            if let index{
                self.interests[index] = text
                self.table.reloadRows(at: [IndexPath(row: index, section: 1)], with: .automatic)
            }else{
                self.interests.append(text)
                self.table.reloadData()
            }
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
            self.interests.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        return .init(actions: [deleteAction])
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var birthdayView: UIView!
    @IBOutlet weak var textView: UIView!
    weak var delegate: EditorViewControllerDelegate?
    enum Field{
        case name
        case secondName
        case age
        case gender
        case birthday
        case interesting
    }
    var type: Field = .name
    var textPlaceholder: String = ""
    var birthdayPlaceholder: Date?
    
    var interests: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        switch type {
        case .name:
            navigationItem.title = "Имя"
            label.text = "Введите Ваше имя"
            textView.isHidden = false
            textField.placeholder = textPlaceholder
        case .secondName:
            navigationItem.title = "Фамилия"
            label.text = "Введите Вашу фамилию"
            textView.isHidden = false
            textField.placeholder = textPlaceholder
        case .age:
            navigationItem.title = "Возраст"
            label.text = "Введите Ваш возраст"
            textField.keyboardType = .numberPad
            textView.isHidden = false
            textField.placeholder = textPlaceholder
        case .gender:
            navigationItem.title = "Пол"
            genderView.isHidden = false
        case .birthday:
            if let birthdayPlaceholder{
                datePicker.date = birthdayPlaceholder
            }
            navigationItem.title = "День рождения"
            birthdayView.isHidden = false
        case .interesting:
            table.isHidden = false
            navigationItem.title = "Интересы"
            
        }
        // Do any additional setup after loading the view.
    }
    func configure(type: Field){
        self.type = type
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        switch type {
        case .name:
            delegate?.changeName(name: textField.text ?? "")
        case .secondName:
            delegate?.changeSecondName(secondName: textField.text ?? "")
        case .age:
            guard let text = textField.text else {return}
            delegate?.changeAge(age: Int(text, radix: 10) ?? 0)
        case .gender:
            delegate?.changeGender(isMale: segmentedControl.selectedSegmentIndex == 0)
        case .birthday:
            delegate?.changeBirtday(date: datePicker.date)
        case .interesting:
            delegate?.changeInterests(interests: interests)
        }
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol EditorViewControllerDelegate: AnyObject{
    func changeBirtday(date: Date)
    func changeName(name: String)
    func changeSecondName(secondName: String)
    func changeAge(age: Int)
    func changeGender(isMale: Bool)
    func changeInterests(interests: [String])
}
