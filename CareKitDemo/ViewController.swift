//
//  ViewController.swift
//  CareKitDemo
//
//  Created by LION-2 on 6/9/17.
//  Copyright © 2017 Infosys. All rights reserved.
//
//arthi_kulkarni
import UIKit
import CareKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.createActivity()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    let store: OCKCarePlanStore
    required init?(coder aDecoder: NSCoder) {
        // 1.
        let fileManager = NSFileManager.defaultManager()
        guard let documentDirectory = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last else {
            fatalError("*** Error: Unable to get the document directory! ***")
        }
        let storeURL = documentDirectory.URLByAppendingPathComponent("HelloCareKitStore")
        //2.
        if !fileManager.fileExistsAtPath(storeURL.path!) {
            try! fileManager.createDirectoryAtURL(storeURL, withIntermediateDirectories: true, attributes: nil)
        }
        //3.
        store = OCKCarePlanStore(persistenceDirectoryURL: storeURL)
        super.init(coder: aDecoder)
    }
    
    
    func createActivity(){
        //1.
        let MyMedicationIdentifier = "HelloActivity"
        
        //2
        store.activityForIdentifier(MyMedicationIdentifier) { (success, foundActivity, error) in
            //3.
            guard success else {
                // perform real error handling here.
                fatalError("*** An error occurred \(error?.localizedDescription) ***")
            }
            if let activity = foundActivity {
                //activity already exists
                print("Activity found - \(activity.identifier)")
            }
            else {
                // 4.
                let startDay = NSDateComponents(year: 2017, month: 6, day: 14)
                let thriceADay = OCKCareSchedule.dailyScheduleWithStartDate(startDay, occurrencesPerDay: 3)
                //5.
                let medication = OCKCarePlanActivity(identifier: MyMedicationIdentifier, groupIdentifier: nil, type: .Intervention, title: "Hello World", text: "Say aloud", tintColor: nil, instructions: "Say Hello to the world 3 times a day. This should make you feel better.", imageURL: nil, schedule: thriceADay, resultResettable: true, userInfo: nil)
                
                //6
                self.store.addActivity(medication, completion: {(success, error) in guard success else {
                    
                    fatalError("*** AN ERROE OCCURED \(error?.localizedDescription) ***")
                    }
                })
            }
        }
    }
    
    
    @IBAction func showCareCard(sender: AnyObject) {
        
        let careCardViewController = OCKCareCardViewController(carePlanStore: store)
        
        self.navigationController?.pushViewController(careCardViewController, animated: true)
    }
    
}

