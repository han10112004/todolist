package com.example.backend.modules.users.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend.modules.users.request.LoginRequest;
import com.example.backend.modules.users.resources.LoginResource;
import com.example.backend.modules.users.services.AuthService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("api/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<LoginResource> login(@Valid @RequestBody LoginRequest request) {
        LoginResource response = authService.login(request);
        return ResponseEntity.ok(response);
    }
}
