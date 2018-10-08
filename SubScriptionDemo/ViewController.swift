//
//  ViewController.swift
//  SubScriptionDemo
//
//  Created by SOTSYS113 on 17/11/17.
//  Copyright © 2017 SOTSYS113. All rights reserved.
//

import UIKit

class ViewController: UIViewController,SalesManagerProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        let price = HKStorage.hk_object(forKey: "SubscriptionPriceOneMonth")!
        print(price)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Free Trail Clicked
    @IBAction func btnOneMonthClicked(_ sender: UIButton){
//        Constant.showLoader()
        SalesManager.sharedInstance().delegate = self
        SalesManager.sharedInstance().buyItem(withIdentifier: ProductOneMonth)
    }
    @IBAction func btnThreeMonthClicked(_ sender: UIButton){
        //        Constant.showLoader()
        SalesManager.sharedInstance().delegate = self
        SalesManager.sharedInstance().buyItem(withIdentifier: ProductThreeMonth)
    }
    @IBAction func btnSixMonthClicked(_ sender: UIButton){
        //        Constant.showLoader()
        SalesManager.sharedInstance().delegate = self
        SalesManager.sharedInstance().buyItem(withIdentifier: ProductSixMonth)
    }
    @IBAction func btnTwelveMonthClicked(_ sender: UIButton){
        //        Constant.showLoader()
        SalesManager.sharedInstance().delegate = self
        SalesManager.sharedInstance().buyItem(withIdentifier: ProductTwelveMonth)
    }
    @IBAction func btnBoosterPackClicked(_ sender: UIButton){
        //        Constant.showLoader()
        SalesManager.sharedInstance().delegate = self
        SalesManager.sharedInstance().buyItem(withIdentifier: ProductBoosterMonth)
    }
    // MARK: Restore Purchase
    @IBAction func btnRestorePurchaseClicked(_ sender: Any) {
//        Constant.showLoader()
        SalesManager.sharedInstance().delegate = self
        SalesManager.sharedInstance().restorePurchases()
    }
    // MARK: Sales Manager Delegate
    func setUserSubscribedToProductID(productSubscribed : String){
        let subscriptionStatusCode : String = SalesManager.sharedInstance().subscriptionStatusCode(fromProductID: productSubscribed)
        print(subscriptionStatusCode)
    }
    func responseRecieved(_ failed: Bool) {
//        Constant.hideLoader()
        if (failed == false){
//            Constant.showLoader()
            SalesManager.sharedInstance().validateReceipe(completion: {
//                Constant.hideLoader()
                let productSubscribed : String = SalesManager.sharedInstance().subscribedProductIdIfAny()
                if (productSubscribed.characters.count>0){
                    self.setUserSubscribedToProductID(productSubscribed: productSubscribed)
                }else{
                    //self.view.makeToast("Subscription is not complete")
                }
            })
        }
    }
    func itemsRestored() {
//        Constant.hideLoader()
        self.responseRecieved(false)
    }
    func productsCached() {
    }
    
    func timerFired(withRemainingSec seconds: Int) {
    }
}

