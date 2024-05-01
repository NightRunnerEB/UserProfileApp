//
//  EditProfileView.swift
//  UserProfileApp
//
//  Created by Евгений Бухарев on 20.03.2024.
//

import SwiftUI

struct EditProfileView: View {
    @ObservedObject var profile: UserProfile
    @Environment(\.managedObjectContext) var managedObjContext
    @Binding var isPresented: Bool
    @State private var showingImagePicker = false
    @State private var showingActionSheet = false
    @State private var inputImage: UIImage?
    // Добавляем вспомогательное состояние для опционального поля
    @State private var patronymic: String
    @State private var lastName: String
    @State private var firstName: String
    @State private var nickname: String
    @State private var email: String
    @State private var phone: String
    @State private var telegram: String

    // Инициализатор, чтобы инициализировать временные переменные
    init(profile: UserProfile, isPresented: Binding<Bool>) {
        self.profile = profile
        self._isPresented = isPresented

        // Инициализация временных переменных текущими значениями из профиля
        lastName = profile.lastName!
        firstName = profile.firstName!
        nickname = profile.nickname!
        email = profile.email!
        phone = profile.phone!
        telegram =  profile.telegram!
        patronymic = profile.patronymic ?? ""
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Фото")) {
                    HStack {
                        Spacer()
                        Button(action: {
                            showingImagePicker = true
                        }) {
                            if let inputImage = inputImage {
                                Image(uiImage: inputImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            } else if let photoData = profile.photo, let image = UIImage(data: photoData) {
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
                        }
                        Spacer()
                    }
                }
                
                Section(header: Text("Основная информация")) {
                    TextField("Фамилия", text: $lastName)
                    TextField("Имя", text: $firstName)
                    TextField("Отчество", text: $patronymic)
                    TextField("Никнейм", text: $nickname)
                    TextField("Email", text: $email)
                    TextField("Телефон", text: $phone)
                    TextField("Телеграм", text: $telegram)
                }
            }
            .navigationBarTitle("Редактировать профиль", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.showingActionSheet = true
            }) {
                Image(systemName: "xmark")
                    .imageScale(.large)
                    .foregroundColor(.black)
            })
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(
                    title: Text("Сохранение изменений"),
                    message: Text("Хотите сохранить внесенные изменения?"),
                    buttons: [
                        .default(Text("Сохранить")) {
                            self.saveProfile()
                        },
                        .cancel(Text("Отмена")) {
                            self.isPresented = false
                        }
                    ]
                )
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(selectedImage: $inputImage)
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        profile.photo = inputImage.jpegData(compressionQuality: 1.0)
    }
    
    func saveProfile() {
        
        if let inputImage = inputImage {
            profile.photo = inputImage.jpegData(compressionQuality: 1.0)
        }
        
        DataController().editUser(user: profile, firstName: firstName, lastName: lastName, email: email, nickname: nickname, telegram: telegram, phone: phone, patronymic: patronymic, context: managedObjContext)
        
        isPresented = false
    }
}
