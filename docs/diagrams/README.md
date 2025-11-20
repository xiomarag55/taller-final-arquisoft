Diagrams (PlantUML)

This folder contains PlantUML diagrams describing the project's architecture:

- component_diagram.puml : High-level components and their interactions (controllers, service, config, JWT lib, properties).
- class_diagram.puml : Simplified class diagram with main classes, interfaces and relations.

How to render

1. Using VSCode: install the "PlantUML" extension (by jebbs). Open a `.puml` file and click the preview button.

2. Using PlantUML jar (requires Java):

   - Download PlantUML and Graphviz if you need PNG/SVG output.
   - Render PNG: java -jar plantuml.jar component_diagram.puml

3. Using Docker:

   docker run --rm -v %CD%:/workspace -w /workspace plantuml/plantuml -tpng docs/diagrams/component_diagram.puml

Notes

- The diagrams are editable. If you add new controllers or services, update the `.puml` files accordingly.
- The class diagram is intentionally simplified (omits imports and internal types) to keep it readable.
