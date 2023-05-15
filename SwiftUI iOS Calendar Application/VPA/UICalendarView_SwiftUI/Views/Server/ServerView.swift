//Distint Howie - how4685@pennwest.edu

import SwiftUI
import Firebase

struct Course: Hashable, Codable{
    let courseName: String
    let Date: String
    let Days: String
    let Time: String
    let Location: String
}

class ViewModel: ObservableObject{
    @Published var courses: [Course] = []
    @Published var userEmail: String = ""
    var user = Auth.auth().currentUser
    
    func fetch(){
        //must be on university network to access, url to php backend server files
        guard let how4685 = URL(string: "http://10.2.84.46/php_files/how4685.php") else{
            return
        }
        
        guard let gun4897 = URL(string: "http://10.2.84.46/php_files/gun4897.php") else{
            return
        }
        
        guard let nie9236 = URL(string: "http://10.2.84.46/php_files/nie9236.php") else{
            return
        }
        
        guard let kir0510 = URL(string: "http://10.2.84.46/php_files/kir0510.php") else{
            return
        }
        
        //url  for local host testing
        /*guard let  url = URL(string: "http://localhost/schedule/classes.php") else{
         return
         }*/
        
        //If the user logging in is one of the team members, display our course schedules
        //create the session to the server and pull course information
        //Used to show that if we had access to the university servers we could pull the information needed
        if user?.email == "how4685@pennwest.edu" {
            //begin url session
            let task = URLSession.shared.dataTask(with: how4685) {[weak self]data, _, error in //create session
                guard let data = data, error == nil else{
                    return
                }
                
                //decode json data
                do{
                    let courses = try JSONDecoder().decode([Course].self, from: data)
                    DispatchQueue.main.async {
                        self?.courses = courses
                    }
                }//print any errors that may occur
                catch(let Jsonerror){
                    print(String(describing: Jsonerror))
                }
            }
            task.resume()
        } else if user?.email == "gun4897@pennwest.edu"{
            let task2 = URLSession.shared.dataTask(with: gun4897) {[weak self]data, _, error in
                guard let data = data, error == nil else{
                    return
                }
                
                //decode json data
                do{
                    let courses = try JSONDecoder().decode([Course].self, from: data)
                    DispatchQueue.main.async {
                        self?.courses = courses
                    }
                }//print any errors that may occur
                catch(let Jsonerror){
                    print(String(describing: Jsonerror))
                }
            }
            task2.resume()
        } else if user?.email == "nie9236@pennwest.edu"{
            let task3 = URLSession.shared.dataTask(with: nie9236) {[weak self]data, _, error in
                guard let data = data, error == nil else{
                    return
                }
                
                //decode json data
                do{
                    let courses = try JSONDecoder().decode([Course].self, from: data)
                    DispatchQueue.main.async {
                        self?.courses = courses
                    }
                }//print any errors that may occur
                catch(let Jsonerror){
                    print(String(describing: Jsonerror))
                }
            }
            task3.resume()
        }else if user?.email == "kir0510@pennwest.edu"{
            let task4 = URLSession.shared.dataTask(with: kir0510) {[weak self]data, _, error in
                guard let data = data, error == nil else{
                    return
                }
                
                //decode json data
                do{
                    let courses = try JSONDecoder().decode([Course].self, from: data)
                    DispatchQueue.main.async {
                        self?.courses = courses
                    }
                }//print any errors that may occur
                catch(let Jsonerror){
                    print(String(describing: Jsonerror))
                }
            }
            task4.resume()
        }else{
            print("error")
        }
    }
}

struct ServerView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView{
            var user = Auth.auth().currentUser //get the current user logged in
            if user?.email == "how4685@pennwest.edu" {
                List{
                    //for each course display the course information in a vstack view
                    ForEach(viewModel.courses, id: \.self){i in
                        VStack(alignment: .leading){
                            Text(i.courseName)
                                .font(.title)
                                .bold()
                            Text(i.Date)
                            Text(i.Days)
                            Text(i.Time)
                            Text(i.Location)
                        }
                        .padding(3)
                    }
                }
                .navigationTitle("Classes")
                .onAppear{
                    viewModel.fetch()
                }
            } else if user?.email == "gun4897@pennwest.edu" {
                List{
                    ForEach(viewModel.courses, id: \.self){i in
                        VStack(alignment: .leading){
                            Text(i.courseName)
                                .font(.title)
                                .bold()
                            Text(i.Date)
                            Text(i.Days)
                            Text(i.Time)
                            Text(i.Location)
                        }
                        .padding(3)
                    }
                }
                .navigationTitle("Classes")
                .onAppear{
                    viewModel.fetch()
                }
            }else if user?.email == "nie9236@pennwest.edu" {
                List{
                    ForEach(viewModel.courses, id: \.self){i in
                        VStack(alignment: .leading){
                            Text(i.courseName)
                                .font(.title)
                                .bold()
                            Text(i.Date)
                            Text(i.Days)
                            Text(i.Time)
                            Text(i.Location)
                        }
                        .padding(3)
                    }
                }
                .navigationTitle("Classes")
                .onAppear{
                    viewModel.fetch()
                }
            }else if user?.email == "kir0510@pennwest.edu" {
                List{
                    ForEach(viewModel.courses, id: \.self){i in
                        VStack(alignment: .leading){
                            Text(i.courseName)
                                .font(.title)
                                .bold()
                            Text(i.Date)
                            Text(i.Days)
                            Text(i.Time)
                            Text(i.Location)
                        }
                        .padding(3)
                    }
                }
                .navigationTitle("Classes")
                .onAppear{
                    viewModel.fetch()
                }
            }else { //if not one of the members of the team dont load a schedule
                Text("User doesn't have a schedule.")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
    }
}


