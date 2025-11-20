package com.example.demo.controller;

import java.time.Instant;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import com.example.demo.api.ApiConstants;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.dto.TokenRequest;
import com.example.demo.dto.TokenResponse;
import com.example.demo.service.TokenServiceInterface;
import javax.validation.Valid;

@RestController
@RequestMapping(ApiConstants.API_BASE)
public class TokenController {

    private final TokenServiceInterface tokenService;

    public TokenController(TokenServiceInterface tokenService) {
        this.tokenService = tokenService;
    }

    @PostMapping("/token")
    public ResponseEntity<TokenResponse> generateToken(@Valid @RequestBody TokenRequest req) {
        long expiresIn = req.getExpiresInSeconds() > 0 ? req.getExpiresInSeconds() : 3600;
        String token = tokenService.generateToken(req.getName(), req.getType() == null ? "default" : req.getType(), expiresIn);
        long expiresAt = Instant.now().getEpochSecond() + expiresIn;
        return ResponseEntity.ok(new TokenResponse(token, expiresAt));
    }
}
