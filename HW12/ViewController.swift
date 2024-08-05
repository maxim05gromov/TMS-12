//
//  ViewController.swift
//  HW12
//
//  Created by Максим Громов on 02.08.2024.
//

import UIKit

class ViewController: UIViewController, EditorViewControllerDelegate {
    
    
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var interestsLabel: UILabel!
    enum Genders: String{
        case male = "Мужской"
        case female = "Женский"
    }
    var name: String?{
        didSet{
            nameLabel.text = "Имя: \(name ?? "")"
            UserDefaults.standard.setValue(name, forKey: "name")
        }
    }
    var secondName: String?{
        didSet{
            secondNameLabel.text = "Фамилия: \(secondName ?? "")"
            UserDefaults.standard.setValue(secondName, forKey: "secondName")
        }
    }
    var age: Int?{
        didSet{
            ageLabel.text = "Возраст: \(age ?? 0)"
            UserDefaults.standard.setValue(age, forKey: "age")
        }
    }
    var date: Date?{
        didSet{
            if date != nil{
                dateLabel.text = "Дата рождения: \(date!.formatted(date: .long, time: .omitted))"
            }
            UserDefaults.standard.setValue(date, forKey: "date")
        }
    }
    var gender: Genders?{
        didSet{
            UserDefaults.standard.setValue(gender?.rawValue, forKey: "gender")
            genderLabel.text = "Пол: \(gender?.rawValue ?? "")"
        }
    }
    var interests: [String] = []{
        didSet{
            UserDefaults.standard.setValue(interests, forKey: "interests")
            interestsLabel.text = "Список интересов: \(arrayToString(array: interests))"
        }
    }
    
    func changeInterests(interests: [String]) {
        self.interests = interests
    }
    func changeBirtday(date: Date) {
        self.date = date
    }
    
    func changeName(name: String) {
        self.name = name
    }
    
    func changeSecondName(secondName: String) {
        self.secondName = secondName
    }
    
    func changeAge(age: Int) {
        self.age = age
    }
    
    func changeGender(isMale: Bool) {
        if isMale{
            gender = .male
        }else{
            gender = .female
        }
    }
    
    func arrayToString(array: [String]) -> String{
        var result = ""
        for s in 0..<array.count{
            result += array[s]
            if s != array.count - 1{
                result += ", "
            }
        }
        return result
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        age = UserDefaults.standard.integer(forKey: "age")
        name = UserDefaults.standard.string(forKey: "name")
        secondName = UserDefaults.standard.string(forKey: "secondName")
        if let g = UserDefaults.standard.string(forKey: "gender"){
            gender = Genders(rawValue: g)
        }
        
        date = UserDefaults.standard.object(forKey: "date") as? Date
        interests = UserDefaults.standard.stringArray(forKey: "interests") ?? []
        
        // Do any additional setup after loading the view.
    }

    @IBAction func changeInfoButtonPressed(_ sender: UIButton) {
        guard let button = sender.restorationIdentifier else {return}
        let controller = storyboard?.instantiateViewController(withIdentifier: "editorViewController") as! EditorViewController
        controller.delegate = self
        switch button{
        case "nameButton":
            controller.configure(type: .name)
            controller.textPlaceholder = name ?? ""
            break
        case "secondNameButton":
            controller.configure(type: .secondName)
            controller.textPlaceholder = secondName ?? ""
            break
        case "ageButton":
            controller.configure(type: .age)
            controller.textPlaceholder = "\(age ?? 0)"
            break
        case "genderButton":
            controller.configure(type: .gender)
            break
        case "birthdayButton":
            controller.configure(type: .birthday)
            controller.birthdayPlaceholder = date
            break
        case "interestingButton":
            controller.configure(type: .interesting)
            controller.interests = interests
            break
        default:
            print("Unknown button pressed")
        }
        
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
}

