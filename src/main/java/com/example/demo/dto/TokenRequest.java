package com.example.demo.dto;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Positive;

public class TokenRequest {
    @NotBlank(message = "name is required")
    private String name;
    private String type;
    @Positive(message = "expiresInSeconds must be positive")
    private long expiresInSeconds; // tiempo de expiración en segundos desde ahora

    public TokenRequest() {}

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public long getExpiresInSeconds() {
        return expiresInSeconds;
    }

    public void setExpiresInSeconds(long expiresInSeconds) {
        this.expiresInSeconds = expiresInSeconds;
    }
}
