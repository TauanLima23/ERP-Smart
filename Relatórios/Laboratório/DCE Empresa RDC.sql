SELECT
    CASE
        WHEN EMP.EMP_NOME_FANTASIA IS NOT NULL THEN '| Realizado por: ' + EMP.emp_nome_fantasia
        ELSE ''
    end
FROM
    RCL
    INNER JOIN SMK ON (SMK.SMK_COD = RCL.RCL_COD)
    LEFT JOIN EMP ON (RCL.RCL_APARELHO = EMP.EMP_B2B_ELB_COD)
    LEFT JOIN PSV ON (PSV.PSV_COD = EMP.EMP_RESP_TECNICO)
WHERE
    rcl_pac = :paciente
    and rcl_dthr = :dtrcl
    and rcl_cod = :servico