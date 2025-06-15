package com.example.backend.modules.users.services;

import com.example.backend.modules.users.request.LoginRequest;
import com.example.backend.modules.users.resources.LoginResource;

public interface AuthService {
    LoginResource login(LoginRequest request);
}
