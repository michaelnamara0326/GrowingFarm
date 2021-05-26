//
//  FetchFirebaseData.swift
//  growingFarm
//
//  Created by Michael Namara on 2021/5/24.
//  Copyright © 2021 Michael. All rights reserved.
//

import Foundation
import Firebase
class FetchFirebaseData{
    let userData=userdata()
    let db=Firestore.firestore()
    func getUserInfo(userEmail email:
        db.collection(peopleIdentifier).whereField("email", isEqualTo: email).getDocuments { querySanpshot, error in
            if let err=error{
                self.errorLabel.text="查無用戶資料"
                print(err)
            }
            else{
                for document in querySanpshot!.documents{
                    self.userInfo=document.data()
                    self.userDocumentID=document.documentID
                }
            }
        }
    }
}
