
# Projeto de Testes Automatizados de API - Robot Framework

Este projeto contém testes automatizados para a API do ReqRes, utilizando Robot Framework e a biblioteca Robot Framework Requests. Ele foi desenvolvido com o objetivo de validar a funcionalidade e os requisitos da API ReqRes, realizando operações como criar, atualizar e excluir usuários, além de consultar detalhes de usuários existentes e inexistentes.

## Estrutura do Projeto

A estrutura do projeto é a seguinte:

```
robot-reqres-api-test/
│
├── tests/
│   └── reqres_api_test.robot           # Arquivo principal de testes da API
│
├── resources/
│   └── api_request.resource           # Arquivo de recursos de API
│
├── results/
│   └── output.xml                     # Relatório de execução dos testes
│   └── log.html                       # Log detalhado dos testes
│   └── report.html                    # Relatório resumido de execução
│
├── README.md                          # Documentação do projeto
└── .github/
    └── workflows/
        └── robot-pipeline.yml         # Configuração do GitHub Actions
```

## Requisitos

Este projeto não exige a criação de um ambiente virtual, mas é necessário instalar as dependências abaixo para rodar os testes:

- `robotframework`
- `robotframework-requests`
- `robotframework-faker`
- `robotframework-jsonlibrary`

Para instalar as dependências, execute o seguinte comando:

```bash
pip install robotframework robotframework-requests robotframework-faker robotframework-jsonlibrary
```

## Executando os Testes

Para rodar os testes, execute o seguinte comando:

```bash
robot --outputdir results tests/
```

Isso irá gerar os arquivos de saída (`output.xml`), log (`log.html`) e relatório (`report.html`) na pasta `results/`.

## Atualizando Dependências

Sempre que houver atualizações nas dependências, você pode atualizar as bibliotecas executando:

```bash
pip install --upgrade robotframework robotframework-requests robotframework-faker robotframework-jsonlibrary
```

## GitHub Actions

Este repositório está configurado para rodar os testes automaticamente através do GitHub Actions. Quando você fizer um push para o repositório, o GitHub Actions irá executar os testes e gerar os relatórios de execução.

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).
