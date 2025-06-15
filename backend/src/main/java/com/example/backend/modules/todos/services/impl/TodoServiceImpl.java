package com.example.backend.modules.todos.services.impl;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;

import com.example.backend.enums.TodoStatusEnum;
import com.example.backend.modules.todos.entities.Todo;
import com.example.backend.modules.todos.entities.TodoStatus;
import com.example.backend.modules.todos.repositories.TodoRepository;
import com.example.backend.modules.todos.repositories.TodoStatusRepository;
import com.example.backend.modules.todos.request.StoreRequest;
import com.example.backend.modules.todos.request.UpdateRequest;
import com.example.backend.modules.todos.resources.TodoResource;
import com.example.backend.modules.todos.services.TodoService;
import com.example.backend.modules.users.entities.User;
import com.example.backend.modules.users.repositories.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TodoServiceImpl implements TodoService {

    private final TodoRepository todoRepository;
    private final TodoStatusRepository todoStatusRepository;
    private final UserRepository userRepository;

    @Override
    public TodoResource store(StoreRequest request) {
        Todo todo = new Todo();
        todo.setTitle(request.getTitle());
        todo.setDescription(request.getDescription());
        todo.setStartTime(request.getStartTime());
        todo.setEndTime(request.getEndTime());                // hoặc request.getEndTime()

        // Gán mặc định trạng thái "Chưa hoàn thành"
        TodoStatus status = todoStatusRepository.findById(TodoStatusEnum.DANG_DIEN_RA.getId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy trạng thái"));

        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng"));

        todo.setStatus(status);
        todo.setUser(user);

        Todo saved = todoRepository.save(todo);

        return TodoResource.builder()
                .id(saved.getId())
                .title(saved.getTitle())
                .description(saved.getDescription())  // theo đúng tên trong resource
                .startTime(saved.getStartTime())
                .endTime(saved.getEndTime())
                //.user(saved.getUser())
                //.status(saved.getStatus())
                .build();
    }

    @Override
        public List<TodoResource> getAll() {
        List<Todo> todos = todoRepository.findAll();

        return todos.stream()
                .map(todo -> TodoResource.builder()
                        .id(todo.getId())
                        .title(todo.getTitle())
                        .description(todo.getDescription())
                        .startTime(todo.getStartTime())
                        .endTime(todo.getEndTime())
                        .build())
                .toList();
        }

        @Override
        public TodoResource update(Long id, UpdateRequest request) {
        // 1. Lấy công việc theo ID
                Todo todo = todoRepository.findById(id)
                        .orElseThrow(() -> new RuntimeException("Không tìm thấy công việc với ID: "));

                // 2. Cập nhật thông tin
                todo.setTitle(request.getTitle());
                todo.setDescription(request.getDescription());

                // 3. Cập nhật trạng thái nếu có
                TodoStatus status = todoStatusRepository.findById(request.getStatusId())
                        .orElseThrow(() -> new RuntimeException("Không tìm thấy trạng thái với ID: " + request.getStatusId()));
                todo.setStatus(status);

                // 4. Cập nhật thời gian sửa đổi (tùy chọn)
                todo.setEndTime(LocalDateTime.now());

                // 5. Lưu lại
                Todo updated = todoRepository.save(todo);

                // 6. Trả về response
                return TodoResource.builder()
                        .id(updated.getId())
                        .title(updated.getTitle())
                        .description(updated.getDescription())
                        .startTime(updated.getStartTime())
                        .endTime(updated.getEndTime())
                        .build();
                }

                @Override
                public void delete(Long id) {
                        // 1. Tìm công việc cần xóa
                        Todo todo = todoRepository.findById(id)
                                .orElseThrow(() -> new RuntimeException("Không tìm thấy công việc với ID: " + id));

                        // 2. Thực hiện xóa
                        todoRepository.delete(todo);
                }


                @Override
                public void deleteAllByIds(List<Long> ids) {
                        List<Todo> todos = todoRepository.findAllById(ids);
                        if (todos.isEmpty()) {
                                throw new RuntimeException("Không tìm thấy công việc nào để xóa");
                        }
                        todoRepository.deleteAll(todos);
                }

}
