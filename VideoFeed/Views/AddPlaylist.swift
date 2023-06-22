//
//  AddPlaylist.swift
//  VideoFeed
//
//  Created by Henry Gustafson on 6/19/23.
//

import SwiftUI

struct AddPlaylist: View {
    @Environment(\.dismiss) var dismiss
//    var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
            VStack {
                Text("Hello world")
                    .padding()
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(Color.red)
                
                Spacer()
            }
        }
    }
}

struct AddPlaylist_Previews: PreviewProvider {
    static var previews: some View {
        AddPlaylist()
    }
}
