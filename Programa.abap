REPORT z_algj_42.

*$*$ -------------------------------------------------------------- *$*$
*$*$ AUTOR      : ANDRÉ LUIZ GUILHERMINI JUNIOR                     *$*$
*$*$ DATA       : 01/02/2024                                        *$*$
*$*$ -------------------------------------------------------------- *$*$

*$*$ -------------------------------------------------------------- *$*$
*$*$                         DECLARAÇÕES                            *$*$
*$*$ -------------------------------------------------------------- *$*$

TABLES: bsad.

TYPE-POOLS slis.

TYPES:
  BEGIN OF ty_bsad,
    bukrs TYPE bsad-bukrs,
    kunnr TYPE bsad-kunnr,
    augdt TYPE bsad-augdt,
    augbl TYPE bsad-augbl,
    gjahr TYPE bsad-gjahr,
    belnr TYPE bsad-belnr,
    buzei TYPE bsad-buzei,
    vbeln TYPE bsad-vbeln,
  END OF ty_bsad,

  BEGIN OF ty_vbrk,
    vbeln TYPE vbrk-vbeln,
    fkdat TYPE vbrk-fkdat,
  END OF ty_vbrk,

  BEGIN OF ty_vbrp,
    vbeln TYPE vbrp-vbeln,
    posnr TYPE vbrp-posnr,
    fkimg TYPE vbrp-fkimg,
    vrkme TYPE vbrp-vrkme,
    netwr TYPE vbrp-netwr,
    matnr TYPE vbrp-matnr,
  END OF ty_vbrp,

  BEGIN OF ty_makt,
    matnr TYPE matnr,
    maktx TYPE maktx,
  END OF ty_makt,

  BEGIN OF ty_saida,
    bukrs TYPE bsad-bukrs,
    kunnr TYPE bsad-kunnr,
    augdt TYPE bsad-augdt,
    augbl TYPE bsad-augbl,
    gjahr TYPE bsad-gjahr,
    belnr TYPE bsad-belnr,
    buzei TYPE bsad-buzei,
    vbeln TYPE vbrk-vbeln,
    fkdat TYPE vbrk-fkdat,
    posnr TYPE vbrp-posnr,
    fkimg TYPE vbrp-fkimg,
    vrkme TYPE vbrp-vrkme,
    netwr TYPE vbrp-netwr,
    matnr TYPE vbrp-matnr,
    maktx TYPE makt-maktx,
  END OF ty_saida.

DATA: ti_bsad       TYPE TABLE OF ty_bsad,
      ti_vbrk       TYPE TABLE OF ty_vbrk,
      ti_vbrp       TYPE TABLE OF ty_vbrp,
      ti_makt       TYPE TABLE OF ty_makt,
      ti_saida      TYPE TABLE OF ty_saida,
      ti_fieldcat   TYPE TABLE OF slis_fieldcat_alv,
      ti_sort       TYPE TABLE OF slis_sortinfo_alv,
      ti_listheader TYPE TABLE OF slis_listheader.

DATA: wa_saida      TYPE ty_saida,
      wa_fieldcat   TYPE slis_fieldcat_alv,
      wa_sort       TYPE slis_sortinfo_alv,
      wa_listheader TYPE slis_listheader.

CONSTANTS:
  c_e              TYPE char1 VALUE 'E',
  c_s              TYPE char1 VALUE 'S',
  c_x              TYPE char1 VALUE 'X',
  c_rv             TYPE char2 VALUE 'RV',
  c_1000           TYPE char4 VALUE '1000',
  c_0000001050     TYPE char10 VALUE '0000001050',
  c_2007           TYPE char4 VALUE '2007',
  c_f2             TYPE char2 VALUE 'F2',
  c_bukrs          TYPE char5 VALUE  'BUKRS',
  c_kunnr          TYPE char5 VALUE  'KUNNR',
  c_augdt          TYPE char5 VALUE  'AUGDT',
  c_augbl          TYPE char5 VALUE  'AUGBL',
  c_gjahr          TYPE char5 VALUE  'GJAHR',
  c_belnr          TYPE char5 VALUE  'BELNR',
  c_buzei          TYPE char5 VALUE  'BUZEI',
  c_vbeln          TYPE char5 VALUE  'VBELN',
  c_fkdat          TYPE char5 VALUE  'FKDAT',
  c_posnr          TYPE char5 VALUE  'POSNR',
  c_fkimg          TYPE char5 VALUE  'FKIMG',
  c_vrkme          TYPE char5 VALUE  'VRKME',
  c_netwr          TYPE char5 VALUE  'NETWR',
  c_matnr          TYPE char5 VALUE  'MATNR',
  c_maktx          TYPE char5 VALUE  'MAKTX',
  c_bsad           TYPE char4 VALUE  'BSAD',
  c_vbrk           TYPE char4 VALUE  'VBRK',
  c_vbrp           TYPE char4 VALUE  'VBRP',
  c_makt           TYPE char4 VALUE  'MAKT',
  c_ti_saida       TYPE char8 VALUE  'TI_SAIDA',
  c_gui_status_42  TYPE char14 VALUE 'GUI_STATUS_42',
  c_buk            TYPE char3 VALUE 'BUK',
  c_bln            TYPE char3 VALUE 'BLN',
  c_gjr            TYPE char3 VALUE 'GJR',
  c_fb03           TYPE char4 VALUE 'FB03',
  c_back           TYPE char4 VALUE 'BACK',
  c_stop           TYPE char4 VALUE 'STOP',
  c_exit           TYPE char4 VALUE 'EXIT',
  c_zf_status      TYPE slis_formname  VALUE 'ZF_STATUS',
  c_z_user_command TYPE slis_formname  VALUE 'Z_USER_COMMAND',
  c_zf_top_of_page TYPE slis_formname  VALUE 'ZF_TOP_OF_PAGE',
  c_separador1     TYPE char1 VALUE '/',
  c_separador2     TYPE char1 VALUE ':'.

*$*$ -------------------------------------------------------------- *$*$
*$*$                            TELA                                *$*$
*$*$ -------------------------------------------------------------- *$*$

SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE text-001. "Tela de seleção

PARAMETERS:     p_bukrs TYPE bsad-bukrs DEFAULT c_1000,
                p_kunnr TYPE bsad-kunnr DEFAULT c_0000001050.
SELECT-OPTIONS: s_augbl FOR  bsad-augbl.
PARAMETERS:     p_gjahr TYPE bsad-gjahr DEFAULT c_2007.

SELECTION-SCREEN: END OF BLOCK b1.

*$*$ -------------------------------------------------------------- *$*$
*$*$                           EVENTOS                              *$*$
*$*$ -------------------------------------------------------------- *$*$

START-OF-SELECTION.
  PERFORM zf_seleciona_dados.

END-OF-SELECTION.
  PERFORM: zf_processa_dados,
           zf_monata_tabela_fieldcat,
           zf_quebra_de_campo,
           zf_mostra_alv.

*$*$ -------------------------------------------------------------- *$*$
*$*$                            FORMS                               *$*$
*$*$ -------------------------------------------------------------- *$*$

FORM zf_seleciona_dados.

  FREE ti_bsad.
  SELECT bukrs
         kunnr
         augdt
         augbl
         gjahr
         belnr
         buzei
         vbeln
    FROM bsad
    INTO TABLE ti_bsad
   WHERE bukrs = p_bukrs
     AND kunnr = p_kunnr
     AND augbl IN s_augbl
     AND gjahr = p_gjahr
     AND blart = c_rv.

  IF sy-subrc <> 0.
    FREE ti_bsad.
    MESSAGE text-e01 TYPE c_s DISPLAY LIKE c_e. "Dados não encontrados!
    LEAVE LIST-PROCESSING.
  ENDIF.

  IF ti_bsad IS NOT INITIAL.

    DATA(ti_bsad_aux) = ti_bsad.
    SORT ti_bsad_aux BY vbeln.
    DELETE ADJACENT DUPLICATES FROM ti_bsad_aux COMPARING vbeln.

    FREE ti_vbrk.
    SELECT vbeln
           fkdat
      FROM vbrk
      INTO TABLE ti_vbrk
       FOR ALL ENTRIES IN ti_bsad_aux
     WHERE vbeln = ti_bsad_aux-vbeln
       AND fkart = c_f2.

    IF sy-subrc <> 0.
      FREE ti_vbrk.
      MESSAGE text-e01 TYPE c_s DISPLAY LIKE c_e. "Dados não encontrados!
      LEAVE LIST-PROCESSING.
    ENDIF.
  ENDIF. "ti_bsad IS NOT INITIAL.

  IF ti_vbrk IS NOT INITIAL.

    FREE ti_vbrp.
    SELECT vbeln
           posnr
           fkimg
           vrkme
           netwr
           matnr
      FROM vbrp
      INTO TABLE ti_vbrp
       FOR ALL ENTRIES IN ti_vbrk
     WHERE vbeln = ti_vbrk-vbeln.

    IF sy-subrc <> 0.
      FREE ti_vbrp.
    ENDIF.

  ENDIF. "ti_vbrk IS NOT INITIAL.

  IF ti_vbrp IS NOT INITIAL.

    DATA(ti_vbrp_aux) = ti_vbrp.
    SORT ti_vbrp_aux BY matnr.
    DELETE ADJACENT DUPLICATES FROM ti_vbrp_aux COMPARING matnr.

    FREE ti_makt.
    SELECT matnr
           maktx
      FROM makt
      INTO TABLE ti_makt
       FOR ALL ENTRIES IN ti_vbrp
     WHERE matnr = ti_vbrp-matnr
       AND spras = sy-langu.

    IF sy-subrc <> 0.
      FREE ti_vbrp.
    ENDIF.
  ENDIF. " ti_vbrp IS NOT INITIAL.

ENDFORM. " zf_seleciona_dados

FORM zf_processa_dados.

  SORT: ti_bsad BY vbeln,
        ti_vbrk BY vbeln,
        ti_vbrp BY vbeln,
        ti_makt BY matnr.

  LOOP AT ti_bsad INTO DATA(wa_bsad).


    READ TABLE ti_vbrk INTO DATA(wa_vbrk) WITH KEY
                                          vbeln = wa_bsad-vbeln BINARY SEARCH.

    IF sy-subrc = 0.

      READ TABLE ti_vbrp INTO DATA(wa_vbrp) WITH KEY
                                            vbeln = wa_vbrk-vbeln BINARY SEARCH.

      IF sy-subrc = 0.

        READ TABLE ti_makt INTO DATA(wa_makt) WITH KEY
                                              matnr = wa_vbrp-matnr BINARY SEARCH.

      ENDIF.

    ENDIF.

    wa_saida-bukrs = wa_bsad-bukrs.
    wa_saida-kunnr = wa_bsad-kunnr.
    wa_saida-augdt = wa_bsad-augdt.
    wa_saida-augbl = wa_bsad-augbl.
    wa_saida-gjahr = wa_bsad-gjahr.
    wa_saida-belnr = wa_bsad-belnr.
    wa_saida-buzei = wa_bsad-buzei.
    wa_saida-vbeln = wa_vbrk-vbeln.
    wa_saida-fkdat = wa_vbrk-fkdat.
    wa_saida-posnr = wa_vbrp-posnr.
    wa_saida-fkimg = wa_vbrp-fkimg.
    wa_saida-vrkme = wa_vbrp-vrkme.
    wa_saida-netwr = wa_vbrp-netwr.
    wa_saida-matnr = wa_vbrp-matnr.
    wa_saida-maktx = wa_makt-maktx.
    APPEND wa_saida TO ti_saida.

  ENDLOOP.

ENDFORM. " zf_processa_dados

FORM zf_monata_tabela_fieldcat.

  PERFORM zf_monta_fieldcat USING:
  c_bukrs   c_ti_saida   c_bukrs   c_bsad   ''    '',
  c_kunnr   c_ti_saida   c_kunnr   c_bsad   ''    '',
  c_augdt   c_ti_saida   c_augdt   c_bsad   ''    '',
  c_augbl   c_ti_saida   c_augbl   c_bsad   ''    c_x,
  c_gjahr   c_ti_saida   c_gjahr   c_bsad   ''    '',
  c_belnr   c_ti_saida   c_belnr   c_bsad   ''    c_x,
  c_buzei   c_ti_saida   c_buzei   c_bsad   ''    '',
  c_vbeln   c_ti_saida   c_vbeln   c_vbrk   ''    '',
  c_fkdat   c_ti_saida   c_fkdat   c_vbrk   ''    '',
  c_posnr   c_ti_saida   c_posnr   c_vbrp   ''    '',
  c_fkimg   c_ti_saida   c_fkimg   c_vbrp   c_x   '',
  c_vrkme   c_ti_saida   c_vrkme   c_vbrp   ''    '',
  c_netwr   c_ti_saida   c_netwr   c_vbrp   c_x   '',
  c_matnr   c_ti_saida   c_matnr   c_vbrp   ''    '',
  c_maktx   c_ti_saida   c_maktx   c_makt   ''    ''.

ENDFORM. "zf_monata_tabela_fieldcat

FORM zf_monta_fieldcat USING l_fieldname     TYPE any
                             l_tabname       TYPE any
                             l_ref_fieldname TYPE any
                             l_ref_tabname   TYPE any
                             l_do_sumd       TYPE any
                             l_hotspot       TYPE any.

  CLEAR wa_fieldcat.
  wa_fieldcat-fieldname        = l_fieldname.
  wa_fieldcat-tabname          = l_tabname.
  wa_fieldcat-ref_fieldname    = l_ref_fieldname.
  wa_fieldcat-ref_tabname      = l_ref_tabname.
  wa_fieldcat-do_sum           = l_do_sumd.
  wa_fieldcat-hotspot          = l_hotspot.
  APPEND wa_fieldcat TO ti_fieldcat.

ENDFORM. "zf_monta_fieldcat

FORM zf_mostra_alv.

  DATA: wa_layout TYPE slis_layout_alv.

  wa_layout-expand_all        = abap_true.
  wa_layout-colwidth_optimize = abap_true.
  wa_layout-zebra             = abap_true.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
      i_callback_pf_status_set = c_zf_status
      i_callback_user_command  = c_z_user_command
      i_callback_top_of_page   = c_zf_top_of_page
      is_layout                = wa_layout
      it_fieldcat              = ti_fieldcat
      it_sort                  = ti_sort
    TABLES
      t_outtab                 = ti_saida
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.

FORM zf_quebra_de_campo.

  FREE ti_sort.

  CLEAR wa_sort.
  wa_sort-spos      = 1.
  wa_sort-fieldname = c_fkdat.
  wa_sort-tabname   = c_ti_saida.
  wa_sort-up        = abap_true.
  wa_sort-subtot    = abap_true.
  APPEND wa_sort TO ti_sort.

ENDFORM. "zf_quebra_de_campo

##CALLED
FORM zf_top_of_page.

  DATA: data      TYPE char10,
        hora      TYPE char5,
        timestamp TYPE char20.


  CONCATENATE sy-datum+6(2)
              sy-datum+4(2)
              sy-datum+0(4)
             INTO  data SEPARATED BY c_separador1.

  CONCATENATE sy-uzeit+0(2)
              sy-uzeit+2(2)
             INTO hora SEPARATED BY c_separador2.

  CONCATENATE data hora INTO timestamp SEPARATED BY space.

  FREE: ti_listheader[], wa_listheader.

  CLEAR wa_listheader.
  wa_listheader-typ  = c_s.
  wa_listheader-info = text-002. "Relatório de Partidas Compensadas de Clientes
  APPEND wa_listheader TO ti_listheader.

  CLEAR wa_listheader.
  wa_listheader-typ  = c_s.
  wa_listheader-info = text-003. "André Luiz
  APPEND wa_listheader TO ti_listheader.

  CLEAR wa_listheader.
  wa_listheader-typ  = c_s.
  wa_listheader-info = timestamp.
  APPEND wa_listheader TO ti_listheader.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = ti_listheader.

ENDFORM.

FORM z_user_command USING vl_ucomm LIKE sy-ucomm
                  rs_selfield TYPE slis_selfield.

  CASE vl_ucomm.

    WHEN c_back OR c_stop OR c_exit.
      LEAVE LIST-PROCESSING.

    WHEN OTHERS.

      IF rs_selfield-fieldname = c_augbl.

        READ TABLE ti_saida INTO wa_saida INDEX rs_selfield-tabindex.
        IF sy-subrc = 0.
          SET PARAMETER ID c_buk  FIELD wa_saida-bukrs.
          SET PARAMETER ID c_bln  FIELD wa_saida-augbl.
          SET PARAMETER ID c_gjr  FIELD wa_saida-gjahr.
          CALL TRANSACTION c_fb03 AND SKIP FIRST SCREEN.
        ENDIF.

      ELSEIF rs_selfield-fieldname = c_belnr.

        READ TABLE ti_saida INTO wa_saida INDEX rs_selfield-tabindex.
        IF sy-subrc = 0.
          SET PARAMETER ID c_buk  FIELD wa_saida-bukrs.
          SET PARAMETER ID c_bln  FIELD wa_saida-belnr.
          SET PARAMETER ID c_gjr  FIELD wa_saida-gjahr.
          CALL TRANSACTION c_fb03 AND SKIP FIRST SCREEN.
        ENDIF.

      ENDIF.

  ENDCASE.

ENDFORM.

FORM zf_status USING pf_tab TYPE slis_t_extab.
  SET PF-STATUS c_gui_status_42.
ENDFORM.
