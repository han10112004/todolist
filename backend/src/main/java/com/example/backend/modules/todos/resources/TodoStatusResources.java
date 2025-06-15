package com.example.backend.modules.todos.resources;

import java.util.List;

import com.example.backend.modules.todos.entities.Todo;
import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class TodoStatusResources {
    private final Long id;
    private final String name;
    private final List<Todo> todos;
}
