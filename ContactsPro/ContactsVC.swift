//  Created by Dmitry Shmidt on 18/01/15.
//  Copyright (c) 2015 Dmitry Shmidt. All rights reserved.
//
import UIKit
import RealmSwift

import AddressBook
import AddressBookUI

import MGSwipeTableCell

class ContactsVC: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate, ABPersonViewControllerDelegate, ABNewPersonViewControllerDelegate, MGSwipeTableCellDelegate{
    
    // note: if the contacts change behind your back while your app is open...
    // your retained address book will go out of date
    // unfortunately the way around that is to register an external change callback...
    // ...and you can't do that using Swift alone
    var predicate: NSPredicate?
    
    private let addressBookModel = AddressBookModel()

    private var searchController : UISearchController!
    private var searchResults: Results<Person>!

    private var array:Results<Person>{
        let realm = Realm()
        
        if let predicate = predicate{
            
            return realm.objects(Person).filter(predicate).sorted("firstName", ascending: true).sorted("lastName", ascending: true)
        }else{

            return realm.objects(Person).sorted("firstName", ascending: true).sorted("lastName", ascending: true)
        }
    }
    private var notificationToken: NotificationToken?
    
    private let collation = UILocalizedIndexedCollation.currentCollation() as! UILocalizedIndexedCollation
    private var sections: [[Person]] = []
    private var searchResultsSections: [[Person]] = []
    private var objects: Results<Person>! {
        didSet {
            let selector: Selector = "lastName"
            
            sections = [[Person]](count: collation.sectionTitles.count, repeatedValue: [])
            
            for object in array {
                let sectionNumber = collation.sectionForObject(object, collationStringSelector: selector)
                sections[sectionNumber].append(object)
            }

            tableView.reloadData()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.tabBarItem.image = UIImage(named: "groups")
        self.tabBarItem.selectedImage = UIImage(named: "groups-s")
        tabBarItem.title = NSLocalizedString("Contacts", comment: "Tab title")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.accessibilityLabel = "Contacts List"
        tableView.isAccessibilityElement = true
        
        addressBookModel.synchronize()

        setupUI()

        notificationToken = Realm().addNotificationBlock { note, realm in
            println(note)
            self.objects = self.array
            self.reloadData()
        }
        objects = array
        reloadData()
    }
    
    // UI
    
    func setupUI() {
        setupSearchController()
        tableView.registerNib(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")

        navigationItem.leftBarButtonItem = predicate != nil ? nil : editButtonItem()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "add")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        presentWalkthrough()
    }
    
    func setupSearchController(){
        
        var searchResultsController = UITableViewController(style: .Plain)
        searchResultsController.tableView.delegate = self
        searchResultsController.tableView.dataSource = self

        searchResultsController.tableView.registerNib(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchController.searchBar.showsScopeBar = false
        searchController.searchBar.sizeToFit()

        searchController.searchBar.barTintColor = UIColor.whiteColor()

        searchController.searchBar.delegate = self

        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    //MARK: - TableViewDelegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        let numberOfSections = UILocalizedIndexedCollation.currentCollation().sectionTitles.count
        return numberOfSections
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        if (searchController.active) {
            
            if searchResultsSections.count > 0{
                return Int(searchResultsSections[section].count)
            }else{
                return collation.sectionTitles.count
            }
        } else {
            if sections.count > 0{
                return Int(sections[section].count)
            }else{
                return collation.sectionTitles.count
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! ContactCell
        
        let person: Person
        if (searchController.active) {
            if searchResultsSections.count > 0{
                let objectsInSection = searchResultsSections[indexPath.section]
                person = objectsInSection[indexPath.row] as Person
                configure(cell: cell, forPerson: person)
            }
        } else {
            if sections.count > 0{
                let objectsInSection = sections[indexPath.section]
                person = objectsInSection[indexPath.row] as Person
                configure(cell: cell, forPerson: person)
            }
        }
        
        return cell
    }
    
    func configure(#cell:ContactCell, forPerson person:Person){
        cell.name = person.attributedFullName
        //        cell.textLabel?.text = object.fullName
        cell.noteLabel.text = person.detail
//        cell.note = person.detail
        let toDosCount = person.todos.filter("isComplete = false", person).count
        cell.todo = toDosCount
        cell.delegate = self
        cell.leftButtons = [
            //Doesn't work:
//            MGSwipeButton(title: "greenbutton", icon: UIImage(named: "greenbutton"), backgroundColor: UIColor.whiteColor(), padding: 10),
//            MGSwipeButton(title: "greenbutton", icon: UIImage(named: "yellowbutton"), backgroundColor: UIColor.whiteColor(), padding: 10),
//            MGSwipeButton(title: "greenbutton", icon: UIImage(named: "redbutton"), backgroundColor: UIColor.whiteColor(), padding: 10)
            MGSwipeButton(title: "", icon: UIImage(named: "greenbutton"), backgroundColor: UIColor.whiteColor(), callback: { (cell) -> Bool in
                println("green")
                return true
            }),
            MGSwipeButton(title: "", icon: UIImage(named: "yellowbutton"), backgroundColor: UIColor.whiteColor(), callback: { (cell) -> Bool in
                println("yellow")
                return true
            }),
            MGSwipeButton(title: "", icon: UIImage(named: "redbutton"), backgroundColor: UIColor.whiteColor(), callback: { (cell) -> Bool in
                println("red")
                return true
            }),
            MGSwipeButton(title: "", icon: UIImage(named: "bluebutton"), backgroundColor: UIColor.whiteColor(), callback: { (cell) -> Bool in
                println("red")
                return true
            }),
            MGSwipeButton(title: "", icon: UIImage(named: "strikebutton"), backgroundColor: UIColor.whiteColor(), callback: { (cell) -> Bool in
                println("red")
                return true
            })
        ]

        let image = UIImage(data:person.thumbnailData)
        cell.thumbImage = image
        if image != nil{
            if let imageView = cell.imageView{
                imageView.layer.cornerRadius = imageView.bounds.size.width / 2
                imageView.clipsToBounds = true
                cell.separatorInset = UIEdgeInsets(top: 0, left: 82, bottom: 0, right: 0)
            }
        }
    }

    // Actions
    
    func reloadData() {
        tableView.reloadData()
    }
    
    //Collation
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (searchController.active) {
            if searchResultsSections.count > 0{
                return searchResultsSections[section].count > 0 ? collation.sectionTitles[section] as? String : nil
            }else{
                return collation.sectionTitles[section] as? String
            }
            
        } else {
            if sections.count > 0{
                return sections[section].count > 0 ? collation.sectionTitles[section] as? String : nil
            }else{
                return collation.sectionTitles[section] as? String
            }
        }
        
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return collation.sectionIndexTitles
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return collation.sectionForSectionIndexTitleAtIndex(index)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let person = personForIndexPath(indexPath)
        let recID = ABRecordID(person.recordID)
        assert(addressBookModel.adbk != nil, "No addressbook")
        let abPerson = ABAddressBookGetPersonWithRecordID(addressBookModel.adbk, recID)
        println("person.recordID \(person.recordID)")
        doViewPerson(abPerson.takeRetainedValue())
    }
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let person = personForIndexPath(indexPath)
        let vc = storyboard?.instantiateViewControllerWithIdentifier("ContactViewVC") as! ContactViewVC
        vc.person = person
        navigationController?.pushViewController(vc, animated: true)
    }

    //TODO: Actions

    // MARK: - SearchBar Delegate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        print("updateSearchResultsForSearchController")
        if searchController.searchBar.text.isEmpty{
            return
        }
        let searchString = searchController.searchBar.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        filterResultsWithSearchString(searchString)
        let searchResultsController = searchController.searchResultsController as! UITableViewController
        searchResultsController.tableView.reloadData()
    }
    
    func filterResultsWithSearchString(searchString: String) {

        let scopeIndex = searchController.searchBar.selectedScopeButtonIndex
        
        let subpredicates = [namesPredicate(searchString: searchString), phonesPredicate(searchString: searchString)]
        
        let searchPredicate = NSCompoundPredicate(type: NSCompoundPredicateType.OrPredicateType, subpredicates: subpredicates)
        

        let finalSearchPredicate: NSPredicate
        if let predicate = predicate{
            finalSearchPredicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [searchPredicate, predicate])
            
        }else{
            finalSearchPredicate = searchPredicate
        }

        let realm = Realm()
        searchResults = realm.objects(Person).filter(finalSearchPredicate)
        let selector: Selector = "lastName"
        
        searchResultsSections = [[Person]](count: collation.sectionTitles.count, repeatedValue: [])
        
        for object in searchResults {
            let sectionNumber = collation.sectionForObject(object, collationStringSelector: selector)

            searchResultsSections[sectionNumber].append(object)
        }

        tableView.reloadData()
    }
    
    func namesPredicate(#searchString:String) -> NSPredicate {
        
        let stringComponents = searchString.componentsSeparatedByString(" ")
        let terms = searchString.componentsSeparatedByString(" ")
        var subpredicates = [NSPredicate]()
        for term in terms{
            let pred = NSPredicate(format: "(firstName CONTAINS[c] %@) OR (lastName CONTAINS[c] %@)OR (middleName CONTAINS[c] %@)OR (maidenName CONTAINS[c] %@)", term, term, term, term)
            subpredicates.append(pred)
        }
        let searchPredicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: subpredicates)
        println(searchPredicate)
        return searchPredicate
    }
    
    func phonesPredicate(#searchString:String) -> NSPredicate {
        
        let searchPredicate = NSPredicate(format: "(ANY phones.number CONTAINS %@)", searchString)

        return searchPredicate
    }
    //MARK: - AddressBook Delegate
    func doViewPerson (record: ABRecord!) {
        if !addressBookModel.determineStatus() {
            println("not authorized")
            return
        }

        let pvc = ABPersonViewController()
        pvc.addressBook = addressBookModel.adbk
        pvc.displayedPerson = record
        pvc.personViewDelegate = self

        pvc.allowsEditing = true
        pvc.allowsActions = true
        showViewController(pvc, sender:self)
    }
    
    func personViewController(personViewController: ABPersonViewController!,
        shouldPerformDefaultActionForPerson person: ABRecord!,
        property: ABPropertyID, identifier: ABMultiValueIdentifier) -> Bool {
            return true // if true, email tap launches email etc.
    }
    
    // =========
    
    func add() {
        let npvc = ABNewPersonViewController()
        npvc.newPersonViewDelegate = self
        let nc = UINavigationController(rootViewController:npvc)
        presentViewController(nc, animated:true, completion:nil)
    }
    
    func newPersonViewController(newPersonView: ABNewPersonViewController!,
        didCompleteWithNewPerson person: ABRecord!) {
            if person != nil {
                save(person: person)
            }
            dismissViewControllerAnimated(true, completion:nil)
    }

    func save(#person:ABRecord!) -> Person{
        let personObj = Person()
        //        person.lastName = "Best"
        let realm = Realm()
        realm.write { () -> Void in
            personObj.update(fromRecord: person, inRealm: realm)
            realm.add(personObj)
        }
        return personObj
    }
    func swipeTableCell(cell: MGSwipeTableCell!, tappedButtonAtIndex index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        println(index)
        var indexPath:NSIndexPath!
        if (searchController.active) {
            let searchResultsController = searchController.searchResultsController as! UITableViewController
            indexPath = searchResultsController.tableView.indexPathForCell(cell)
        } else {
            indexPath = tableView.indexPathForCell(cell)
        }
    
        let realm = Realm()
        realm.beginWrite()
        let tag = index + 1
        let person = personForIndexPath(indexPath)
        if person.tag == tag{
            println("Remove")
            person.tag = 0
            println("Remove \(person.tag)")
        }else{
            person.tag = tag
        }
        realm.commitWrite()
        return true
    }
    
    func personForIndexPath(indexPath:NSIndexPath) -> Person{
        var person: Person!
        if (searchController.active) {
            let objectsInSection = searchResultsSections[indexPath.section]
            person = objectsInSection[indexPath.row] as Person
        } else {
            let objectsInSection = sections[indexPath.section]
            person = objectsInSection[indexPath.row] as Person
            
        }
        return person
    }
}

