SELECT CNV.CNV_COD AS COD_CONVENIO ,
       CNV.CNV_NOME AS CONVENIO,
       PAC.PAC_REG AS REGISTRO,
       PAC.PAC_NOME AS PACIENTE,
       SMK.SMK_COD AS COD_PRD,
       SMK.SMK_ROT AS PRODUTO,
        Sum(CASE WHEN smm.smm_mog_cod_ajuste IS NULL OR smm.smm_qt > 0 THEN smm.smm_qt ELSE -1 * smm.smm_qt END) * ( Sum(smm.smm_vlr) / NULLIF(Sum(smm.smm_qt), 0) ) + Sum( CASE WHEN smm.smm_vlr < 0 THEN smm.smm_qt ELSE 0 END) * ( Sum(smm.smm_vlr) / NULLIF(Sum(smm.smm_qt), 0) ) AS Valor_inicial
FROM
       mog
       INNER JOIN smm ajuste ON (ajuste.smm_mog_cod_ajuste = mog.mog_cod)  AND ((To_char(AJUSTE.smm_dthr_alter, 'MM') - To_char(AJUSTE.smm_dthr_exec, 'MM') ) > 0 )
       INNER JOIN usr ON (usr.usr_login = AJUSTE.smm_rep)
       INNER JOIN hsp ON (ajuste.smm_hsp_num = hsp.hsp_num) AND (hsp.hsp_pac = ajuste.smm_pac_reg)
       INNER JOIN cth ON (cth.cth_hsp_num = AJUSTE.smm_hsp_num) AND (cth.cth_pac_reg = ajuste.smm_pac_reg) AND (AJUSTE.smm_cth_num = cth.cth_num)
       INNER JOIN cnv ON (cth.cth_cnv_cod = cnv.cnv_cod)
       INNER JOIN smm ON (smm.smm_cth_num = cth.cth_num) AND (smm.smm_hsp_num = hsp.hsp_num) AND (smm.smm_pac_reg = cth.cth_pac_reg) AND (smm.smm_cod = AJUSTE.smm_cod) AND (smm.smm_tpcod = AJUSTE.smm_tpcod)
       INNER JOIN osm ON (smm.smm_osm = osm.osm_num) AND (smm.smm_osm_serie = osm.osm_serie)
       INNER JOIN str ON (osm.osm_str = str.str_cod)
       INNER JOIN smk ON (smm.smm_cod = smk.smk_cod) AND (smk.smk_tipo = smm.smm_tpcod)
       INNER JOIN pac ON (smm.smm_pac_reg = pac.pac_reg)
WHERE
       AJUSTE.smm_dthr_alter >=  to_date ( '2024-06-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss' ) 
       AND AJUSTE.smm_dthr_alter <=  to_date ( '2024-06-30 00:00:00', 'yyyy-mm-dd hh24:mi:ss' ) AND
       CTH.CTH_NUM = 7 AND HSP.HSP_NUM  = 7 AND PAC.PAC_REG = 609878 AND SMK.SMK_COD = '31696'

GROUP BY CNV.CNV_COD,
       CNV.CNV_NOME,
       PAC.PAC_REG,
       PAC.PAC_NOME,
       SMK.SMK_COD,
       SMK.SMK_ROT


SELECT CNV.CNV_COD AS COD_CONVENIO,
       CNV.CNV_NOME AS CONVENIO,
       PAC.PAC_REG AS REGISTRO,
       PAC.PAC_NOME AS PACIENTE,
       SMK.SMK_COD AS COD_PRD,
       SMK.SMK_ROT AS PRODUTO,
       SUM(SMM.SMM_VLR) AS SOMA_ATUAL,
       (SUM(SMM.SMM_QT) * (SELECT SUM(A.SMM_VLR)/SUM(A.SMM_QT) FROM SMM A WHERE A.SMM_EXEC <> 'C' AND A.)) AS SOMA_HISTORICO,
       MAX(SMM.SMM_VLR)

FROM SMM
     INNER JOIN SMK ON (SMM.SMM_COD = SMK.SMK_COD) AND (SMK.SMK_TIPO = SMM.SMM_TPCOD)
     INNER JOIN PAC ON (SMM.SMM_PAC_REG = PAC.PAC_REG)
     INNER JOIN HSP ON (SMM.SMM_HSP_NUM = HSP.HSP_NUM) AND (HSP.HSP_PAC = SMM.SMM_PAC_REG)
     INNER JOIN CTH ON (CTH.CTH_HSP_NUM = SMM.SMM_HSP_NUM) AND (CTH.CTH_PAC_REG = SMM.SMM_PAC_REG) AND (SMM.SMM_CTH_NUM = CTH.CTH_NUM)
     INNER JOIN CNV ON (CTH.CTH_CNV_COD = CNV.CNV_COD)
     INNER JOIN PRE ON (SMM.SMM_TAB_COD = PRE.PRE_TAB_COD) AND (SMM.SMM_COD = PRE.PRE_SMK_COD) AND (SMM.SMM_TPCOD = PRE.PRE_SMK_TIPO)

WHERE  CTH.CTH_NUM = 5 AND HSP.HSP_NUM  = 18 AND PAC.PAC_REG = 592276 AND SMK.SMK_COD = '7920'

GROUP BY CNV.CNV_COD,
       CNV.CNV_NOME,
       PAC.PAC_REG,
       PAC.PAC_NOME,
       SMK.SMK_COD,
       SMK.SMK_ROT,
       SMM.SMM_AJUSTE_VLR