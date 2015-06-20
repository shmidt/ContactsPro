//
//  ContactEditVC.swift
//  ContactsPro
//
//  Created by Dmitry Shmidt on 17/04/15.
//  Copyright (c) 2015 Dmitry Shmidt. All rights reserved.
//

import UIKit
import RealmSwift

class ContactEditVC: UITableViewController {
    
    var person: Person!
    
    private lazy var dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        
        return dateFormatter
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.accessibilityLabel = "Edit Contact"
        tableView.accessibilityValue = person.fullName
        tableView.isAccessibilityElement = true
        
        tableView.tableFooterView = UIView()
        editing = true
        title = person.fullName
        
        setupTableViewUI()
        
        registerFormCells()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "closeVC")
        
    }
    
    func closeVC(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    func setupTableViewUI(){
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.allowsSelectionDuringEditing = true
        
        tableView.keyboardDismissMode = .Interactive
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
            if indexPath.row < person.notes.count{
                let note = person.notes[indexPath.row]
                
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.TableViewCell.EditLongTextCellID, forIndexPath: indexPath) as! EditLongTextTableViewCell
                cell.label = dateFormatter.stringFromDate(note.date)
                cell.longText = note.text
                cell.pick({ (longText) -> Void in
                    if !note.invalidated{
                    let realm = Realm()
                    realm.beginWrite()
                    note.text = longText
                    realm.commitWrite()
                    }
                })
                return cell
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.TableViewCell.AddButtonCellID, forIndexPath: indexPath) as! AddButtonTableViewCell
                cell.label.text = "add note"
                cell.accessibilityLabel = "add note cell"
                return cell
            }
        case Section.WeakPoints:
            if indexPath.row < person.weakPoints.count{
                let note = person.weakPoints[indexPath.row]
                
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.TableViewCell.EditLongTextCellID, forIndexPath: indexPath) as! EditLongTextTableViewCell
                cell.longText = note.text
                cell.label = dateFormatter.stringFromDate(note.date)
                cell.pick({ (longText) -> Void in
                    if !note.invalidated{
                        let realm = Realm()
                        realm.beginWrite()
                        note.text = longText
                        realm.commitWrite()
                    }
                })
                return cell
                
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.TableViewCell.AddButtonCellID, forIndexPath: indexPath) as! AddButtonTableViewCell
                cell.label.text = "add weak point"
                cell.accessibilityLabel = "add weak point cell"
                
                return cell
            }
        case Section.StrongPoints:
            if indexPath.row < person.strongPoints.count{
                let note = person.strongPoints[indexPath.row]
                
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.TableViewCell.EditLongTextCellID, forIndexPath: indexPath) as! EditLongTextTableViewCell
                cell.longText = note.text
                cell.label = dateFormatter.stringFromDate(note.date)
                cell.pick({ (longText) -> Void in
                    if !note.invalidated{
                    let realm = Realm()
                    realm.beginWrite()
                    note.text = longText
                    realm.commitWrite()
                    }
                })
                return cell
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.TableViewCell.AddButtonCellID, forIndexPath: indexPath) as! AddButtonTableViewCell
                cell.label.text = "add strong point"
                cell.accessibilityLabel = "add strong point cell"
                return cell
            }
        case Section.ToDo:
            if indexPath.row < person.todos.count{
                let todo = person.todos[indexPath.row]
                
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.TableViewCell.ListItemCell, forIndexPath: indexPath) as! ListItemCell
                cell.textValue = todo.text
                cell.isComplete = todo.isComplete
                
                cell.pickText({ [unowned self] (text) -> Void in
                    let realm = Realm()
                    realm.beginWrite()
                    if !text.isEmpty{

                        todo.text = text

                    }else{
                        //TODO: Delete todo
                        realm.delete(todo)
                    }
                    realm.commitWrite()
                })

                return cell
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.TableViewCell.EditTextCellID, forIndexPath: indexPath) as! EditTextTableViewCell
                cell.label = "add to do item"
                cell.accessibilityLabel = "add todo cell"
                cell.pickText({ [unowned self] (text) -> Void in
                    if !text.isEmpty{
                        self.addToDo(text: text)
                    }
                })
                return cell
            }
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
        
        return ++rows
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        
        switch section {
        case Section.Notes:
            if editingStyle == .Delete{
                let note = person.notes[indexPath.row]
//                person.notes.removeAtIndex(indexPath.row)
                let realm = Realm()
                realm.write({ () -> Void in
                    realm.delete(note)
                })
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }else if editingStyle == .Insert{
                addNote()
            }
        case Section.WeakPoints:
            if editingStyle == .Delete{
                let note = person.weakPoints[indexPath.row]

                let realm = Realm()
                realm.write({ () -> Void in
                    realm.delete(note)
                })
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }else if editingStyle == .Insert{
                addWeakPoint()
            }
        case Section.StrongPoints:
            if editingStyle == .Delete{
                let note = person.strongPoints[indexPath.row]

                let realm = Realm()
                realm.write({ () -> Void in
                    realm.delete(note)
                })
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }else if editingStyle == .Insert{
                addStrongPoint()
            }
        case Section.ToDo:
            if editingStyle == .Delete{
                let todo = person.todos[indexPath.row]

                let realm = Realm()
                realm.write({ () -> Void in
                    realm.delete(todo)
                })
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }else if editingStyle == .Insert{
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! EditTextTableViewCell
                addToDo(text: cell.textValue)

            }
        default:
            return
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("didSelectRowAtIndexPath")
        let section = indexPath.section
        
        switch section{
            
        case Section.Notes:
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
            if editing && indexPath.row == person.notes.count{
                addNote()
            }
            
        case Section.StrongPoints:
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
            if editing && indexPath.row == person.strongPoints.count{
                addStrongPoint()
            }
            
        case Section.WeakPoints:
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
            if editing && indexPath.row == person.weakPoints.count{
                addWeakPoint()
            }else{
                
            }
        default:()
        }
        
    }
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        let section = indexPath.section
        if editing{
            switch section{
            case Section.Notes:
                return indexPath.row < person.notes.count ? .Delete : .Insert
            case Section.WeakPoints:
                return indexPath.row < person.weakPoints.count ? .Delete : .Insert
            case Section.StrongPoints:
                return indexPath.row < person.strongPoints.count ? .Delete : .Insert
            case Section.ToDo:
                return indexPath.row < person.todos.count ? .Delete : .Insert
                
            default:
                return .None
            }
        }else {
            return .None
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
            default:
                return sectionNames[section]
            }
        }
        
        return sectionNames[section]
    }
    //MARK: - Helpers

    func addNote(){
        let realm = Realm()
        let note = Note()
        tableView.beginUpdates()
        realm.write {[unowned self] () -> Void in
            
            realm.add(note)
            self.person.notes.append(note)
        }

        let ip = NSIndexPath(forRow: (person.notes.count - 1), inSection: Section.Notes)
        tableView.insertRowsAtIndexPaths([ip], withRowAnimation: .Top)
        tableView.endUpdates()
        
        tableView.scrollToRowAtIndexPath(ip, atScrollPosition: .Bottom, animated: true)
        if let insertedCell = tableView.cellForRowAtIndexPath(ip) as? EditLongTextTableViewCell{
            insertedCell.textView.becomeFirstResponder()
        }
    }
    
    func addStrongPoint(){
        let realm = Realm()
        let note = SimpleNote()
        tableView.beginUpdates()
        realm.write {[unowned self] () -> Void in
            
            realm.add(note)
            self.person.strongPoints.append(note)
        }
        
        let ip = NSIndexPath(forRow: (person.strongPoints.count - 1), inSection: Section.StrongPoints)
        tableView.insertRowsAtIndexPaths([ip], withRowAnimation: .Top)
        tableView.endUpdates()

        tableView.scrollToRowAtIndexPath(ip, atScrollPosition: .Bottom, animated: true)
        let insertedCell = tableView.cellForRowAtIndexPath(ip) as! EditLongTextTableViewCell
        insertedCell.textView.becomeFirstResponder()
    }
    
    func addWeakPoint(){
        let realm = Realm()
        let note = SimpleNote()
        tableView.beginUpdates()
        realm.write {[unowned self] () -> Void in
            
            realm.add(note)
            self.person.weakPoints.append(note)
        }
        
        let ip = NSIndexPath(forRow: (person.weakPoints.count - 1), inSection: Section.WeakPoints)
        tableView.insertRowsAtIndexPaths([ip], withRowAnimation: .Top)
        tableView.endUpdates()
        
        let newIp = NSIndexPath(forRow: person.weakPoints.count, inSection: Section.WeakPoints)
        tableView.scrollToRowAtIndexPath(newIp, atScrollPosition: .Bottom, animated: true)
        let insertedCell = tableView.cellForRowAtIndexPath(ip) as! EditLongTextTableViewCell
        insertedCell.textView.becomeFirstResponder()
    }
    
    func addToDo(#text:String){
        let realm = Realm()
        let todo = ToDo()
        tableView.beginUpdates()
        realm.write {[unowned self] () -> Void in
            todo.text = text
            realm.add(todo)
            self.person.todos.append(todo)
        }
        
        let ip = NSIndexPath(forRow: (person.todos.count - 1), inSection: Section.ToDo)
        tableView.insertRowsAtIndexPaths([ip], withRowAnimation: .Top)
        tableView.endUpdates()
        
        let newIp = NSIndexPath(forRow: person.todos.count, inSection: Section.ToDo)
        tableView.scrollToRowAtIndexPath(newIp, atScrollPosition: .Bottom, animated: true)
        let insertedCell = tableView.cellForRowAtIndexPath(ip) as! ListItemCell
    }
    
    // MARK: - Utilities
    
    func registerFormCells(){

        //Cells
        tableView.registerNib(UINib(nibName: Constants.TableViewCell.EditTextCellID, bundle: nil), forCellReuseIdentifier: Constants.TableViewCell.EditTextCellID)
        tableView.registerNib(UINib(nibName: Constants.TableViewCell.ButtonCellID, bundle: nil), forCellReuseIdentifier: Constants.TableViewCell.ButtonCellID)
        tableView.registerNib(UINib(nibName: Constants.TableViewCell.LabelTextTableViewCellID, bundle: nil), forCellReuseIdentifier: Constants.TableViewCell.LabelTextTableViewCellID)
        
        
        
        tableView.registerNib(UINib(nibName: Constants.TableViewCell.EditLongTextCellID, bundle: nil), forCellReuseIdentifier: Constants.TableViewCell.EditLongTextCellID)
        
        tableView.registerNib(UINib(nibName: Constants.TableViewCell.AddButtonCellID, bundle: nil), forCellReuseIdentifier: Constants.TableViewCell.AddButtonCellID)
        
        tableView.registerNib(UINib(nibName: Constants.TableViewCell.ListCellID, bundle: nil), forCellReuseIdentifier: Constants.TableViewCell.ListCellID)
        
        tableView.registerNib(UINib(nibName: Constants.TableViewCell.ListItemCell, bundle: nil), forCellReuseIdentifier: Constants.TableViewCell.ListItemCell)
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: Constants.TableViewCell.DefaultCellID)
    }

    
    func indexPathForView(view: UIView) -> NSIndexPath? {
        let viewOrigin = view.bounds.origin
        
        let viewLocation = tableView.convertPoint(viewOrigin, fromView: view)
        
        return tableView.indexPathForRowAtPoint(viewLocation)
    }
}
