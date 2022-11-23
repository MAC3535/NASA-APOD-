//
//  ViewController.swift
//  NASAapp
//
//  Created by Studio.C on 7/29/22.
//

import UIKit

// set up json for decoding
struct JSON : Codable {
    var date: String
    var explanation: String
    var url: String
}

// json answers
var answerDate = [String]()
var answerExplanation = [String]()
var answerUrl = [String]()


var testDate = ""

class ViewController: UIViewController {

    
    @IBOutlet var monthPicker: UIPickerView!
    @IBOutlet var yearPicker: UIPickerView!

    
    // array for pickers
    let monthArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let monthDictionary = ["January": "01", "February": "02", "March": "03", "April": "04", "May": "05", "June": "06", "July": "07", "August": "08", "September": "09", "October": "10", "November": "11", "December": "12"]
    var yearArray = [String]()
    
    let currentDate = Date.now
   
    // set up dates for months array
    let thirtyOneMonth = ["January","March","May","July","August","October","December"]
    let thirtyMonth = ["April","June","September","November"]
    // user selectino for api URL
    var monthSelection = ""
    var yearSelection = ""
    var userStartDate = ""
    var userEndDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // set uipicker delegate and data sources 
        monthPicker.delegate = self
        yearPicker.delegate = self
        monthPicker.dataSource = self
        yearPicker.dataSource = self
        
        let date = dateGetter(date: currentDate)
        let dates = 1995...returnDate(date: date)
        
        for i in dates {
            let string = returnStringDate(date: i)
            yearArray.append(string)
        }
        
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.hidesBarsOnTap = false
        
        print(answerDate.count)
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        // api call and loading screen
        if monthSelection == "" || yearSelection == "" {
            let ac = UIAlertController(title: "Oops!", message: "Please select Month and Year you would like to search.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            apiCall {
                self.performSegue(withIdentifier: "displaySegue", sender: self)
            }
        }

    }
    
    // date formatter, turn date into string
    func dateGetter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let dateFinal = formatter.string(from: date)
        return dateFinal
    }
    // change string date into integer for "for-in" loop
    func returnDate(date: String) -> Int {
        let myDateString = dateGetter(date: currentDate)
        let dateNumber = NumberFormatter().number(from: myDateString)
        let dateInteger = dateNumber?.intValue
        return dateInteger!
        
    }
    // change into back to string
    func returnStringDate(date: Int) -> String {
        let integer : Int = date
        return String(integer)
        
    }
    // func to find if leap year is true or false
    func leapYearChecker(year: String) -> Bool {
        if returnDate(date: year) % 4 == 0 {
            return true
        } else {
            return false
        }
    }
    
    // set up api call
    func apiCall(completion: @escaping () -> Void) {
        // year selection
        answerDate.removeAll()
        answerExplanation.removeAll()
        answerUrl.removeAll()
//        answerDate = [String]()
//        answerExplanation = [String]()
//        answerUrl = [String]()
        
        userSelectionGetter(selection: monthSelection)
        
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&start_date=\(userStartDate)&end_date=\(userEndDate)"
        
        let url = URL(string: urlString)
        
        guard let unwrappedURL = url else { fatalError("trouble with URL unwrapping") }
        
        let decoder = JSONDecoder()
        // user selection getter for api call
        if let data = try? Data(contentsOf: unwrappedURL) {
            if let json = try? decoder.decode([JSON].self, from: data) {
                
                for i in json {
                    answerDate.append(i.date)
                    answerUrl.append(i.url)
                    answerExplanation.append(i.explanation)
                }
                
                DispatchQueue.main.async {
                    completion()
                }
                
            }
        } else {
            print("Trouble with json parsing.", unwrappedURL)
        }
        
    }
    
    // set up user selection and conver it for URL api call
    func userSelectionGetter(selection: String) {
        
        if selection == "February" {
            if leapYearChecker(year: yearSelection) == true {
                userStartDate = "\(yearSelection)-\(monthDictionary["February"]!)-01"
                userEndDate = "\(yearSelection)-\(monthDictionary["February"]!)-29"
                print("one")
            } else {
                if leapYearChecker(year: yearSelection) == false {
                userStartDate = "\(yearSelection)-\(monthDictionary["February"]!)-01"
                userEndDate = "\(yearSelection)-\(monthDictionary["February"]!)-28"
                print("two")
                }
            }
        }
        if selection != "February" {
            for i in thirtyMonth {
                if i == selection {
                    userStartDate = "\(yearSelection)-\(monthDictionary[i]!)-01"
                    userEndDate = "\(yearSelection)-\(monthDictionary[i]!)-30"
                    print("three")
                    
                }
            }
            for i in thirtyOneMonth {
                if i == selection {
                    userStartDate = "\(yearSelection)-\(monthDictionary[i]!)-01"
                    userEndDate = "\(yearSelection)-\(monthDictionary[i]!)-31"
                    print("four")
                }
            }
        }
    }
    
}

// handles picker view
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return monthArray.count
        } else {
            return yearArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return monthArray[row]
        } else {
            return yearArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            monthSelection = monthArray[row]
            print(monthArray[row])
        } else {
            yearSelection = yearArray[row]
            print(yearArray[row])
        }
    }
    
    
    
}
