//
//  Intro.swift
//  PokeAPI
//
//  Created by Etudiant on 16-12-08.
//  Copyright © 2016 Etudiant. All rights reserved.
//

import UIKit

class Intro: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(Intro.passerAuMenuPrincipal), userInfo: nil, repeats: false)
    }
    
    func passerAuMenuPrincipal(){
        performSegue(withIdentifier: "versMenuPrincipal", sender: self)
    } // passerAuMenuPrincipal
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
