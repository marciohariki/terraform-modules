# Documentação provisória

## Preparação

### Organização de pastas necessárias:

- `<root>`: raiz com os projetos
  - `terraform-modules`: repositório da implementação do Terraform
  - `infra-aws`: repositório da chamadas das implementações do Terraform
  - `lambda-modules`: repositório com Lambdas necessários para o pipeline

___TODO___: configurar `infra-aws` para consultar diretamente os repositórios Git,
para todos os módulos

### Pré-requisitos

- Terraform
- Docker
- Serverless
- Credenciais AWS configuradas no ambiente

## Levantando o pipeline

### Gerando a imagem do Sqoop Swarm
- Tenha o Docker instalado localmente
- Entre na pasta `terraform-modules/DockerSwarmImage`
- Execute o comando `./local.sh` - vai pedir sudo
  - A primeira criação da imagem em uma máquina é mais lenta, as subsequentes são rápidas

__TODO__: parametrizar URL do registro de imagens ECR utilizado.
Atual é `516136573270.dkr.ecr.us-east-1.amazonaws.com/kroton-analytics-sqoop`.

### Levantando os módulos do Lambda

Todos são levantados utilizando o framework Serverless.
Em cada pasta, executar:
- `npm install` - para instalar plugins necessários do Serverless
- `sls deploy --verbose --stage <dev|prod> `

As pastas são, preferencialmente nesta ordem:

- `lambda-modules/monitoring/monitoring-notifications`
- `lambda-modules/ingestion/firehose-parquet`
- `lambda-modules/ingestion/s3-on-premises`
  - Por uma limitação do Serverless/AWS, para conectar o lambda ao S3 de fato, é necessário
  rodar o comando extra `sls s3deploy --stafe <dev|prod>`
- `lambda-modules/ingestion/sqoop-swarm-ingestion/dynamodb-watcher`
  - A pasta contém scripts para inserir configurações de jobs para o SqoopSwarm

__TODO__: verificar os módulos, parameterizar todas as dependências externas que existirem e
hoje estiverem hardcoded (filas do SQS, tabelas do DynamoDB, buckets do S3, streams do Kinesis).

### Levantando o cluster
- Tenha o Terraform instalado
- Entre na pasta `infra-aws/DockerSwarmECSSetup`
- Execute `terraform init` para inicializar o Terraform
- Execute `terraform apply` para subir o cluster
  - É possível configurar o cluster em detalhes modificando os parâmetros presentes no `main.tf`.

## Páginas relevantes com o cluster de pé
- https://console.aws.amazon.com/dynamodb/home?region=us-east-1#tables:selected=ingestion_flux_log - Log de monitoramento dos jobs
- https://console.aws.amazon.com/dynamodb/home?region=us-east-1#tables:selected=sqoop_ingestion_configuration - Configurações de jobs lidas pelo SqoopSwarm e agendados pelo `dynamodb-watcher`
- https://console.aws.amazon.com/ecs/home?region=us-east-1#/clusters/KrotonSqoopSwarm - Detalhes do cluster (SqoopSwarm), tarefas e serviços executando nele.
- https://console.aws.amazon.com/ecs/home?region=us-east-1#/clusters/KrotonSqoopSwarm/services/KrotonSqoopSwarm-ECSService-LGHFKL23P3K2/logs - logs agregados de todos os containers rodando no cluster
- https://console.aws.amazon.com/sqs/home?region=us-east-1#queue-browser:selected=https://sqs.us-east-1.amazonaws.com/516136573270/sqoop_sqs_queue.fifo - Fila de jobs
  - Pode inserir jobs manualmente a partir dela, no formato:
  ```
    {"table_job_name": <nome_do_job>}
  ```
  `MessageGroupId` deve ser igual ao nome do job.
