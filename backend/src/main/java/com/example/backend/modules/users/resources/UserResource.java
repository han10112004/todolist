package com.example.backend.modules.users.resources;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.Builder;
import lombok.Data;


@Data
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class UserResource {
    private final Long id;
    private final String email;
    private final String firstName;
    private final String lastName;
    private final String middleName;
    private final String phone;
    private final String password;
}
