import UIKit
import RealmSwift

class OrganizationsVC: UITableViewController {
    private var organizations: [String]{
        let realm = Realm()
        
        let persons = realm.objects(Person)
        var uniqueOrganizations = [String]()
        var uniquePersons = [Person]()
        for person in persons {
            let person = person as Person
            let organization = person.organization
            if !contains(uniqueOrganizations, organization) {
                uniquePersons.append(person)
                uniqueOrganizations.append(organization)
            }
        }
        return uniqueOrganizations.sorted { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }
    }
    
    let predicateFormat = "organization == %@"
    
    var notificationToken: NotificationToken?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        self.createSearchDisplayController()
        self.tabBarItem.image = UIImage(named: "building")
        self.tabBarItem.selectedImage = UIImage(named: "building-s")
        tabBarItem.title = NSLocalizedString("Organizations", comment: "Tab title")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.accessibilityLabel = "Companies List"
        //        tableView.accessibilityValue = person.fullName
        tableView.isAccessibilityElement = true
        
        setupUI()
        
        // Set realm notification block
        notificationToken = Realm().addNotificationBlock { note, realm in
            self.tableView.reloadData()
        }
        
        tableView.reloadData()
    }
    
    // UI
    
    func setupUI() {
        tableView.registerClass(CellValue1.self, forCellReuseIdentifier: "cell")
    }
    
    // Table view data source
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return Int(organizations.count)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CellValue1
        
        let object = organizations[indexPath.row]
        cell.textLabel?.text = object.isEmpty ? NSLocalizedString("N/A", comment: "N/A") : object
        
        // Query using an NSPredicate object
        let predicate = NSPredicate(format: self.predicateFormat, object)
        let realm = Realm()
        let count = realm.objects(Person).filter(predicate).count

        cell.detailTextLabel?.text = "\(count)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let object = organizations[indexPath.row]
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("ContactsVC") as! ContactsVC
        
        let predicate = NSPredicate(format: predicateFormat, object)
        
        vc.predicate = predicate
        
        navigationController?.pushViewController(vc, animated: true)
    }
    // Actions
    
    func add() {
        //        RLMRealm.defaultRealm().transactionWithBlock {
        //            let object = [randomTitle(), NSDate(), randomSectionTitle()]
        //            DemoObject.createInDefaultRealmWithObject(object)
        //        }
    }
    
    // Helpers
}