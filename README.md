# Proyecto Final: Análisis de Promotores (FIMO)

## 1. Descripción General del Proyecto

**¿Qué hace el proyecto?**
Este programa en Bash funciona como un buscador de secuencias llamadas elementos en cis en el ADN. Mediante fragmentos específicos (promotores) de genes de interes, primero se calcula el "ruido normal" del que tienen esta secuecia de pb y busca patrones estadísticos, esto sirve como un modelo de fondo. Estos patrones no permiten indicar indican dónde se unen proteínas específicas al ADN llamadas factores de transcripciòn.

**¿Para qué sirve?**
Sirve para descubrir qué factores de transcripcio, los "interruptores" controlan la expresión de ciertos genes en cietas condiciones de desarrollo.Permite aprender a manejar datos genómicos de forma real y encontrar candidatos a factores de regulacion en cientas condiciones de estudio, y a mi me ayuda a entender cómo se buscan secuencias sin sobrecargar la computadora y aplicar analsis sobre las mismas sobre mis genes de interes

---

## 2. Estructura del Repositorio

```text
proyecto_final/
├── README.md                 # Documento principal explicativo
├── scripts/                  # Script ejecutable principal (fimo_pipeline_mini.sh)
├── datos/                    # Archivos FASTA de entrada y matrices de búsqueda
├── resultados/               # Tablas y reportes generados
├── metadatos/                # Lista de IDs de genes válidos para consulta
├── programas_contenedores/   # Archivo de instalación del entorno (emediante un environment.yml)
├── config/                   # Parámetros del análisis
└── logs/                     # Registro de errores de ejecución

3. Programas Requeridos
El proyecto utiliza herramientas instaladas en un entorno virtual de Conda para asegurar que funcione igual en cualquier equipo y no genere conflictos

* MEME Suite (v5.5.9): Paquete principal para que análisis matemático y escaneo de motivos (`fasta-get-markov` y `fimo`) se realice (de proyecto https://meme-suite.org/meme/doc/fimo.html).
* Seqkit (v2.13.0): Herramienta ultra rápida para extraer y filtrar secuencias de ADN.
4. Entorno de Ejecución
Este programa fue diseñado y probado en el siguiente entorno de hardware y software:

* Sistema Operativo: Ubuntu 24.04.3 LTS
* Procesador: Intel Xeon CPU E5-2696 v4 (22 núcleos físicos)
* Memoria RAM: [64 GB]
* Gestor de paquetes: Conda
5. Instrucciones de Uso
Paso 1: Instalar y activar el entorno Abre la terminal en la carpeta principal del proyecto y ejecuta:
Bash

```
conda env create -f programas_contenedores/environment.yml
conda activate pipeline_phr1

```

Paso 2: Elegir los genes: Abre el archivo scripts/fimo_pipeline_mini.sh en un editor de texto. En las primeras líneas verás una lista llamada genes_elegidos, Pon ahí los IDs que quieres analizar consultando primero el archivo metadatos/lista_genes_consulta.txt.
Paso 3: Ejecutar el análisis 

```
chmod +x scripts/fimo_pipeline_mini.sh
./scripts/fimo_pipeline_mini.sh

```

6. Resultados Producidos
Una vez que el programa termina, genera dos salidas:

1. En la terminal: Una tabla limpia con los resultados más importantes, ordenados por relevancia matemática.
2. En la carpeta resultados/fimo/:
   * `fimo.tsv`: Tabla de datos completa, lista para usarse en Excel, R o Python.
   * `fimo.html`: Página web interactiva donde puedes ver de forma gráfica en qué posición exacta del promotor se encontró cada motivo.
   * `fimo.xml`: Archivo estructurado de uso interno para otros programas bioinformáticos.
