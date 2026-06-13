# Data Warehouse E-commerce Brasil

Proyecto de Data Warehouse desarrollado para analizar información histórica de comercio electrónico en Brasil.

## Herramientas utilizadas

- Oracle Database 18c
- SQL Plus
- Oracle SQL Developer
- Talend Open Studio
- Power BI

## Contenido del repositorio

- `sql/`: Script de creación del Data Warehouse.
- `etl_talend/`: Exportación de los procesos ETL desarrollados en Talend.
- `powerbi/`: Archivo `.pbix` de la herramienta de exploración.
- `documentacion/`: Informe final y presentación.
- `dataset/`: Información del dataset utilizado.

## Tablas principales

### Hechos

- FACT_VENTAS
- FACT_PAGOS
- FACT_RESENAS

### Dimensiones

- DIM_TIEMPO
- DIM_CLIENTE
- DIM_PRODUCTO
- DIM_VENDEDOR
- DIM_METODO_PAGO
- DIM_UBICACION

## Resultados de carga

| Tabla | Registros |
|---|---:|
| FACT_VENTAS | 112650 |
| FACT_PAGOS | 103886 |
| FACT_RESENAS | 100000 |
| DIM_CLIENTE | 99441 |
| DIM_PRODUCTO | 32951 |
| DIM_UBICACION | 15249 |
| DIM_VENDEDOR | 3095 |
| DIM_TIEMPO | 755 |
| DIM_METODO_PAGO | 5 |

## Instrucciones

1. Ejecutar el script SQL en Oracle Database.
2. Importar el proyecto Talend desde `etl_talend/`.
3. Abrir el archivo Power BI ubicado en `powerbi/`.
4. Revisar las capturas y documentación del proyecto.