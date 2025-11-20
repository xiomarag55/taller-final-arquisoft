package com.example.demo.service;

/**
 * Interfaz para el servicio de generación de tokens.
 * Define el contrato (SOLID: Dependency Inversion / Interface Segregation).
 */
public interface TokenServiceInterface {
    /**
     * Genera un token para el sujeto {@code name} con un tipo y expiración en segundos.
     * @param name sujeto
     * @param tokenType tipo de token
     * @param expiresInSeconds tiempo en segundos para expirar
     * @return token JWT compactado
     */
    String generateToken(String name, String tokenType, long expiresInSeconds);
}
