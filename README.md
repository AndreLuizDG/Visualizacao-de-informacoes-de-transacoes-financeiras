
# visualização de informações de transações financeiras

Este código é um relatório ABAP chamado "z_algj_42" desenvolvido por André Luiz Guilhermini Junior, criado em 01/02/2024. Ele extrai dados das tabelas BSAD, VBRK, VBRP e MAKT e os exibe em um ALV Grid Display. Aqui está uma descrição detalhada do que o código faz:

Declarações e definições: Define tipos de tabela, constantes, tipos de dados e declara variáveis para armazenar os dados.

Tela de Seleção (Selection-Screen): Define parâmetros e seletores para que o usuário especifique critérios de seleção, como a empresa (bukrs), o cliente (kunnr), o número de documento (augbl) e o ano fiscal (gjahr).

Eventos:

START-OF-SELECTION: Inicia a execução do programa.
END-OF-SELECTION: Executa processamentos após a seleção dos dados.
Forms (Sub-rotinas):

zf_seleciona_dados: Seleciona dados das tabelas BSAD, VBRK, VBRP e MAKT com base nos critérios de seleção fornecidos na tela de seleção.
zf_processa_dados: Processa os dados selecionados, relacionando-os conforme necessário e os armazena na tabela de saída (ti_saida).
zf_monata_tabela_fieldcat: Monta a estrutura do catálogo de campos para o ALV Grid Display.
zf_monta_fieldcat: Auxiliar para montar o catálogo de campos.
zf_mostra_alv: Exibe os dados processados em um ALV Grid Display.
zf_quebra_de_campo: Define a quebra de campo para a saída.
zf_top_of_page: Define o cabeçalho da página ALV.
z_user_command: Define ações do usuário no ALV Grid Display.
Chamadas de Funções Externas:

REUSE_ALV_GRID_DISPLAY: Exibe os dados processados em um ALV Grid.
REUSE_ALV_COMMENTARY_WRITE: Escreve comentários no cabeçalho do relatório.


## Autores

- [@AndreLuizDG](https://github.com/AndreLuizDG)

