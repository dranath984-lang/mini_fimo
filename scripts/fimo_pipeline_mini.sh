#!/usr/bin/env bash
set -euo pipefail


# PASO 0: Configuracion de inputs
# En esta secciòn es en donde se puede elegir y editar los genes objetivos para 
# para el analsis fimo
genes_elegidos=(
    "Phvul.001G004200"
    "Phvul.004G173900"
    "Phvul.006G134700"
)

# Aquì se esta determinando las rutas de los archivos que se van a utilizar 
# Rutas de los archivos del proyecto
master_fasta="datos/fasta/fasta_analisis/Pvulgaris_1000bp_upstream_TSS.fasta"
target_fasta="datos/fasta/fasta_analisis/target_batch.fasta"
bg_fasta="datos/fasta/fasta_background/Pvulgaris_1000bp_upstream_fondo_TSS.fasta"
meme_file="datos/motivos/Pvu_TF_binding_motifs.meme"
bg_bfile="datos/fasta/fasta_background/Pvulgaris_order1.bfile"
out_dir="resultados/fimo"

# PASO 1: Para poder extrar la lista de genes convertimos la lista de genes 
# a un archivo temporal que sea temporal para extraerlos del FASTA maestro y 
# no generar archivos que consuman espacio
#extraemos los genes y damos el formato de texto en lista en un archivo txt temporal 
printf "%s\n" "${genes_elegidos[@]}" > lista_temporal_genes.txt
# El archivo.txt pasa a seqkit busca en el archivo fasta y extrae solo las coincidencias 
# los resultadoslos guarda enel archivo temporal $target_fasta
seqkit grep -f lista_temporal_genes.txt "$master_fasta" > "$target_fasta"

# PASO 2: Debemos de generar un control negativo que se comoce como modelo de fondo o 
# Background para evitar que se presenten falsos positivos 
# Para esto calculamos las frecuencias a partir de la secencia contrl escogida 
# de forma aleatorea para esto ocupamos la funcion de la suit de meme fasta-get-markov 
# asi como el orden que queremos que aplique para las operaciones matematicas que 
# permiten calcular la probabilidad de encontrar cada par de base en la posocion al azar 
# e indicamos el tipo de material genetico "DNA" como input tenemos la secuencia control y 
# como output tenemos un archivo bfile que contendra los parametros de la secuencia control
fasta-get-markov -m 1 -dna "$bg_fasta" "$bg_bfile"

# PASO 3: Escaneo de los motivos con la herramienta de FIMO 
# Buscamos los motivos en las secuencias extraídas usando el modelo de fondo
# borramos la carpeta de resultados de la ejecución anteriorpara no combinar resultados
rm -rf "$out_dir"
# bucamos y abrimos el programa y lo configuramoscon el archivo bfile que contiene el modelo de fondo
# despues con thresh indicamos el nivel de significancia, este paso es inportante para que no nos 
# salgan falsos positivos (1e-5 es lo que recomienda el propio programa, ademas de configurar con --no-pgc)
# para que no calcule por si mimo el modelo de fondo y por ultimo le indicamos en donde en donde debe de guardar 
# los resultados y cuales son los inputs
fimo \
    --bfile "$bg_bfile" \
    --thresh 1e-5 \
    --no-pgc \
    --oc "$out_dir" \
    "$meme_file" \
    "$target_fasta"

# PASO 4: Visualizaciòn de datos, para mayor comodidad y ver los primeros resultados configuramos para que 
# en la terminal aparescan los datos sin importar su tamaño en posiciones constantes alineadas 
printf "%-15s %-25s %-8s %-8s %-8s %-10s\n" "MOTIVO_ID" "GEN_ID" "START" "STOP" "SCORE" "P-VALUE"
# Ahoa agregamos un condicion antes de imprimir nada, tenemos que asegurarnos si el archivodel analsis se
# genero y si no imprime nada significara que ocurrio un error en la ejecuciòn
# para que en la consola se puedan observar los datos y no las lineas de texto de comentarios las excluimos
# con grep -v "^#" ademas de que indicamos que el archivo esta por tabulaciones y despues solo elegimos 
# las primeras 16 lineas (como una muestra evitando la fila de nombres en ingles que por defecto tiene fimo)
if [ -f "${out_dir}/fimo.tsv" ]; then
    grep -v "^#" "${out_dir}/fimo.tsv" | head -16 | tail -n +2 | awk -F'\t' '{
        printf "%-15s %-25s %-8s %-8s %-8s %-10s\n", $1, $3, $4, $5, $7, $8
    }'
fi

# Finalmente borramos los archivo temporales para que no ocupen espacio o causen conflictos futuros
rm -f "$target_fasta" lista_temporal_genes.txt