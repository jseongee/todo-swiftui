import SwiftUI

struct TodoItem: Identifiable, Codable {
    let id: UUID
    let content: String
    let createdAt: Date
    var isDone: Bool

    init(id: UUID = UUID(), content: String, createdAt: Date = Date(), isDone: Bool = false) {
        self.id = id
        self.content = content
        self.createdAt = createdAt
        self.isDone = isDone
    }
}

struct ContentView: View {
    @State private var todos: [TodoItem] = UserDefaults.standard.loadTodos()
    @State private var newTodo: String = ""

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter
    }()

    var body: some View {
        VStack {
            HStack {
                TextField("할 일을 입력해주세요.", text: $newTodo)
                    .textFieldStyle(.roundedBorder)
                Button("추가") {
                    addTodo()
                }
                .buttonStyle(.borderedProminent)
            }

            List {
                ForEach($todos) { $todo in
                    Toggle(isOn: $todo.isDone) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(todo.content)
                                .strikethrough(todo.isDone)
                                .foregroundColor(todo.isDone ? .gray : .primary)

                            Text(dateFormatter.string(from: todo.createdAt))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .onChange(of: todo.isDone) {
                        saveTodos()
                    }

                }
                .onDelete(perform: deleteTodo)
            }

            Spacer()
        }
        .padding()
    }

    private func addTodo() {
        let trimmed = newTodo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        todos.append(TodoItem(content: trimmed))
        newTodo = ""
        saveTodos()
    }

    private func deleteTodo(at offsets: IndexSet) {
        todos.remove(atOffsets: offsets)
        saveTodos()
    }

    private func saveTodos() {
        UserDefaults.standard.saveTodos(todos)
    }
}

extension UserDefaults {
	private static let todosKey = "todos"

    func loadTodos() -> [TodoItem] {
        if let data = data(forKey: Self.todosKey),
              let decoded = try? JSONDecoder().decode([TodoItem].self, from: data) {
            return decoded
        }

        return []
    }

    func saveTodos(_ todos: [TodoItem]) {
        if let encoded = try? JSONEncoder().encode(todos) {
            set(encoded, forKey: Self.todosKey)
        }
    }
}

#Preview {
    ContentView()
}
