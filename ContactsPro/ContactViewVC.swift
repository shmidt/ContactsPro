//
//  ContactDetailVC.swift
//  ContactsPro
//
//  Created by Dmitry Shmidt on 09/04/15.
//  Copyright (c) 2015 Dmitry Shmidt. All rights reserved.
//

import UIKit
import RealmSwift

class ContactViewVC: UITableViewController {
    private var notificationToken: NotificationToken?
    
    var person: Person!
    
    private lazy var dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        
        return dateFormatter
        }()
    
    deinit{
        let realm = Realm()
        
        if let notificationToken = notificationToken{
            realm.removeNotification(notificationToken)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.accessibilityLabel = "View Contact"
        tableView.accessibilityValue = person.fullName
        tableView.isAccessibilityElement = true
        
        tableView.tableFooterView = UIView()
        title = person.fullName
        
        setupTableViewUI()
        
        registerFormCells()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editVC")
        
        reloadData()
        
        notificationToken = Realm().addNotificationBlock {[unowned self] note, realm in
            println(ContactViewVC.self)
            println(note)
            //            self.objects = self.array
            self.reloadData()
        }
    }

    func editVC(){
        let vc = storyboard?.instantiateViewControllerWithIdentifier("ContactEditVC") as! ContactEditVC
        vc.person = person
        let nc = UINavigationController(rootViewController: vc)
        presentViewController(nc, animated: true, completion: nil)
    }
    
    func setupTableViewUI(){
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        switch section{
            
        case Section.Notes:

                let note = person.notes[indexPath.row]
                
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.TableViewCell.LabelTextTableViewCellID, forIndexPath: indexPath) as! LabelTextTableViewCell
                cell.label.text = dateFormatter.stringFromDate(note.date)
                cell.selectionStyle = .None
                cell.valueTextLabel.text = note.text
                return cell
            
        case Section.WeakPoints:
                let note = person.weakPoints[indexPath.row]
                
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.TableViewCell.LabelTextTableViewCellID, forIndexPath: indexPath) as! LabelTextTableViewCell
                cell.label.text = dateFormatter.stringFromDate(note.date)
                cell.selectionStyle = .None
                cell.valueTextLabel.text = note.text
                
                return cell
            
        case Section.StrongPoints:
 
                let note = person.strongPoints[indexPath.row]
                
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.TableViewCell.LabelTextTableViewCellID, forIndexPath: indexPath) as! LabelTextTableViewCell
                cell.label.text = dateFormatter.stringFromDate(note.date)
                cell.selectionStyle = .None
                cell.valueTextLabel.text = note.text
                return cell
                
            
        case Section.ToDo:
                let todo = person.todos[indexPath.row]
                
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.TableViewCell.ListItemCell, forIndexPath: indexPath) as! ListItemCell
                cell.textValue = todo.text
                cell.isComplete = todo.isComplete
                cell.textField.enabled = false
                cell.didTapCheckBox({[unowned self] (completed) -> Void in
                    println("didTapCheckBox")

                    let realm = Realm()
                    realm.beginWrite()
                    todo.isComplete = completed
                    realm.commitWrite()
                })
                
                return cell
        default:()
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.TableViewCell.DefaultCellID, forIndexPath: indexPath) as! UITableViewCell
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        
        switch section{
            
        case Section.WeakPoints:
            rows = person.weakPoints.count
            
        case Section.StrongPoints:
            rows = person.strongPoints.count
            
        case Section.Notes:
            rows = person.notes.count
            
        case Section.ToDo:
            rows = person.todos.count
            
        default:
            rows = 0
        }
        
        return rows
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("didSelectRowAtIndexPath")
        let section = indexPath.section
        if section == Section.ToDo{
            let todo = person.todos[indexPath.row]
            let realm = Realm()
            realm.beginWrite()
            todo.isComplete = !todo.isComplete
            realm.commitWrite()
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !editing{
            switch section{
            case Section.Notes:
                if person.notes.count == 0{
                    return nil
                }
            case Section.StrongPoints:
                if person.strongPoints.count == 0{
                    return nil
                }
            case Section.WeakPoints:
                if person.weakPoints.count == 0{
                    return nil
                }
            case Section.ToDo:
                if person.todos.count == 0{
                    return nil
                }
            default:
                return sectionNames[section]
            }
        }
        
        return sectionNames[section]
    }
    
    //MARK: -
    
    func reloadData(){
        
        tableView.reloadData()
    }
    
    func registerFormCells(){

        tableView.registerNib(UINib(nibName: Constants.TableViewCell.ListItemCell, bundle: nil), forCellReuseIdentifier: Constants.TableViewCell.ListItemCell)

        tableView.registerNib(UINib(nibName: Constants.TableViewCell.LabelTextTableViewCellID, bundle: nil), forCellReuseIdentifier: Constants.TableViewCell.LabelTextTableViewCellID)
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: Constants.TableViewCell.DefaultCellID)
    }
}
