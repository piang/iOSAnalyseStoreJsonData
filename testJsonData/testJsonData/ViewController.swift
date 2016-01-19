//
//  ViewController.swift
//  testJsonData
//
//  Created by 洋 裴 on 15/11/16.
//  Copyright © 2015年 玖富集团. All rights reserved.
//

import UIKit
import CoreData

enum storeType {
    case userDefaultsStore
    case plistStore
    case sqliteStore
}

class ViewController: UIViewController {
    
    
    let jsonString = "{\"name\": \"中国\",\"province\": [{\"name\": \"黑龙江\",\"city\": \"哈尔滨\"}, {\"name\": \"广东\",\"city\": \"广州\"}, {\"name\": \"台湾\",\"city\": \"台北\"}, {\"name\": \"新疆\",\"city\": \"乌鲁木齐\"}]}"

    
// MARK: - UI 控件
    @IBOutlet weak var originalDataButton: UIButton!
    @IBOutlet weak var analysisDataButton: UIButton!
    @IBOutlet weak var convertDataButton: UIButton!
    @IBOutlet weak var analysisDataTextView: UITextView!
    @IBOutlet weak var userDefaultsStoreButton: UIButton!
    @IBOutlet weak var plistStoreButton: UIButton!
    @IBOutlet weak var sqliteStoreButton: UIButton!
    
    
// MARK: - UI 控件事件
    @IBAction func OriginalDataButtonClick(sender: AnyObject) {
        
        analysisDataTextView.text = jsonString
    }
    
    @IBAction func AnalysisDataButtonClick(sender: AnyObject) {
        
        let jsonData = AnalysisDataFunc(jsonString)
        
        analysisDataTextView.text = NSString(format: "%@",jsonData) as String
    }
    
    @IBAction func ConvertDataButtonClick(sender: AnyObject) {
        
        let modelInit = ConvertDataFunc(jsonString) as! chinaModel
        
        analysisDataTextView.text = NSString(format: "第一个变量：%@\n第二个变量：%@", modelInit.name,modelInit.province) as String
    }
    
    @IBAction func userDefaultsStoreButtonClick(sender: AnyObject) {
        
        let modelInit = ConvertDataFunc(jsonString) as! chinaModel
        
        storeDataAction(storeType.userDefaultsStore, model: modelInit)
    }
    
    @IBAction func plistStoreButtonClick(sender: AnyObject) {
        
        let modelInit = ConvertDataFunc(jsonString) as! chinaModel
        
        storeDataAction(storeType.plistStore, model: modelInit)
    }
    
    @IBAction func sqliteStoreButtonClick(sender: AnyObject) {
        
        let modelInit = ConvertDataFunc(jsonString) as! chinaModel
        
        storeDataAction(storeType.sqliteStore, model: modelInit)
    }
// MARK: - 自定义方法
    func AnalysisDataFunc(data:String) -> NSDictionary {
        
        let jsonData = try! NSJSONSerialization.JSONObjectWithData(jsonString.dataUsingEncoding(NSUTF8StringEncoding)!,options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
        
        return jsonData
    }
    
    func ConvertDataFunc(data:String) -> AnyObject {
        
        let jsonData = AnalysisDataFunc(jsonString)
        let modelInit = chinaModel(dic: jsonData)
        
        return modelInit
    }
    
    func storeDataAction(type:storeType, model:AnyObject) {
        if (type == storeType.userDefaultsStore) {
            
            let modelData = NSKeyedArchiver.archivedDataWithRootObject(model)
            
            NSUserDefaults.standardUserDefaults().setObject(modelData, forKey: "modelKVC")
            
            let modelDataStore = NSUserDefaults.standardUserDefaults().objectForKey("modelKVC") as! NSData
            
            let modelStore = NSKeyedUnarchiver.unarchiveObjectWithData(modelDataStore) as! chinaModel
            
            print("NSUserDefults存储后的model名称:",modelStore.name)
            print("NSUserDefults存储后的model省份:",modelStore.province)
            
        }
        else if (type == storeType.plistStore) {
            
            let path:NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first!
            
            let fileName = path.stringByAppendingPathComponent("modelStore.plist")
            
            let modelData = NSKeyedArchiver.archivedDataWithRootObject(model)
            
            modelData.writeToFile(fileName, atomically: true)
            
            let modelDataStore = NSData(contentsOfFile: fileName)
            
            let modelStore = NSKeyedUnarchiver.unarchiveObjectWithData(modelDataStore!) as! chinaModel
            
            print("plist存储后的model名称:",modelStore.name)
            print("plist存储后的model省份:",modelStore.province)
            
        }
        else if (type == storeType.sqliteStore) {
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let fetchRequest = NSFetchRequest(entityName: "Province")
            
            
            //删除
            do {
                let fetchRequestResult = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as NSArray
                for objc in fetchRequestResult {
                    appDelegate.managedObjectContext.deleteObject(objc as! NSManagedObject)
                }
            }
            catch let error as NSError {
                print("could not fetch:",error.localizedDescription)
            }
            
            
            //插入
            for var i = 0; i < (model as! chinaModel).province.count;++i{
                let province =  NSEntityDescription.insertNewObjectForEntityForName("Province", inManagedObjectContext:appDelegate.managedObjectContext) as! Province
                province.name = ((model as! chinaModel).province[i] as! provinceModel).name as String
                province.city = ((model as! chinaModel).province[i] as! provinceModel).city as String
                
                do {
                    try appDelegate.managedObjectContext.save()
                }
                catch let error as NSError{
                    print("could not save:",error.localizedDescription)
                }
            }
            
            
            //查询
            do {
                let fetchRequestResult = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as NSArray
                for objc in fetchRequestResult {
                    
                    let coreDataProvince = objc as! Province
                    
                    print("name:",coreDataProvince.name!,"city:",coreDataProvince.city!)
                }
            }
            catch let error as NSError {
                print("could not fetch:",error.localizedDescription)
            }
        }
    }
    
    
    
// MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        analysisDataTextView.text = jsonString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

