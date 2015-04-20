//
//  DataController.swift
//  FoodTracker
//
//  Created by Tim Even on 17-04-15.
//  Copyright (c) 2015 evenwerk. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataController {
    class func jsonAsUSADIdAndNameSearchResults(json: NSDictionary) -> [(name: String, idValue: String)] {
        var usdaItemsSearchResults:[(name : String, idValue: String)] = []
        var searchResult: (name: String, idValue: String)
        
        if json["hits"] != nil {
            let results:[AnyObject] = json["hits"] as! [AnyObject]
            
            for itemDictionary in results {
                if itemDictionary["_id"] != nil {
                    if itemDictionary["fields"] != nil {
                        let fieldsDictionary = itemDictionary["fields"] as! NSDictionary
                        if fieldsDictionary["item_name"] != nil {
                            let idValue:String = itemDictionary["_id"] as! String
                            let nameString:String = fieldsDictionary["item_name"] as! String
                            searchResult = (name : nameString, idValue : idValue)
                            usdaItemsSearchResults += [searchResult]
                        }
                    }
                }
            }
        }
        return usdaItemsSearchResults
    }
    
    func saveUSDAItemForID(idValue: String, json: NSDictionary) {
        if json["hits"] != nil {
            let results:[AnyObject] = json["hits"] as! [AnyObject]
            
            for itemDictionary in results {
                if itemDictionary["_id"] != nil && itemDictionary["_id"] as! String == idValue {
                    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
                    
                    var requestForUSDAItem = NSFetchRequest(entityName: "USDAItem")
                    
                    let itemDictionaryId = itemDictionary["_id"] as! String
                    let predicate = NSPredicate(format: "id == %@", itemDictionaryId)
                    requestForUSDAItem.predicate = predicate
                    
                    var error:NSError?
                    
                    var items = managedObjectContext?.executeFetchRequest(requestForUSDAItem, error: &error)
                    //                    var count = managedObjectContext?.countForFetchRequest(requestForUSDAItem, error: &error)
                    
                    if items?.count != 0 {
                        //The item is already saved
                        println("The item was already saved!")
                        return
                    }
                    else {
                        println("Let's save this to CoreData!")
                        
                        let entityDescription = NSEntityDescription.entityForName("USDAItem", inManagedObjectContext: managedObjectContext!)
                        let usdaItem = USDAItem(entity: entityDescription! ,insertIntoManagedObjectContext: managedObjectContext!)
                        usdaItem.idValue = itemDictionary["_id"] as! String
                        
                        usdaItem.dateAdded = NSDate()
                        if itemDictionary["fields"] != nil {
                            let fieldsDictionary = itemDictionary["fields"] as! NSDictionary
                            
                            if fieldsDictionary["item_name"] != nil {
                                usdaItem.name = fieldsDictionary["item_name"] as! String
                            }
                            
                            if fieldsDictionary["usda_fields"] != nil {
                                let usdaFieldsDictionary = itemDictionary["usda_fields"] as! NSDictionary
                                
                                if usdaFieldsDictionary["CA"] != nil {
                                    let calciumDictionary = usdaFieldsDictionary["CA"] as! NSDictionary
                                    let calciumValue: AnyObject = calciumDictionary["value"]!
                                    usdaItem.calcium = "\(calciumValue)"
                                }
                                else {
                                    usdaItem.calcium = "0"
                                }
                                
                                if usdaFieldsDictionary["CHOCDF"] != nil {
                                    let carbohydrateDictionary = usdaFieldsDictionary["CHOCDF"] as! NSDictionary
                                    
                                    if carbohydrateDictionary["value"] != nil {
                                        let carboHydrateValue:AnyObject = carbohydrateDictionary["value"]!
                                        usdaItem.carbohydrate = "\(carboHydrateValue)"
                                    }
                                }
                                else {
                                    usdaItem.carbohydrate = "0"
                                }
                                
                                if usdaFieldsDictionary["FAT"] != nil {
                                    let fatTotalDictionary = usdaFieldsDictionary["FAT"] as! NSDictionary
                                    
                                    if fatTotalDictionary["value"] != nil {
                                        let fatTotalValue:AnyObject = fatTotalDictionary["value"]!
                                        usdaItem.fatTotal = "\(fatTotalValue)"
                                    }
                                }
                                else {
                                    usdaItem.fatTotal = "0"
                                }
                                
                                if usdaFieldsDictionary["CHOLE"] != nil {
                                    let cholesterolDictionary = usdaFieldsDictionary["CHOLE"] as! NSDictionary
                                    
                                    if cholesterolDictionary["value"] != nil {
                                        let cholesterolValue:AnyObject = cholesterolDictionary["value"]!
                                        usdaItem.cholesterol = "\(cholesterolValue)"
                                    }
                                }
                                else {
                                    usdaItem.cholesterol = "0"
                                }
                                
                                if usdaFieldsDictionary["PROCNT"] != nil {
                                    let proteinDictionary = usdaFieldsDictionary["PROCNT"] as! NSDictionary
                                    
                                    if proteinDictionary["value"] != nil {
                                        let proteinValue:AnyObject = proteinDictionary["value"]!
                                        usdaItem.protein = "\(proteinValue)"
                                    }
                                }
                                else {
                                    usdaItem.protein = "0"
                                }
                                
                                if usdaFieldsDictionary["SUGAR"] != nil {
                                    let sugarDictionary = usdaFieldsDictionary["SUGAR"] as! NSDictionary
                                    
                                    if sugarDictionary["value"] != nil {
                                        let sugarValue:AnyObject = sugarDictionary["value"]!
                                        usdaItem.sugar = "\(sugarValue)"
                                    }
                                }
                                else {
                                    usdaItem.sugar = "0"
                                }
                                
                                if usdaFieldsDictionary["VITC"] != nil {
                                    let vitaminCDictionary = usdaFieldsDictionary["VITC"] as! NSDictionary
                                    
                                    if vitaminCDictionary["value"] != nil {
                                        let vitaminCValue:AnyObject = vitaminCDictionary["value"]!
                                        usdaItem.vitameC = "\(vitaminCValue)"
                                    }
                                }
                                else {
                                    usdaItem.vitameC = "0"
                                }
                                
                                if usdaFieldsDictionary["ENERC_KCAL"] != nil {
                                    let energyDictionary = usdaFieldsDictionary["ENERC_KCAL"] as! NSDictionary
                                    
                                    if energyDictionary["value"] != nil {
                                        let energyValue:AnyObject = energyDictionary["value"]!
                                        usdaItem.energy = "\(energyValue)"
                                    }
                                }
                                else {
                                    usdaItem.energy = "0"
                                }
                                
                                (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
                            }
                        }
                    }
                }
            }
        }
    }
}