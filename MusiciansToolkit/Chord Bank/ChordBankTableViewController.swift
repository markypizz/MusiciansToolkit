//
//  ChordBankTableViewController.swift
//  MusiciansToolkit
//
//  Created by Mark Pizzutillo on 11/19/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//

import UIKit

class ChordBankTableViewController: UITableViewController {
    
    let musicModel = Model.sharedInstance
    let uniqueNotesCount = 12

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return musicModel.uniqueNotes.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return musicModel.chordTypes.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return musicModel.uniqueNotes[section]
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chordCell", for: indexPath) as! ChordBankCell
        
        cell.chordNameLabel.text = "\(musicModel.uniqueNotes[indexPath.section])\(musicModel.chordTypes[indexPath.row])"

        return cell
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return musicModel.indexTitles
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "chordInfoSegue") {
            let destination = segue.destination as! ChordViewController
            
            let selectedCell = tableView.cellForRow(at: tableView.indexPathForSelectedRow!) as! ChordBankCell
            
            //Configure will row/chord name
            destination.configure(chordName: selectedCell.chordNameLabel.text!)
        }
    }
    

}
