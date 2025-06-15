package com.example.backend.modules.todos.repositories;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.backend.modules.todos.entities.Todo;

@ResponseBody
public interface TodoRepository extends JpaRepository<Todo, Long> {
    Optional<Todo> findById(Long id);
}
