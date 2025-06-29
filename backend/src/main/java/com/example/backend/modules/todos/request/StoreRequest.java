package com.example.backend.modules.todos.request;

import java.time.LocalDateTime;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;
  
@Data
public class StoreRequest {
    @NotBlank(message="Tiêu đề không được để trống")
    private String title;

    @NotBlank(message="Mô tả không được để trống")
    private String description;

    private Long statusId; // ID của TodoStatus

    private Long userId; 

    private LocalDateTime startTime;
    private LocalDateTime endTime;
}
