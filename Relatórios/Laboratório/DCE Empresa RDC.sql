SELECT 
    CASE 
        WHEN SMK.SMK_TERC = 'S' THEN EMP.EMP_NOME_FANTASIA 
        ELSE CFG.CFG_EMP 
    END 
FROM 
    RCL 
    CROSS JOIN CFG
    INNER JOIN SMK ON SMK.SMK_COD = RCL.RCL_COD 
    LEFT JOIN EMP ON SMK.SMK_TERC_EMP_COD = EMP.EMP_COD 
    LEFT JOIN PSV ON PSV.PSV_COD = EMP.EMP_RESP_TECNICO 
WHERE  
    RCL.RCL_PAC = :paciente 
    AND RCL.RCL_DTHR = :dtrcl 
    AND RCL.RCL_COD = :serviço