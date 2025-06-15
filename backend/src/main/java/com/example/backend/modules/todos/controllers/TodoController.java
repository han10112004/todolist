package com.example.backend.modules.todos.controllers;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend.modules.todos.request.StoreRequest;
import com.example.backend.modules.todos.request.UpdateRequest;
import com.example.backend.modules.todos.resources.TodoResource;
import com.example.backend.modules.todos.services.TodoService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("api/todos")
@RequiredArgsConstructor
public class TodoController {

    private final TodoService todoService;

    @PostMapping("/create")
    public ResponseEntity<?> store(@Valid @RequestBody StoreRequest request) {
        TodoResource response = todoService.store(request);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/get_all")
    public ResponseEntity<?> getAll(HttpServletRequest request) {
       List<TodoResource> response = todoService.getAll();
       return ResponseEntity.ok(response);
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<?> update(@PathVariable Long id, @Valid @RequestBody UpdateRequest request) {
        TodoResource response = todoService.update(id, request);
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        try {
            todoService.delete(id); // không cần return
            Map<String, String> response = new HashMap<>();
            response.put("message", "Xóa thành công");
            return ResponseEntity.ok(response); // Trả về JSON: {"message":"Xóa thành công"}
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Lỗi: " + e.getMessage());
        }
    }

    @DeleteMapping("/delete-all")
    public ResponseEntity<?> deleteAll(@RequestBody List<Long> ids) {
        try {
            todoService.deleteAllByIds(ids);
            return ResponseEntity.ok(Map.of("message", "Xóa thành công các công việc đã chọn"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                .body("Lỗi khi xóa: " + e.getMessage());
        }
    }



}
