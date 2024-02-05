//
//  ContentView.swift
//  to-do-app-assignment
//
//  Created by Eser Lodhia on 05/02/24.
//

import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    var title: String
    var completed: Bool = false
}

class TaskManager: ObservableObject {
    @Published var tasks: [Task] = []
    
    func addTask(title: String) {
        if !title.isEmpty {
            let newTask = Task(title: title)
            tasks.append(newTask)
        }
    }
    
    func deleteTask(indexSet: IndexSet) {
        tasks.remove(atOffsets: indexSet)
    }
    
    func toggleTaskCompletion(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].completed.toggle()
        }
    }
}

struct ContentView: View {
    @State private var newTaskTitle = ""
    @State private var editMode = EditMode.inactive
    
    @ObservedObject var taskManager = TaskManager()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Tasks")) {
                    ForEach(taskManager.tasks) { task in
                        HStack {
                            
                            Text(task.title)
                                .strikethrough(task.completed)
                            
                            Spacer()
                            
                            Button(action: {
                                taskManager.toggleTaskCompletion(task: task)
                            }) {
                                Image(systemName: task.completed ? "checkmark.square" : "square")
                                    .foregroundColor(task.completed ? .green : .primary)
                            }
                        }
                    }
                    .onDelete(perform: taskManager.deleteTask)
                }
                
                
            }
            .navigationBarTitle("📝 To-Do List")
            .navigationBarItems(trailing: EditButton())
            .environment(\.editMode, $editMode)
            .onAppear {
               
            }
            .overlay(
                VStack{
                    Spacer()
                    ZStack(alignment: .bottomLeading){
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                        
                        HStack {
                            TextField("New Task", text: $newTaskTitle, onCommit: {
                                taskManager.addTask(title: newTaskTitle)
                                newTaskTitle = ""
                            })
                            .padding()
                            .background(Color.clear)
                            .disabled(editMode.isEditing)
                            
                            Button(action: {
                                taskManager.addTask(title: newTaskTitle)
                                newTaskTitle = ""
                            }) {
                                Text("ADD")
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .disabled(newTaskTitle.isEmpty || editMode.isEditing)
                        }
                    }
                    .padding()
                }
            )
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

