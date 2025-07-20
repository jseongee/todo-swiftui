import SwiftUI

struct TodoItem: Identifiable {
    let id = UUID()
    let content: String
}

struct ContentView: View {
    @State var todos: [TodoItem] = []
    @State var newTodo: String = ""

    var body: some View {
        VStack {
            HStack {
                TextField("할 일을 입력해주세요.", text: $newTodo)
                    .textFieldStyle(.roundedBorder)
                Button("추가") {
                    addButtonTapped()
                }
                .buttonStyle(.borderedProminent)
            }

            List(todos) { todo in
                Text(todo.content)
            }

            Spacer()
        }
        .padding()
    }

    private func addButtonTapped() {
        if newTodo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return }

        todos.append(TodoItem(content: newTodo))
        newTodo = ""
    }
}

#Preview {
    ContentView()
}
