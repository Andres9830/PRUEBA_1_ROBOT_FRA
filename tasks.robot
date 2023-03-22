*** Settings ***
Documentation       Robot que hace un Login.

Library        SeleniumLibrary   
Library        RPA.HTTP
#Variables      variables.py
Library        RPA.Excel.Files
Library        Collections
*** Variables ***
${URL}    https://demoawsagp.siesaecommerce.com/home/
${BROWSER}        chrome
${MENU}    xpath://*[@id="aside_bar_menu"]/div/div/ul/li[15]
${ITEM}    xpath://*[@id="aside_bar_menu"]/div/div/ul/li[15]/ul/li[2]/a/span 
${DEPLOY}    xpath://*[@id="items_opal_search_form"]/div[1]/div/div/button   
${CONSULTAR}    xpath://*[@id="items_opal_search_form"]/div[1]/div/div/input       
${TABLA_XPATH}    xpath://*[@id="items_opal_search_form"]/div[4]/table/tbody
${NEW}    xpath://*[@id="topbar_content_id"]/div/a[1]
${SELECT}    xpath:/html/body/div[2]/div/div[4]/form/div/div[2]/div/div/div/div[5]/span/div/div[1]/span
${VALUE_SELECT}    xpath://*[@id="ui-select-choices-row-0-10"]/a
${VALUE_SELECT_2}    xpath://*[@id="ui-select-choices-row-0-4"]/a
${SAVE}    xpath://*[@id="topbar_content_id"]/div[2]/input
${SAVE_2}    xpath://*[@id="ui-select-choices-row-0-4"]/a
${VER_ITEMS}    xpath://*[@id="delete_form"]/ul[1]/li[5]/a
${BUSCAR}    xpath://*[@id="items_opal_search_form"]/div[1]/div/div/input
${EDIT}    xpath://*[@id="items_opal_search_form"]/div[4]/table/tbody[1]/tr/td[1]/a
${Checkbox}    xpath://*[@id="items_opal_search_form"]/div[2]/a
${Checkbox_all}    xpath://*[@id="items_opal_search_form"]/div[2]/ul/li[1]/a
${Checkbox_1}    xpath://*[@id="items_opal_search_form"]/div[4]/table/tbody/tr/td[1]/input                   
${Actions}    xpath://*[@id="items_opal_search_form"]/div[3]/a
${Delete}    xpath://*[@id="items_opal_search_form"]/div[3]/ul/li[5]/a 
${Alert}    alertify
${Confirmar}    alertify-ok
${userToggle}    xpath://*[@id="userToggle"]
${Log_out}    xpath:/html/body/div[2]/header/div/div/div[2]/div/div/ul/li[4]/a
${TABLE_ROW_COUNT}  0
${INDEX}  0


*** Test Cases ***
Open Intranet Robocorp
    ${options}=    Evaluate      sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --disable-notifications
    Call Method    ${options}    add_argument    --disable-geolocation
    Call Method    ${options}    add_argument    --use-fake-ui-for-media-stream

    Create WebDriver             Chrome    chrome_options=${options}
    Go To    https://demoawsagp.siesaecommerce.com/home/   
    Maximize Browser Window   

    input text                   //*[@id="pwd-container"]/div/section[1]/form/input[3]         Admin
    input text                   //*[@id="password"]                   DeV.2022
    click element                //*[@id="pwd-container"]/div/section[1]/form/div/button
    Sleep    3s
    Press Keys                   None    \\27
    Sleep    7
*** Keywords ***    
Menu
    
    Click Element     sidebarToggleLG
Item Consultar
    Click Element    ${MENU}
    Sleep    3s
    Click Element    ${ITEM}
    Sleep    3s
    Wait Until Page Contains Element    id=overlay_opal_notifications    
    Execute JavaScript    document.getElementById('overlay_opal_notifications').click();
    Click Element    ${DEPLOY}  
    Click Element    ${CONSULTAR} 
   
Validar Registro
    # Encontrar la tabla web
    ${tabla}    Get WebElements    xpath://div[contains(@class,'table-responsive')]

    # Buscar el registro con el número específico
    ${numero_especifico}    Set Variable    0000013
    ${registros}    Get WebElements    xpath=//tr[contains(., '${numero_especifico}')]

    # Verificar si existe solo un registro con ese número
    ${cantidad_registros}    Get Length    ${registros}
    Should Be Equal As Numbers    ${cantidad_registros}    1
Insert Dates
    
    [Arguments]    ${sales_rep}
    Click Link     ${NEW}
    Input Text    id_id_item    ${sales_rep}[Item Id] 
    Input Text    id_referencia    ${sales_rep}[Referencia]
    Input Text    id_descripcion    ${sales_rep}[Descripción]
    Click Element    ${SELECT} 
    Click Link    ${VALUE_SELECT} 
    Click Element    ${SAVE}
    
    Click Link    ${VER_ITEMS}
New Registres
    Open Workbook    SalesData.xlsx
    ${sales_reps}=    Read Worksheet As Table    header=True
    Close Workbook

    FOR    ${sales_rep}    IN    @{sales_reps}
        Insert Dates    ${sales_rep}    
   
    END
Inserte dates in Search Items
    [Arguments]    ${sales_rep}
    Input Text    id_referencia    ${sales_rep}[Referencia]
    Input Text    id_descripcion    ${sales_rep}[Descripción]
    Click Element    ${BUSCAR}
    Sleep    1s
    Click Element    ${DEPLOY}
Search Registres
    Open Workbook    SalesData.xlsx
    ${sales_reps}=    Read Worksheet As Table    header=True
    Close Workbook

    FOR    ${sales_rep}    IN    @{sales_reps}
        Inserte dates in Search Items    ${sales_rep}    
   
    END    
Edit Register
    Sleep    5s
    Click Link    ${EDIT}
    Sleep    2s
    Click Element    xpath:/html/body/div[2]/div/div[3]/form/div/div/div/div/div/div[5]/span/div/div[1]/span 
    Sleep    1s
    Click Link    ${VALUE_SELECT_2}   
    Click Element    xpath://*[@id="topbar_content_id"]/div[2]/input
    Click Link    ${VER_ITEMS}
Remove register
    Sleep    3s
    Click Element    ${DEPLOY}  
    Click Element    ${BUSCAR} 
    Click Link    ${Checkbox}
    Sleep     2s
    Click Element    ${Checkbox_all}
    Click Link    ${Actions}
    Sleep    2s
    Click Link    ${Delete}

    Wait Until Page Contains Element  ${Alert}
    Sleep    3s
    Click Button    ${Confirmar}

Insert Defaulf
    Sleep    3s
    Click Link    xpath://*[@id="topbar_content_id"]/div/a
    Click Link     ${NEW}
    Input Text    id_id_item    0000001 
    Input Text    id_referencia    0000013
    Input Text    id_descripcion    	Televisor marca samsung 48 pulgadas
    Click Element    ${SELECT} 
    Sleep    1s
    Click Link    ${VALUE_SELECT}   
    Click Element    ${SAVE}
    
    Click Link    ${VER_ITEMS}

Close Log Ing
    Click Link    ${userToggle}
    sleep    2s
    Click Link    ${Log_out}    

Open Browser and Loguing
    Menu
    Item Consultar
    Validar Registro
    New Registres
    Search Registres
    Edit Register
    Remove register
    Insert Defaulf
    Validar Registro
    Close Log Ing


