package com.example.backend.modules.users.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class LoginRequest {
    @NotBlank(message = "Email là bắt buộc")
    private String email;
    @NotBlank(message= "Mật khẩu là bắt buộc")
    private String password;
}
