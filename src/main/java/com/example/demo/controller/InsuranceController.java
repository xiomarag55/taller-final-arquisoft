package com.example.demo.controller;

import java.util.List;
import java.util.Map;

import com.example.demo.api.ApiConstants;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(ApiConstants.API_BASE)
public class InsuranceController {

    @GetMapping("/")
    public Map<String, String> home() {
        return Map.of("message", "Microservicio Insurance - OK");
    }

    @GetMapping("/health")
    public Map<String, String> health() {
        return Map.of("status", "UP");
    }

    @GetMapping("/polizas")
    public List<Map<String, Object>> polizas() {
        return List.of(
                Map.of("id", 1, "cliente", "Juan Perez", "tipo", "Auto"),
                Map.of("id", 2, "cliente", "María Ruiz", "tipo", "Hogar")
        );
    }
}
