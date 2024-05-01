//
//  ContentView.swift
//  UserProfileApp
//
//  Created by Евгений Бухарев on 20.03.2024.
//

import SwiftUI

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: UserProfile.entity(),
        sortDescriptors: [])
    private var profiles: FetchedResults<UserProfile>
    @State private var showingEditProfile = false

    var body: some View {
        NavigationView {
            List {
                if let profile = profiles.first {
                    profileSection(profile) 
                }  else {
                    Text("Данные о пользователе отсутствуют!")
                }
            }
            .navigationBarTitle("Профиль")
            .navigationBarItems(trailing: Button(action: {
                showingEditProfile = true
            }) {
                Image(systemName: "gear")
            })
            .sheet(isPresented: $showingEditProfile) {
                if let profile = profiles.first {
                    EditProfileView(profile: profile, isPresented: $showingEditProfile)
                        .environment(\.managedObjectContext, self.viewContext)
                }
            }
        }
        .onAppear(perform: {
            if(profiles.isEmpty) {
                DataController().addFood(context: viewContext)
            }
        })
    }

    @ViewBuilder
    private func profileSection(_ profile: UserProfile) -> some View {
        Section(header: Text("Информация")) {
            if let photoData = profile.photo, let image = UIImage(data: photoData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }
            Text("Фамилия: \(profile.lastName ?? "")")
            Text("Имя: \(profile.firstName ?? "")")
            Text("Отчество: \(profile.patronymic ?? "")")
            Text("Никнейм: \(profile.nickname ?? "")")
            Text("Email: \(profile.email ?? "")")
            Text("Телефон: \(profile.phone ?? "")")
            Text("Телеграм: \(profile.telegram ?? "")")
        }
    }
}


#Preview {
    ContentView()
}
