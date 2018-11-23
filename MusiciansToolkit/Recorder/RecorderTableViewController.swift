//
//  RecorderTableViewController.swift
//  MusiciansToolkit
//
//  Created by Mark Pizzutillo on 11/22/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//

import UIKit
import AudioKit

class RecorderTableViewController: UITableViewController {
    var fileManager : FileManager?
    var documents : URL?
    var audioFileURLs : [URL]?
    var audioFileNames = [String]()
    
    required init?(coder aDecoder: NSCoder) {
        fileManager = FileManager.default
        documents = fileManager?.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            audioFileURLs = try fileManager?.contentsOfDirectory(at: documents!, includingPropertiesForKeys: nil)
            audioFileNames.removeAll()
            for url in audioFileURLs! {
                audioFileNames.append(url.lastPathComponent)
            }
        } catch {
            print(error)
            audioFileURLs = []
        }
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioFileURLs!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordingCell", for: indexPath) as! RecorderTableViewCell
        
        cell.titleLabel?.text = audioFileNames[indexPath.row]

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Begin updates
            //self.tableView.beginUpdates()
            
            // Get cell text
            let cell = tableView.cellForRow(at: indexPath) as! RecorderTableViewCell
            let name = cell.titleLabel.text!
            //
            //
            //Something like this
            do {
                //Try to remove item from documents
                if let fileURL = documents?.appendingPathComponent(name) {
                    try fileManager?.removeItem(at: fileURL)
                }
            } catch {
                print(error)
            }
            
            //Remove files from global lists
            audioFileURLs?.remove(at: indexPath.row)
            audioFileNames.remove(at: indexPath.row)
            
            //Update global data (may not be needed)
            //updateDocumentData()
            
            //End updates
            //tableView.reloadData()
            tableView.deleteRows(at: [indexPath], with: .fade)
            //self.tableView.endUpdates()
            
        }
    }
    
    func updateDocumentData() {
        
        //
        //
        // !
        // Still have to do sorting by recording time...
        // !
        //
        //
        //
        do {
            audioFileURLs = try fileManager?.contentsOfDirectory(at: documents!, includingPropertiesForKeys: nil)
            audioFileNames.removeAll()
            for url in audioFileURLs! {
                audioFileNames.append(url.lastPathComponent)
            }
        } catch {
            print(error)
            audioFileURLs = []
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    

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

}
