//
//  TodoTableViewController.swift
//  MyToDo
//
//  Created by Liam on 2021/10/31.
//

import UIKit

class TodoTableViewController: UITableViewController{
    
    var items:[TodoItem] = [
        TodoItem(title: "Homework", isChecked: false),
        TodoItem(title: "Play Games", isChecked: true),
        TodoItem(title: "Study", isChecked: false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationController?.navigationBar.prefersLargeTitles=true
        loadItems()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoTableViewCell

        let item = items[indexPath.row]
        cell.title.text! = item.title
        if item.isChecked{
            cell.state.text! = "✅"
        }else{
            cell.state.text! = " "
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        items.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt
           indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           //创建“更多”事件按钮
           let unread = UIContextualAction(style: .normal, title: "topping") {
               (action, view, completionHandler) in
               completionHandler(true)
           }
           unread.backgroundColor = UIColor(red: 52/255, green: 120/255, blue: 246/255,
                                            alpha: 1)
            
           //返回所有的事件按钮
           let configuration = UISwipeActionsConfiguration(actions: [unread])
           return configuration
       }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
            indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
            let more = UIContextualAction(style: .normal, title: "edit") {
                (action, view, completionHandler) in
                completionHandler(true)
            }
            more.backgroundColor = .lightGray
        
            let delete = UIContextualAction(style: .destructive, title: "delete") {
                (action, view, completionHandler) in
                self.items.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                completionHandler(true)
            }
             
            //返回所有的事件按钮
            let configuration = UISwipeActionsConfiguration(actions: [delete, more])
            return configuration
        }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier! == "addItem" {
            let addItemViewController = segue.destination as! ItemViewController
            addItemViewController.addItemDelegate = self
        }else if segue.identifier! == "editItem"{
            let editItemViewController = segue.destination as! ItemViewController
            let cell  = sender as! TodoTableViewCell
            var isChecked:Bool
            if cell.state.text! == "✅"{
                isChecked = true
            }else{
                isChecked = false
            }
            let Item = TodoItem(title: cell.title.text!, isChecked: isChecked)
            editItemViewController.itemToEdit = Item
            editItemViewController.itemIndex = tableView.indexPath(for: cell)!.row
            editItemViewController.editItemDelegate = self
        }
    }
    

}

extension TodoTableViewController: AddItemDelegate{
    func addItem(item: TodoItem){
        self.items.append(item)
        self.tableView.reloadData()
    }
}
 
extension TodoTableViewController: EditItemDelegate{
    func editItem(newItem: TodoItem, itemIndex: Int) {
        self.items[itemIndex] = newItem
        self.tableView.reloadData()
    }
}

extension TodoTableViewController{
    func dataFilePath()->URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return path!.appendingPathComponent("TodoItems.json")
    }
    func saveAllItems(){
        do{
            let data = try JSONEncoder().encode(items)
            try data.write(to: dataFilePath(), options: .atomic)
        }catch{
            print("Cannot save data:\(error.localizedDescription)")
        }
    }
    func loadItems(){
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path){
            do{
                items = try JSONDecoder().decode([TodoItem].self, from: data)
            }catch{
                print("Cannot read data:\(error.localizedDescription)")
            }
        }
    }
}
