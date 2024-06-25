//
//  ContentViewList.swift
//  CleanCombineFramework
//
//  Created by Hai Sombo on 6/25/24.
//

import SwiftUI

struct ContentViewList: View {
    @State var ArrayList = ["EssentialsWorkStepView", "PublisherWork" ]
    var body: some View {
        NavigationView {
            VStack {
                Text ("Combine Framework")
                    .font(.largeTitle)
                    .foregroundColor(Color.blue)
                List {
                    ForEach (ArrayList , id: \.self) { data in
                        NavigationLink(destination: EssentialsWorkStepView()) {
                            Text(data)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
           
        }

    }
}

#Preview {
    ContentViewList()
}
