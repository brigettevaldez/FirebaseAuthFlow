//
//  ProgressStepper.swift
//  FirebaseAuthFlow
//
//  Created by Brigette Valdez on 3/18/21.
//

import SwiftUI

struct ProgressStepper: View {
    
    @State var range: ClosedRange<Int>
    @State var fill: Int
    
    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader { geo in
            RoundedRectangle(cornerRadius: 4)
                .frame(height: 8)
                .foregroundColor(.lavenderLight)
            RoundedRectangle(cornerRadius: 4)
                .frame(width: geo.size.width * (CGFloat(fill)/CGFloat(range.upperBound)), height: 8, alignment: .leading)
                .foregroundColor(.slateBlue)
            }
        }
    }
}

struct ProgressStepper_Previews: PreviewProvider {
    static var previews: some View {
        ProgressStepper(range: 0...5, fill: 1)
    }
}
