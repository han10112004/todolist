package com.example.backend.configs;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    // private final JwtAuthFilter jwtAuthFilter;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable()) // Tắt CSRF cho API (Postman không dùng CSRF token)
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/auth/login").permitAll() 
                .requestMatchers("/api/todos/create").permitAll() 
                .requestMatchers("/api/todos/get_all").permitAll()  //
                .requestMatchers("/api/todos/update/{id}").permitAll()  //
                .requestMatchers("/api/todos/delete/{id}").permitAll()  
                .requestMatchers("/api/todos/delete-all").permitAll()  
                .anyRequest().authenticated() // Các request khác phải xác thực
            )
            .httpBasic(Customizer.withDefaults()); // Cho phép dùng Basic Auth nếu cần

        return http.build();
    }
}