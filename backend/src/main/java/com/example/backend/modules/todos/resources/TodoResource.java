package com.example.backend.modules.todos.resources;

import java.time.LocalDateTime;

import com.example.backend.modules.todos.entities.TodoStatus;
import com.example.backend.modules.users.entities.User;
import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.Builder;
import lombok.Data;


@Data
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class TodoResource {
    private final Long id;
    private final String title;
    private final String description;
    private final LocalDateTime startTime; 
    private final LocalDateTime endTime;
}

