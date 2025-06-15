package com.example.backend.modules.todos.services;

import java.util.List;

import com.example.backend.modules.todos.request.StoreRequest;
import com.example.backend.modules.todos.request.UpdateRequest;
import com.example.backend.modules.todos.resources.TodoResource;

public interface TodoService {
    TodoResource store(StoreRequest request);
    List<TodoResource> getAll();
    TodoResource update(Long id, UpdateRequest request);
    void delete(Long id);
    void deleteAllByIds(List<Long> ids);
}


