//
//  ViewController.swift
//  Flashcards
//
//  Created by Diego Borges on 2/29/16.
//  Copyright © 2016 Bearch Inc. All rights reserved.
//

import Bond
import UIKit
import SteviaLayout

class Person {
    let name: Observable<String?>
    
    init(name: String) {
        self.name = Observable(name)
    }
}

class ExampleView : UIView {
    let name = UITextField()
    let cloned = UITextField()
    let echo = UILabel()
    
    init(person: Person) {
        super.init(frame: CGRectZero)
        
        render(person)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render(person: Person) {
        name.bnd_text.bidirectionalBindTo(person.name)
        cloned.bnd_text.bindTo(person.name)
        person.name.bindTo(echo.bnd_text)
        
        backgroundColor = .grayColor()
        
        sv([
            name.placeholder("Two-way databind").style(fieldStyle),
            cloned.placeholder("One-way databind").style(fieldStyle),
            echo
        ])
        
        layout([
            100,
            |-20-name-20-| ~ 80,
            |-20-cloned-20-| ~ 80,
            |-20-echo-20-| ~ 30
        ])
    }
    
    func fieldStyle(f:UITextField) {
        f.borderStyle = .RoundedRect
        f.font = UIFont(name: "HelveticaNeue-Light", size: 26)
        f.returnKeyType = .Next
    }
}

class ViewController: UIViewController {

    let person = Person(name: "Diego")
    
    override func loadView() { view = ExampleView(person: person) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

       render()
    }
    
    func render() {
        on("INJECTION_BUNDLE_NOTIFICATION") {
            self.view = ExampleView(person: self.person)
        }
    }
}

