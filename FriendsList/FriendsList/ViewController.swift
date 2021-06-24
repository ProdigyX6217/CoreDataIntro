//
//  ViewController.swift
//  FriendsList
//
//  Created by Student Laptop_7/19_1 on 6/23/21.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var str_array = [NSManagedObject]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        self.title = "Friends"
        
        let fetchRequest =  NSFetchRequest<NSManagedObject>(entityName: "Friend")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}

        let managedContext = appDelegate.persistentContainer.viewContext

        do {
            str_array = try managedContext.fetch(fetchRequest)
           } catch let error as NSError {
               print("Could not fetch. \(error), \(error.userInfo)")
          }

        // Do any additional setup after loading the view.
    }
    
    func save(name: String) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}

        // 1
        let managedContext = appDelegate.persistentContainer.viewContext

        // 2
        let entity = NSEntityDescription.entity(forEntityName: "Friend",
                                           in: managedContext)!

        let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)

        // 3
        person.setValue(name, forKeyPath: "name")

        // 4
        do {
            try managedContext.save()
            str_array.append(person)
        } catch let error as NSError {
            print(error.userInfo)
        }
    }

    
    
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "New Friend", message: "Add the name of your friend", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Add Now", style: .default) { [unowned self] action in
            
            guard let textField = alert.textFields?.first, let nameToSave = textField.text else { return }
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return str_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = str_array[indexPath.row].value(forKeyPath: "name") as? String
        return cell
    }
    
    
}

