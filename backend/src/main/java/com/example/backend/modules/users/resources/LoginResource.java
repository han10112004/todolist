package com.example.backend.modules.users.resources;

public class LoginResource {
    private final UserResource user;

    public LoginResource(
        UserResource user
    ) {
        this.user = user;
    }

    public UserResource getUser () {
        return user;
    }
}
