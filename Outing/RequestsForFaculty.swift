//
//  RequestsForFaculty.swift
//  Outing
//
//  Created by SVECW-4 on 25/09/18.
//  Copyright © 2018 SVECW-5. All rights reserved.
//

import UIKit

import FirebaseDatabase

class RequestsForFaculty: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var requestNum: UILabel!
    @IBOutlet weak var table1: UITableView!
    
    var regdArr:[String] = []
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table1.dataSource  = self
        table1.delegate = self
        getDetails()
        requestNum.text = String(regdArr.count)
        
    }
    
    func getDetails() {
        ref = Database.database().reference()
        ref.child("requests").observeSingleEvent(of: DataEventType.value, with: { snapshot in
            var i:Int = 0
            print(snapshot)
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                let restDict = rest.value as? [String:Any]
                let reg = restDict?["regnum"] as? String
                print(reg!)
                self.regdArr.insert(reg!, at: i)
                i = i + 1
                self.table1.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table1.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? CustomCell
        cell?.regdL?.text = regdArr[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        requestNum.text = String(regdArr.count)
        return regdArr.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let regdNo = regdArr[indexPath.row]
        UserDefaults.standard.set(regdNo, forKey:"regdNo")
        print("deselect")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popOverVC = storyboard.instantiateViewController(withIdentifier: "sbPopUpID")
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
}
