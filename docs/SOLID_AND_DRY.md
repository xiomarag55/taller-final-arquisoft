Aplicación de SOLID y DRY

Este documento explica, de forma breve, cómo se aplican los principios SOLID y la regla DRY en el código del proyecto.

Resumen rápido del código relevante:

- Controllers: `TokenController`, `InsuranceController`
- Servicio: `TokenServiceInterface`, `TokenService`
- DTOs: `TokenRequest`, `TokenResponse`
- Config: `WebConfig`, `OpenApiConfig`
- Manejo de errores: `GlobalExceptionHandler`
- Constantes: `ApiConstants`

Aplicación de SOLID

1. Single Responsibility Principle (SRP)

   - Cada clase tiene una única responsabilidad:
     - `TokenController` maneja las rutas HTTP para generación de tokens.
     - `InsuranceController` expone endpoints de información/health/pólizas.
     - `TokenService` (implementación) se encarga únicamente de crear y firmar tokens JWT.
     - `TokenRequest` y `TokenResponse` son solo contenedores de datos (DTOs).
     - `WebConfig` y `OpenApiConfig` agrupan configuración (CORS y OpenAPI) fuera de la lógica de negocio.
     - `GlobalExceptionHandler` centraliza el manejo de errores/validaciones.

2. Open/Closed Principle (OCP)

   - El diseño favorece la extensión sin modificación directa de clientes:
     - `TokenServiceInterface` define el contrato; para cambiar la forma de generar tokens se puede añadir otra implementación sin modificar a los controladores.
     - `OpenApiConfig` y `WebConfig` pueden recibir nuevas configuraciones sin alterar la lógica existente.

3. Liskov Substitution Principle (LSP)

   - `TokenService` implementa `TokenServiceInterface`, por lo que puede sustituirla en cualquier sitio donde se use la interfaz (por ejemplo, inyección en `TokenController`).

4. Interface Segregation Principle (ISP)

   - La interfaz `TokenServiceInterface` es pequeña y enfocada (solo `generateToken(...)`), evitando obligar a los consumidores a depender de métodos que no usan.

5. Dependency Inversion Principle (DIP)
   - Los controladores dependen de abstracciones (`TokenServiceInterface`) en lugar de implementaciones concretas. La inyección por constructor en `TokenController` permite invertir la dependencia y facilita pruebas y sustitución.

Aplicación de DRY (Don't Repeat Yourself)

- Centralización de constantes:

  - `ApiConstants.API_BASE` almacena el prefijo de ruta `/api` para evitar repetir la cadena en múltiples controladores.

- Reutilización de DTOs:

  - `TokenRequest` y `TokenResponse` evitan duplicar estructuras de datos entre endpoints y facilitan validación/serialización.

- Manejo centralizado de errores/validaciones:

  - `GlobalExceptionHandler` encapsula la lógica de respuesta ante validaciones fallidas (`MethodArgumentNotValidException`) y otras excepciones, evitando manejar errores repetidamente en cada controlador.

- Configuración centralizada:
  - `WebConfig` para CORS y `OpenApiConfig` para metadata de la API centralizan la configuración aplicable a toda la aplicación.

Notas y ejemplos concretos

- Validaciones: `TokenRequest` utiliza anotaciones de validación (`@NotBlank`, `@Positive`) lo que mueve la responsabilidad de validar datos fuera del controlador y evita código repetido de comprobación manual.

- Firma de tokens: la lógica de creación y firma del JWT está contenida en `TokenService`, que encapsula el uso de la librería `io.jsonwebtoken` y la lectura del secreto (`@Value("${jwt.secret}")`) desde `application.properties`.

Conclusión

El proyecto sigue prácticas básicas de diseño que favorecen separación de responsabilidades, inyección de dependencias y reducción de duplicación. La introducción de una interfaz para el servicio de tokens y la centralización de constantes, configuración y manejo de errores son los puntos clave donde SOLID y DRY se aplican de forma clara y práctica.
