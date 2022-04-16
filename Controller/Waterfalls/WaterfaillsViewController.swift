//
//  WaterfaillsViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/16.
//

import UIKit

class WaterfaillsViewController: UIViewController {

    let commDataProvider = FirebaseRequestProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "評論瀑布牆"
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
