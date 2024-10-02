CREATE OR REPLACE VIEW ZGLOSA.VW_ZG_ITENS_FATURADOS AS
SELECT TO_NUMBER (gcc_cod) CODIGO_PRESTADOR,
          cnv_cod CODIGO_OPERADORA,
          nfs_serie || nfs_numero CODIGO_REMESSA,
          nfs_serie || nfs_numero REMESSA,
          NVL (
             (SELECT gih_senha
                FROM smart.gih
               WHERE     gih_pac_reg = smm_pac_reg
                     AND gih_hsp_num = smm_hsp_num
                     AND gih_numero = cth_ctle_cnv
                     AND ROWNUM = 1),
             (smm_senha))
             SENHA_GUIA,
          CASE
             WHEN NVL (hsp_trat_int, 'X') = 'I'
             THEN
                'Internação'
             WHEN NVL (hsp_trat_int, 'X') = 'T'
                  AND hsp_str_cod IN ('PA', 'OPA')
             THEN
                'Pronto Socorro'
             WHEN NVL (hsp_trat_int, 'X') = 'T'
                  AND hsp_str_cod NOT IN ('PA', 'OPA')
             THEN
                'Exame Ambulatorial'
             ELSE
                DECODE ( (osm_tiss_tipo_atende),
                        '02', 'Pequena Cirurgia',
                        '03', 'Outras Terapias',
                        '04', 'Consulta',
                        '05', 'Exame Ambulatorial',
                        '07', 'Internação',
                        '08', 'Quimioterapia',
                        '09', 'Radioterapia',
                        '10', 'Terapia Renal Substitutiva (TRS)',
                        '11', 'Pronto Socorro',
                        '13', 'Pequeno atendimento')
          END
             TIPO_GUIA,
          (COALESCE (hsp_mcnv,
                     osm_mcnv,
                     pac_mcnv,
                     cth_mcnv))
             MATRICULA_BENEFICIARIO,
          pac_nome NOME_BENEFICIARIO,
          COALESCE (cth_dthr_ini, hsp_dthre, (osm_dthr))
             DATA_ATENDIMENTO_GUIA,
          COALESCE (cth_dthr_fin, hsp_dthra, (osm_dthr)) DATA_SAIDA_GUIA,
          COALESCE(cth_ctle_cnv, SMM_TISS_GUIA_OPERADORA) NUMERO_GUIA,
          NULL LOTE,
          cth_dthr_lib DATA_EMISSAO_GUIA,
          NVL (TO_CHAR (hsp_num), osm_serie || '.' || osm_num)
             NUMERO_ATENDIMENTO,
          NVL (TO_CHAR (cth_num), osm_serie || '.' || osm_num) NUMERO_CONTA,
          SMM_CTLE_CNV NUMERO_GUIA_PRESTADOR,
          (NVL (pln_hsp.pln_nome, pln_osm.pln_nome)) PLANO_BENEFICIARIO,
          smk_cod CODIGO_ITEM_SISTEMA,
          (smm_pre_ccv) CODIGO_ITEM,
          smk_nome DESCRICAO_ITEM,
          (smm_qt) QUANTIDADE_ITEM,
          (smm_vlr) VALOR_TOTAL_ITEM,
          (tab_padrao) CODIGO_TABELA_ITEM,
          (osm_dthr) DATA_ATENDIMENTO_ITEM,
          DECODE (
             smm_pacote,
             'P', 'Pacotes',
             DECODE (ctf_categ,
                     'C', 'Procedimentos',
                     'R', 'Procedimentos',
                     'E', 'Procedimentos',
                     'T', 'Taxas',
                     'D', 'Taxas',
                     'A', 'Procedimentos',
                     'M', 'Materiais',
                     'S', 'Materiais',
                     'N', 'Medicamentos',
                     'G', 'Taxas',
                     'O', 'Taxas'))
             CATEGORIA_ITEM,                                          /*null*/
          psv_exec.psv_crm CRM_EXECUTANTE,                            /*null*/
          psv_exec.psv_nome NOME_EXECUTANTE,                          /*null*/
          str_cod CODIGO_CC,                                          /*null*/
          str_nome DESCRICAO_CC,                                      /*null*/
          psv_solic.psv_crm CRM_SOLICITANTE,                          /*null*/
          psv_solic.psv_nome NOME_SOLICITANTE,
          (DECODE (
              smk_cod,
              '2999'                                        /* código filme */
                    , DECODE (smm_rx,
                              0, 0,
                              (smm_vlr / smm_rx))))
             VALOR_FILME,
          DECODE (smk_cod, '2999'                           /* código filme */
                                 , smm_rx) COEF_FILME,
          DECODE (ctf_categ,  'C', '08',  'R', '00',  'E', '11')
             GRAU_PARTICIPACAO,
          nfl_dt_emissao DATA_EMISSAO_NOTA_FISCAL,
          nfx_numero NUMERO_NOTA_FISCAL,
          nfl_dt_vcto DATA_VENCIMENTO_NOTA_FISCAL,
          '1.0.0' VERSAO,
          (SELECT gih_numero
             FROM smart.gih
            WHERE     gih_pac_reg = smm_pac_reg
                  AND gih_hsp_num = smm_hsp_num
                  AND gih_smk_cod = smm_cod/*and    gih_numero = cth_ctle_cnv*/
          )
             NUMERO_GUIA_GIH                                    /*tratamento*/
                            ,
          osm_ctle_cnv                                            /*consulta*/
                      ,
          osm_tiss_guia_principal
     FROM smart.nfs,
          smart.fat,
          smart.smm,
          smart.osm,
          smart.tab,
          smart.smk,
          smart.psv psv_exec,
          smart.psv psv_solic,
          smart.ctf,
          smart.str,
          smart.pac,
          smart.cth,
          smart.hsp,
          smart.nfl,
          smart.nfx,
          smart.cnv,
          smart.pln pln_hsp,
          smart.pln pln_osm,
          smart.gcc
    WHERE     nfs_tipo = fat_nfs_tipo
          AND nfs_serie = fat_nfs_serie
          AND nfs_numero = fat_nfs_numero
          AND fat_cnv = cnv_cod
          AND smm_fat_serie = fat_serie
          AND smm_fat = fat_num
          AND smm_tpcod = smk_tipo
          AND smm_cod = smk_cod
          AND smk_tipo = ctf_tipo
          AND smk_ctf = ctf_cod
          AND smm_tab_cod = tab_cod(+)
          AND smm_osm_serie = osm_serie
          AND smm_osm = osm_num
          AND smm_med = psv_exec.psv_cod
          AND smm_str = str_cod
          AND smm_pac_reg = cth_pac_reg(+)
          AND smm_hsp_num = cth_hsp_num(+)
          AND smm_cth_num = cth_num(+)
          AND smm_pac_reg = hsp_pac(+)
          AND smm_hsp_num = hsp_num(+)
          AND osm_mreq = psv_solic.psv_cod(+)
          AND hsp_pln_cod = pln_hsp.pln_cod(+)
          AND hsp_cnv = pln_hsp.pln_cnv_cod(+)
          AND osm_pln_cod = pln_osm.pln_cod(+)
          AND osm_cnv = pln_osm.pln_cnv_cod(+)
          AND osm_pac = pac_reg
          AND NVL (smm_pacote, 'X') <> 'C'
          AND nfs_nfl_serie = nfl_serie(+)
          AND nfs_nfl_num = nfl_num(+)
          AND nfl_serie = nfx_nfl_serie(+)
          AND nfl_num = nfx_nfl_num(+)
          AND nfs_tipo = 'NS'
          AND nfs_status = 'P'
          AND cnv_caixa_fatura = 'F'                              -- operadora
          AND gcc_default = 'S'
--and cth_ctle_cnv = '51125373'
--and cth_num = 23
--and pac_Reg = 417409
--and   hsp_num = 9
--and smk_cod = '411'