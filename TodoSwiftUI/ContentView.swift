import SwiftUI

struct TodoItem: Identifiable {
    let id = UUID()
    let content: String
    var isDone = false
}

struct ContentView: View {
    @State var todos: [TodoItem] = [
        TodoItem(content: "밥 먹기", isDone: true),
        TodoItem(content: "산책하기"),
        TodoItem(content: "커피 사기"),
    ]
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

            List($todos) { $todo in
                Toggle(isOn: $todo.isDone) {
                    Text(todo.content)
                        .strikethrough(todo.isDone)
                        .foregroundColor(todo.isDone ? .gray : .primary)
                }
            }

            Spacer()
        }
        .padding()
    }

    private func addButtonTapped() {
        let trimmed = newTodo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        todos.append(TodoItem(content: trimmed))
        newTodo = ""
    }
}

#Preview {
    ContentView()
}
