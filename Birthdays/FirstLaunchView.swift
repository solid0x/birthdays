import SwiftUI

struct FirstLaunchView: View {
    
    @ObservedObject var firstLaunch: FirstLaunch
    @State var showAccessToContacts = true
    
    var body: some View {
        VStack {
            if showAccessToContacts {
                FirstLaunchScreen(
                    title: "Access to Contacts",
                    subtitle: "Allow access to get birthdays",
                    image: "person.crop.circle",
                    continueButtonLabel: "Allow access",
                    continueAction: requestContactsAccess,
                    skipButtonLabel: "Nah, I'll enter manually",
                    skipAction: skipContactsAccess
                )
            } else {
                FirstLaunchScreen(
                    title: "Access to Pushes",
                    subtitle: "Allow access to get birthday notifications",
                    image: "bell.circle",
                    continueButtonLabel: "Allow access",
                    continueAction: requestNotificationsAccess,
                    skipButtonLabel: "Nope, I'll skip it",
                    skipAction: skipNotificationsAccess
                )
            }
        }
    }
    
    private func requestContactsAccess() {
        firstLaunch.requestContactsAccess { _, _ in
            showAccessToContacts = false
        }
    }
    
    private func skipContactsAccess() {
        showAccessToContacts = false
    }
    
    private func requestNotificationsAccess() {
        firstLaunch.requestNotificationsAccess { _, _ in
            firstLaunch.pass()
        }
    }
    
    private func skipNotificationsAccess() {
        firstLaunch.pass()
    }
}

struct FirstLaunchScreen: View {
    
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    let image: String
    let continueButtonLabel: LocalizedStringKey
    let continueAction: () -> Void
    let skipButtonLabel: LocalizedStringKey
    let skipAction: () -> Void
    
    let animationDuration: Double = 0.5
    
    private static let AllowAccessBtnPadding: CGFloat = 20
    private static let IconSize: CGFloat = 100
    
    var body: some View {
        Group {
            Spacer()
            Image(systemName: image)
                .font(.system(size: FirstLaunchScreen.IconSize))
                .foregroundColor(.gray)
            Text(title)
                .font(.largeTitle)
            Text(subtitle)
                .foregroundColor(.gray)
                .font(.subheadline)
            Spacer()
            Button(action: continueAction, label: {
                Text(continueButtonLabel)
                    .font(.headline)
                    .padding()
                    .padding(.horizontal, FirstLaunchScreen.AllowAccessBtnPadding)
                    .background(Color.blue)
                    .clipShape(Capsule())
                    .foregroundColor(.white)
            }).padding()
            Button(action: skipAction, label: {
                Text(skipButtonLabel)
                    .font(.subheadline)
            })
        }
        .transition(.slide.combined(with: .opacity.animation(.easeInOut(duration: animationDuration))))
        .animation(.easeInOut(duration: animationDuration))
    }
}

struct FirstLaunchView_Previews: PreviewProvider {
    
    static var previews: some View {
        let firstLaunch = FirstLaunch()
        
        ForEachLocale {
            FirstLaunchView(firstLaunch: firstLaunch)
            FirstLaunchView(firstLaunch: firstLaunch, showAccessToContacts: false)
        }
    }
}

extension View {
    
    func setLocale(_ identifier: String) -> some View {
        self.environment(\.locale, .init(identifier: identifier))
    }
}

func ForEachLocale<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
    ForEach(Bundle.main.localizations, id: \.self) { locale in
        content().setLocale(locale)
    }
}
