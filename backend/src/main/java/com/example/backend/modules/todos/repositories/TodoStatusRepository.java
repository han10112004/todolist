package com.example.backend.modules.todos.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.backend.modules.todos.entities.TodoStatus;

@Repository
public interface TodoStatusRepository extends  JpaRepository<TodoStatus, Long> {
    
}
