*** Settings ***
Library    RequestsLibrary
Library    FakerLibrary
Library    Collections
Library    JSONLibrary

*** Variables ***
${URL}      https://reqres.in/api/users

*** Keywords ***

Criar Usuario
    [Arguments]    ${nome}    ${cargo}
    Create Session  reqres  https://reqres.in  verify=False
    ${dados_usuario}=  Create Dictionary  name=${nome}  job=${cargo}
    
    ${response}=  POST On Session  reqres  /api/users  json=${dados_usuario}
    ${json_data} =  Set Variable  ${response.json()}

    ${id_usuario} =  Get From Dictionary  ${json_data}  id
    ${created_at} =  Get From Dictionary  ${json_data}  createdAt

    RETURN   ${id_usuario}  ${nome}  ${cargo}  ${created_at}  ${response}

Obter Usuario
    [Arguments]    ${id_usuario}
    Create Session  reqres  https://reqres.in  verify=False

    # Faz a requisição e captura a resposta completa
    ${response} =    GET On Session  reqres  /api/users/${id_usuario}  expected_status=any

    # Acessa diretamente o status_code da resposta e converte para string
    ${status_code} =    Evaluate    str(${response.status_code})

    # Verifica o código de status e trata a resposta
    IF    '${status_code}' == '200'
        ${json_response} =    Get Json Content    ${response}
        ${result} =    Create Dictionary    status_code=${status_code}    json=${json_response}
    ELSE
        ${result} =    Create Dictionary    status_code=${status_code}    error=User not found
    END

    RETURN    ${result}
    
Atualizar Usuario
    [Arguments]    ${id_usuario}    ${nome}    ${cargo}
    ${dados_atualizados}=  Create Dictionary  name=${nome}  job=${cargo}
    
    ${response}=  PUT On Session  reqres  /api/users/${id_usuario}  json=${dados_atualizados}
    ${json_response} =    Set Variable    ${response.json()}

    RETURN   ${response}  ${json_response}

Excluir Usuario
    [Arguments]    ${id_usuario}
    ${response}=  DELETE On Session  reqres  /api/users/${id_usuario}
    RETURN   ${response}


Get Status Code
    [Arguments]    ${response}
    ${status_code} =    Evaluate    str(${response.status_code})  # Converte para string
    RETURN    ${status_code}

Get Json Content
    [Arguments]    ${response}
    ${json_content} =    Set Variable    ${response.json()}  # Armazena o JSON da resposta
    RETURN    ${json_content}