# bam2fastq
Repositório para o script de conversão de arquivos bam para fastq usado para alguns dados no contexto do Oncogensus

## 🚀 Funcionalidades

* **Processamento em Lote:** Varre um diretório de entrada e processa todos os arquivos `.bam` encontrados.
* **Pipeline Otimizado:** Utiliza pipes (`|`) para realizar o `samtools sort -n` (ordenação por nome) e `samtools fastq` simultaneamente, evitando a criação de arquivos intermediários pesados.
* **Paralelismo Controlado:** Gerencia o número de arquivos processados simultaneamente para otimizar o uso de recursos do servidor.
* **Logging Completo:** Gera um log detalhado com timestamps e status de execução para cada amostra.


## 📋 Pré-requisitos

Certifique-se de ter as seguintes ferramentas instaladas e configuradas no seu `$PATH`:
* **Samtools** (recomendado versão 1.10 ou superior)
* Ambiente **Bash** (Linux/macOS)

## 🛠️ Configuração Técnica

O script utiliza os seguintes parâmetros internos para controle de performance:

| Parâmetro | Valor Padrão | Descrição |
| :--- | :--- | :--- |
| `THREADS_PER_FILE` | 8 | CPUs usadas por cada instância do samtools. |
| `MAX_PARALLEL` | 8 | Máximo de arquivos BAM processados em paralelo. |
| `OUTPUT_FORMAT` | `.fastq.gz` | Saída compactada (paired-end R1/R2). |

## 📖 Como Usar

1. **Dê permissão de execução ao script:**
   ```bash
   chmod +x bam2fastq.sh

2. **Execute passando os diretórios de entrada e saída:**
  ```bash
./bam2fastq.sh /caminho/dos/bams /caminho/da/saida


📂 Estrutura de Saída
Para cada arquivo amostra.bam, o script gerará:

amostra.R1.fastq.gz

amostra.R2.fastq.gz

Um arquivo de log consolidado: log_bam2fastq_YYYYMMDD_HHMMSS.log
