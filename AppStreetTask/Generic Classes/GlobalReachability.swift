

import UIKit

class GlobalReachability: NSObject
{
    //instance class to maintain the value of the login type 
    static let sharedInstance: GlobalReachability = {
        let instance = GlobalReachability()
        // setup code
        return instance
    }()
    
   
}
