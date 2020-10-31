//
//  ViewController.swift
//  lab2
//
//  Created by Yulia Miloserdova on 10/7/20.
//  Copyright © 2020 Yulia Miloserdova. All rights reserved.
//
import UserNotifications
import UIKit
import Foundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    @IBOutlet var table: UITableView!
    @IBOutlet weak var Calendar: UICollectionView!
    @IBOutlet weak var MonthLabel: UILabel!
    
    let Months =
        ["January", "February", "March", "April" , "May", "June", "July", "August", "September", "October", "November", "December"]
    let DaysOfMonth = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var DaysInMonths = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonth = String()
    
    
    var NumberOfEmptyBox = Int()
    
    var NextNumberOfEmptyBox = Int()
    
    var PreviousNumberOfEmptyBox = 0
    
    var Direction = 0
    
    var PositionIndex = 0
    
    var LeapYearCounter = 2
    
    var dayCounter = 0
    
    
    var models = [MyReminder]()
    
    
    
    
    override func viewDidLoad() {
              super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
              // Do any additional setup after loading the view.
              currentMonth = Months[month]
              MonthLabel.text = "\(currentMonth) \(year)"
              if weekday == 0 {
                  weekday = 7
              }
              GetStartDateDayPosition()
        
        
          }
    
    @IBAction func didTapAdd (){
        //show addviewcontroller
        
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else{
            return
        }
        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = {title, body, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = MyReminder(title: title, date: date, identifier:  "id_\(title)")
                self.models.append(new)
                self.table.reloadData()
                
                
                let content = UNMutableNotificationContent()
                       
                       content.title = title
                       content.sound = .default
                       content.body = body
                    
                      
                      let targetDate = date
                       
                       let component = calendar.dateComponents([.year,.day,.month,.hour,.minute,.second], from: targetDate)
                       print(component)
                      let trigger = UNCalendarNotificationTrigger(dateMatching: component,
                                                                  repeats: false)

                      let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                      UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                          if error != nil {
                              print("something went wrong")
                          }
                        })
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    
    @IBAction func didTapTest (){
               //fire test notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {success, error in
            
            if success{
                //schedule test
                self.scheduleTest()
                
            }else if error != nil {
                print("error occured")
            }
        })
           }
    
    
    func scheduleTest() {
        let content = UNMutableNotificationContent()
        
        content.title = "Hello World"
        content.sound = .default
        content.body = "My long body. My long body. My long body. My long body. My long body. My long body. "
        
       
       let targetDate = Date().addingTimeInterval(10)
        
        let component = calendar.dateComponents([.year,.day,.month,.hour,.minute,.second], from: targetDate)
        print(component)
       let trigger = UNCalendarNotificationTrigger(dateMatching: component,
                                                   repeats: false)

       let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
       UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
           if error != nil {
               print("something went wrong")
           }
         })
    }
    
    
    
       func GetStartDateDayPosition() {
              switch Direction{
              case 0:
                  NumberOfEmptyBox = weekday
                  dayCounter = day
                  while dayCounter>0 {
                      NumberOfEmptyBox = NumberOfEmptyBox - 1
                      dayCounter = dayCounter - 1
                      if NumberOfEmptyBox == 0 {
                          NumberOfEmptyBox = 7
                      }
                  }
                  if NumberOfEmptyBox == 7 {
                      NumberOfEmptyBox = 0
                  }
                  PositionIndex = NumberOfEmptyBox
              case 1...:
                  NextNumberOfEmptyBox = (PositionIndex + DaysInMonths[month])%7
                  PositionIndex = NextNumberOfEmptyBox
                  
              case -1:
                  PreviousNumberOfEmptyBox = (7 - (DaysInMonths[month] - PositionIndex)%7)
                  if PreviousNumberOfEmptyBox == 7 {
                      PreviousNumberOfEmptyBox = 0
                  }
                  PositionIndex = PreviousNumberOfEmptyBox
              default:
                  fatalError()
              }
          }
       
    
    @IBAction func Next(_ sender: Any) {
        
       switch currentMonth {
            case "December":
                Direction = 1

                month = 0
                year += 1
                
                if LeapYearCounter  < 5 {
                    LeapYearCounter += 1
                }
                
                if LeapYearCounter == 4 {
                    DaysInMonths[1] = 29
                }
                
                if LeapYearCounter == 5{
                    LeapYearCounter = 1
                    DaysInMonths[1] = 28
                }
                GetStartDateDayPosition()
                
                currentMonth = Months[month]
                MonthLabel.text = "\(currentMonth) \(year)"
                
                Calendar.reloadData()
            default:
                Direction = 1
                
                GetStartDateDayPosition()
                
                month += 1

                currentMonth = Months[month]
                MonthLabel.text = "\(currentMonth) \(year)"
              
                Calendar.reloadData()
            }
        
    }
    
    @IBAction func Back(_ sender: Any) {
         switch currentMonth {
               case "January":
                   Direction = -1

                   month = 11
                   year -= 1
                   
                   if LeapYearCounter > 0{
                       LeapYearCounter -= 1
                   }
                   if LeapYearCounter == 0{
                       DaysInMonths[1] = 29
                       LeapYearCounter = 4
                   }else{
                       DaysInMonths[1] = 28
                   }
                   
                   GetStartDateDayPosition()
                   
                   currentMonth = Months[month]
                   MonthLabel.text = "\(currentMonth) \(year)"
                   Calendar.reloadData()
                   
               default:
                   Direction = -1

                   month -= 1
                   
                   GetStartDateDayPosition()
                   
                   currentMonth = Months[month]
                   MonthLabel.text = "\(currentMonth) \(year)"
                   Calendar.reloadData()
               }
    }
    
   
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          switch Direction{
           case 0:
               return DaysInMonths[month] + NumberOfEmptyBox
           case 1...:
               return DaysInMonths[month] + NextNumberOfEmptyBox
           case -1:
               return DaysInMonths[month] + PreviousNumberOfEmptyBox
           default:
               fatalError()
           }
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        
        cell.backgroundColor = UIColor.clear
        cell.DateLabel.textColor = UIColor.black
        
//        cell.Circle.isHidden = true
        
        if cell.isHidden{
            cell.isHidden = false
        }
        
        switch Direction {      //the first cells that needs to be hidden (if needed) will be negative or zero so we can hide them
        case 0:
            cell.DateLabel.text = "\(indexPath.row + 1 - NumberOfEmptyBox)"
        case 1:
            cell.DateLabel.text = "\(indexPath.row + 1 - NextNumberOfEmptyBox)"
        case -1:
            cell.DateLabel.text = "\(indexPath.row + 1 - PreviousNumberOfEmptyBox)"
        default:
            fatalError()
        }
        
        if Int(cell.DateLabel.text!)! < 1{ //here we hide the negative numbers or zero
            cell.isHidden = true}
        
        switch indexPath.row { //weekend days color
        case 5,6,12,13,19,20,26,27,33,34:
            if Int(cell.DateLabel.text!)! > 0 {
                cell.DateLabel.textColor = UIColor.lightGray
            }
        default:
            break
        }
        if currentMonth == Months[calendar.component(.month, from: date) - 1] && year == calendar.component(.year, from: date) && indexPath.row + 1 - NumberOfEmptyBox == day{
           
            cell.backgroundColor = UIColor.red
           // cell.Circle.isHidden = false
           // cell.DrawCircle()
            }
     
        
      //  if currentMonth == Months[models.indexPath(.month, from: Inde ) - 1] && year == calendar.component(.year, from: date) && indexPath.row + 1 - NumberOfEmptyBox == day{
                  
               //    cell.backgroundColor = UIColor.red
            
                //   }
        return cell
       }

}



//таблица



extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
extension ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        
        
        //сохранение
      //  UserDefaults.standard.set(models[indexPath.row].title, forKey: "saved")
    //    models[indexPath.row].title = ""
        
       
        let date = models[indexPath.row].date
        let formatter =  DateFormatter()
        formatter.dateFormat = " MMM, dd, YYYY hh:mm a"
        
        cell.detailTextLabel?.text = formatter.string(from:  date)
        
        return cell
    }
    
    
   // override func viewDidAppear(_ animated: Bool) {
     
//        if let x = UserDefaults.standard.object(forKey: "saved" ) as? String {
 //          cell.detailTextLabel?.text = x
//        }
//    }
}

struct MyReminder {
    var title: String
    let date: Date
    let identifier: String
    
}
