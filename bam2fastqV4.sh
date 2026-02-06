#!/bin/bash

# --- 1. Verificação de parâmetros (Imediata) ---
if [ "$#" -ne 2 ]; then
    echo "Erro: Parâmetros faltando."
    echo "Uso: $0 <diretorio_com_bams> <diretorio_de_saida>"
    exit 1
fi

# --- 2. Variáveis de Configuração ---
INPUT_DIR=$1
OUTPUT_DIR=$2
THREADS_PER_FILE=8
MAX_PARALLEL=8
START_TIME=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="log_bam2fastq_${START_TIME}.log"

# --- 3. Função Principal de Processamento ---
main_process() {
    mkdir -p "$OUTPUT_DIR"
    echo "======================================================="
    echo "SCRIPT INICIADO EM: $(date)"
    echo "LOG: $LOG_FILE"
    echo "======================================================="

    for bam_file in "$INPUT_DIR"/*.bam; do
        [ -e "$bam_file" ] || { echo "Erro: Nenhum BAM encontrado em $INPUT_DIR"; exit 1; }

        base_name=$(basename "$bam_file" .bam)

        (
            echo "[$(date +%H:%M:%S)] [Iniciando] $base_name"
            
            # Execução do samtools via pipe
            samtools sort -n -@ "$THREADS_PER_FILE" "$bam_file" | \
            samtools fastq -@ "$THREADS_PER_FILE" \
                -1 "${OUTPUT_DIR}/${base_name}.R1.fastq.gz" \
                -2 "${OUTPUT_DIR}/${base_name}.R2.fastq.gz" \
                -0 /dev/null -s /dev/null -
            
            if [ $? -eq 0 ]; then
                echo "[$(date +%H:%M:%S)] [Sucesso] $base_name concluído."
            else
                echo "[$(date +%H:%M:%S)] [Erro] Falha em $base_name."
            fi
        ) &

        # Controle de Paralelismo (MAX_PARALLEL=4)
        while [ $(jobs -rp | wc -l) -ge "$MAX_PARALLEL" ]; do
            sleep 2
        done
    done

    wait
    echo "======================================================="
    echo "PROCESSO FINALIZADO!"
    echo "======================================================="
}

# --- 4. Execução com Redirecionamento de Bloco ---
# Isso envia tudo da função para o log e tela, fechando o log ao terminar.
main_process 2>&1 | tee -a "$LOG_FILE"
