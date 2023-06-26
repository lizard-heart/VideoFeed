//
//  AddPlaylist.swift
//  VideoFeed
//
//  Created by Henry Gustafson on 6/19/23.
//

import SwiftUI

struct AddPlaylist: View {
    @Environment(\.dismiss) var dismiss
    @State private var playlistName: String = ""
//    var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack {
            
            Button(action: {
                dismiss()
            }) {
                  Text("Done")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding()
            
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
                
                HStack {
                    Text("Name")
                        .fontWeight(.bold)
                    TextField("New Feed", text: $playlistName)
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    
                } 
                
                Spacer()
            }.padding(20)
        }
    }
}

struct AddPlaylist_Previews: PreviewProvider {
    static var previews: some View {
        AddPlaylist()
    }
}
