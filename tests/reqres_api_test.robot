*** Settings ***
Library    OperatingSystem
Library    RequestsLibrary
Library    FakerLibrary
Library    DateTime
Resource   ../resources/api_request.resource

*** Variables ***
${ID_USUARIO}=  0  # Inicializamos como 0, pois será atribuído no teste de criação.
@{cargos}    Developer    Tester    Manager    Analyst    Engineer    Designer

*** Test Cases ***
Criar Novo Usuario
    ${nome} =    FakerLibrary.Name
    ${rand} =    Evaluate    random.randint(0, len(${cargos})-1)    modules=random
    ${cargo} =   Get From List    ${cargos}    ${rand}
    ${ID_USUARIO}  ${NOME}  ${CARGO}  ${CREATED_AT}  ${response}=    Criar Usuario    ${nome}    ${cargo}
    Log    ID: ${ID_USUARIO}, Nome: ${NOME}, Cargo: ${CARGO}, Criado em: ${CREATED_AT}

    # Obtém a data atual no formato ISO
    ${data_atual} =    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S
    # Formata a data para YYYY-MM-DD
    ${data_formatada} =    Evaluate    '${data_atual}[:10]'
    Log    Data Atual formatada: ${data_formatada}

    # Remove segundos da data retornada pela API
    ${created_at_formatado} =    Evaluate    '${CREATED_AT}[:10]'
    Log    Data Criada (formatada): ${created_at_formatado}

    # Validações da resposta
    Should Be Equal As Strings    ${created_at_formatado}    ${data_formatada}
    Should Be Equal As Numbers    ${response.status_code}    201
    Should Be Equal As Strings    ${NOME}    ${response.json()["name"]}
    Should Be Equal As Strings    ${CARGO}    ${response.json()["job"]}

Obter Detalhes Usuario

    ${ID_EXISTENTE} =    Set Variable    2  
    # Chama a keyword para buscar o usuário
    ${response} =    Obter Usuario    ${ID_EXISTENTE}
    # Captura os valores retornados
    ${status_code} =    Set Variable    ${response}[status_code]  
    ${json_response} =    Set Variable    ${response}[json]  
    # Validações
    Should Be Equal As Numbers    ${status_code}    200
    Should Contain    ${json_response}    data
    Log  Usuário encontrado: ${json_response["data"]["first_name"]} ${json_response["data"]["last_name"]}

Obter Detalhes Usuario inexistente
    ${ID_INEXISTENTE} =    Set Variable    23  # ID que não existe na API

    # Chama a keyword para buscar um usuário que não existe
    ${response} =    Obter Usuario  ${ID_INEXISTENTE}

    # Verifica se a resposta contém um erro de falha (status_code)
    Run Keyword If    '${response['status_code']}' == '404'
    ...    Log    Erro ao buscar o usuário: ${response['error']}
    # Verifica a resposta caso o status seja 404
    Should Contain    ${response['error']}    User not found
    Log    Erro: Usuário com ID ${ID_INEXISTENTE} não encontrado, conforme esperado.
    # Validações
    Should Be Equal As Numbers    ${response['status_code']}    404
    Should Not Contain    ${response}    data

Atualizar Usuario
    ${nome} =    FakerLibrary.Name
    #${rand} =    Evaluate    random.randint(0, len(${cargos})-1)    modules=random
    ${cargo} =   Get From List    ${cargos}    ${{ random.randint(0, len($cargos)-1) }}
    #${cargo} =   Get From List    ${cargos}    ${rand}

    # Criamos um usuário para obter um ID válido
    ${ID_USUARIO}  ${NOME}  ${CARGO}  ${CREATED_AT}  ${response}=    Criar Usuario    ${nome}    ${cargo}
    

    # Criamos um novo nome e cargo para atualização
    ${novo_nome} =    FakerLibrary.Name
    #${novo_cargo} =   Get From List    ${cargos}    ${rand}
    ${novo_cargo} =   Get From List    ${cargos}    ${{ random.randint(0, len($cargos)-1) }}

    # Chamamos a keyword e obtemos a resposta
    ${response}  ${json_response}=    Atualizar Usuario  ${ID_USUARIO}  ${novo_nome}  ${novo_cargo}

    # Validações (Agora no Teste)
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Be Equal As Strings    ${json_response["name"]}    ${novo_nome}
    Should Be Equal As Strings    ${json_response["job"]}    ${novo_cargo}

    Log  Usuário Criado com sucesso! Nome: ${NOME}, Cargo: ${CARGO}
    Log  Usuário atualizado com sucesso! Novo nome: ${novo_nome}, Novo cargo: ${novo_cargo}


Excluir Usuario
    # Criamos um usuário antes de deletá-lo
    ${nome} =    FakerLibrary.Name
    ${rand} =    Evaluate    random.randint(0, len(${cargos})-1)    random
    ${cargo} =   Get From List    ${cargos}    ${rand}

    ${ID_USUARIO}  ${NOME}  ${CARGO}  ${CREATED_AT}  ${response}=    Criar Usuario    ${nome}    ${cargo}
    Log    ID Criado: ${ID_USUARIO}

    # Chamamos a keyword de deleção
    ${response} =    Excluir Usuario  ${ID_USUARIO}

    # Validações
    Should Be Equal As Numbers    ${response.status_code}    204
    Log  Usuário com ID ${ID_USUARIO} deletado com sucesso!
