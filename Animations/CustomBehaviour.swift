//
//  CustomBehaviour.swift
//  Animations
//
//  Created by Euler Carvalho on 31/05/21.
//

import UIKit

class CustomBehaviour: UIDynamicBehavior {
    private var gravity: UIGravityBehavior
    private var collision: UICollisionBehavior
    private var itemBehaviour: UIDynamicItemBehavior
    private var pushBehaviour: UIPushBehavior?
    
    override init() {
        gravity = UIGravityBehavior()
        gravity.magnitude = 0.7
        
        collision = UICollisionBehavior()
        collision.translatesReferenceBoundsIntoBoundary = true
        
        itemBehaviour = UIDynamicItemBehavior()
        itemBehaviour.elasticity = 1.05
        
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collision)
        addChildBehavior(itemBehaviour)
    }
    
    public func add(_ item: UIDynamicItem) {
        gravity.addItem(item)
        collision.addItem(item)
        itemBehaviour.addItem(item)
    }
    
    public func remove(_ item: UIDynamicItem) {
        gravity.removeItem(item)
        collision.removeItem(item)
        itemBehaviour.removeItem(item)
    }
}
