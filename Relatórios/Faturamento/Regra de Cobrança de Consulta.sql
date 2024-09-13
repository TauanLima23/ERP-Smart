WITH Semanas AS (
    SELECT CFG.CFG_EMP,
        PAC.PAC_REG,
        PAC.PAC_NOME,
        OSM.OSM_SERIE,
        OSM.OSM_NUM,
        OSM.OSM_DTHR,
        SMK.SMK_NOME,
        SMM.SMM_VLR,
        TO_CHAR(OSM.OSM_DTHR, 'MM/YYYY') AS Mes,
        TRUNC(OSM.OSM_DTHR, 'IW') AS Inicio_Semana,
        TRUNC(OSM.OSM_DTHR, 'IW') + 5 AS Fim_Semana,
        ROW_NUMBER() OVER (PARTITION BY PAC.PAC_NOME, TRUNC(OSM.OSM_DTHR, 'IW') ORDER BY OSM.OSM_DTHR) AS Contagem_Semanal,
        CNV.CNV_COD,
        CNV.CNV_NOME,
        EMP.EMP_COD,
        EMP.EMP_NOME_FANTASIA,
		  SMM.SMM_SFAT
   	  

    FROM CFG, OSM
    INNER JOIN SMM ON (SMM.SMM_OSM_SERIE = OSM.OSM_SERIE) AND (SMM.SMM_OSM = OSM.OSM_NUM)
    INNER JOIN SMK ON (SMK.SMK_COD = SMM.SMM_COD) AND (SMK.SMK_TIPO = SMM.SMM_TPCOD)
    INNER JOIN PAC ON (PAC.PAC_REG = OSM.OSM_PAC)
    INNER JOIN CNV ON (CNV.CNV_COD = OSM.OSM_CNV)
    INNER JOIN EMP ON (EMP.EMP_COD = CNV.CNV_EMP_COD)
    WHERE
        SMK.SMK_CTF = '1001' AND
        SMM.SMM_EXEC <> 'C' AND
        SMM.SMM_VLR > 0 AND 
        OSM.OSM_DTHR BETWEEN :DATA_INICIO AND :DATA_FIM AND 
        (OSM.OSM_CNV IN (:CONVENIO) OR (OSM.OSM_CNV IS NULL))
)
SELECT CFG_EMP AS EMPRESA,
    PAC_REG AS REGISTRO,
    PAC_NOME AS NOME,
    OSM_SERIE AS OS_SERIE,
    OSM_NUM AS OS_NUMERO,
    OSM_DTHR AS DATA,
    SMK_NOME AS SERVIÇO,
    SMM_VLR AS VALOR,
    Mes AS Mes_Ref,
    CASE
        WHEN Contagem_Semanal > 2 THEN 'Não Faturar'
        ELSE 'Faturar'
    END AS Faturamento,
    Inicio_Semana AS Data_Inicio_Semana,
    Fim_Semana AS Data_Fim_Semana,
    Contagem_Semanal,
    CNV_COD AS CONVENIO_COD,
    CNV_NOME AS CONVENIO_NOME,
    EMP_COD AS CONVENIO_EMPRESA_COD,
    EMP_NOME_FANTASIA AS CONVENIO_EMPRESA_NOME,
    CASE 
        WHEN smm_sfat = 'A' THEN 'Aberto'
        WHEN smm_sfat = 'P' THEN 'Pendente'
        WHEN smm_sfat = 'F' THEN 'Faturado'
        WHEN smm_sfat = 'C' THEN 'Cancelado'
        ELSE 'Outro'
    END AS Status_Faturamento 
   	  
    
FROM Semanas
ORDER BY CNV_NOME, Mes_ref, Inicio_Semana, PAC_NOME, OSM_DTHR