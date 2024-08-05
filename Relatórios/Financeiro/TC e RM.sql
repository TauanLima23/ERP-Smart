SELECT OSM.OSM_SERIE,
       OSM.OSM_NUM,
       OSM.OSM_DTHR,
       PAC.PAC_NOME,
       SMK.SMK_NOME,
       PSV.PSV_CRM,
       PSV.PSV_APEL,
       SUM(SMM.SMM_VLR) AS VLR,
       EXT.EXT_VALOR_GLOSA,
       EXT.EXT_VALOR_RECEB,
       CTF.CTF_NOME
FROM SMM 
     INNER JOIN OSM ON (OSM.OSM_SERIE = SMM.SMM_OSM_SERIE) AND (OSM.OSM_NUM = SMM.SMM_OSM)
     INNER JOIN PAC ON (PAC.PAC_REG = OSM.OSM_PAC)
     INNER JOIN SMK ON (SMK.SMK_COD = SMM.SMM_COD) AND (SMK.SMK_TIPO = SMM.SMM_TPCOD)
     INNER JOIN CTF ON (SMK.SMK_CTF = CTF.CTF_COD)
     INNER JOIN PSV ON (SMM.SMM_MED = PSV.PSV_COD)
     INNER JOIN CNV ON (CNV.CNV_COD = OSM.OSM_CNV)
     LEFT JOIN EXT ON (EXT.EXT_OSM_SERIE = OSM.OSM_SERIE) AND (EXT.EXT_OSM_NUM = OSM.OSM_NUM) AND (EXT.EXT_SMM_NUM = SMM.SMM_NUM)
  
WHERE SMM.SMM_DTHR_LANC >  '2024-07-01 00:00:00' AND
      SMM.SMM_OSM = 41823 AND 
      SMM.SMM_EXEC <> 'C' AND
      SMK.SMK_TIPO = 'S' AND 
      CNV.CNV_CAIXA_FATURA = 'F'

GROUP BY OSM.OSM_SERIE,
       OSM.OSM_NUM,
SMK.SMK_COD,
SMK.SMK_NOME,
CTF.CTF_NOME,
OSM.OSM_DTHR,
PAC.PAC_NOME,
PSV.PSV_CRM,
       PSV.PSV_APEL,
EXT.EXT_VALOR_GLOSA,
       EXT.EXT_VALOR_RECEB

UNION ALL

SELECT OSM.OSM_SERIE,
       OSM.OSM_NUM,
       OSM.OSM_DTHR,
       PAC.PAC_NOME,
       'CONTRASTE' AS MAT,
       PSV.PSV_CRM,
       PSV.PSV_APEL,
       SUM(SMM.SMM_VLR) AS VLR,
       EXT.EXT_VALOR_GLOSA,
       EXT.EXT_VALOR_RECEB,
       CASE 
           WHEN STR.STR_NOME = 'TOMOGRAFIA' THEN 'CONTRASTE TC'
       ELSE STR.STR_NOME END
FROM SMM 
     INNER JOIN OSM ON (OSM.OSM_SERIE = SMM.SMM_OSM_SERIE) AND (OSM.OSM_NUM = SMM.SMM_OSM)
     INNER JOIN PAC ON (PAC.PAC_REG = OSM.OSM_PAC)
     INNER JOIN SMK ON (SMK.SMK_COD = SMM.SMM_COD) AND (SMK.SMK_TIPO = SMM.SMM_TPCOD)
     INNER JOIN STR ON (SMM.SMM_STR = STR.STR_COD)
     INNER JOIN PSV ON (SMM.SMM_MED = PSV.PSV_COD)
     INNER JOIN CNV ON (CNV.CNV_COD = OSM.OSM_CNV)
     LEFT JOIN EXT ON (EXT.EXT_OSM_SERIE = OSM.OSM_SERIE) AND (EXT.EXT_OSM_NUM = OSM.OSM_NUM) AND (EXT.EXT_SMM_NUM = SMM.SMM_NUM)

WHERE SMM.SMM_DTHR_LANC >  '2024-07-01 00:00:00' AND
      SMM.SMM_OSM = 41823 AND 
      SMM.SMM_EXEC <> 'C' AND
      SMK.SMK_TIPO = 'M' AND 
      CNV.CNV_CAIXA_FATURA = 'F'
GROUP BY 
STR.STR_NOME,
OSM.OSM_SERIE,
OSM.OSM_NUM,
OSM.OSM_DTHR,
PAC.PAC_NOME,
PSV.PSV_CRM,
       PSV.PSV_APEL,
EXT.EXT_VALOR_GLOSA,
       EXT.EXT_VALOR_RECEB