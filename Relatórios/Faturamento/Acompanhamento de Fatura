/*
Resumo do Relatório de Posição de Faturamento

O relatório de posição de faturamento oferece uma visão abrangente dos valores produzidos, faturados e pendentes de faturamento dentro do período especificado. Ele detalha:

Valor Produzido: Total de serviços e procedimentos realizados no período.
Valor Faturado: Total de serviços e procedimentos já faturados no período.
Valor Pendente Faturamento: Total de serviços e procedimentos que ainda não foram faturados dentro do período.
Além disso, o relatório inclui uma coluna de Sugestão de Envio, que indica a próxima data disponível, conforme o contrato do convênio, para o envio do XML de faturamento. Esta funcionalidade é essencial para garantir que o faturamento seja realizado de acordo com os prazos estipulados nos contratos, evitando atrasos e possíveis penalidades.

Este relatório é uma ferramenta crucial para a gestão financeira do hospital, permitindo um acompanhamento preciso do fluxo de caixa e facilitando a tomada de decisões estratégicas.
*/

WITH Periodos AS (
    SELECT 
        CFT.CFT_DT_ENVIO,
        CFT.CFT_DT_ENVIO_FIM,
        CFT.CFT_CNV_COD
    FROM 
        CFT
    WHERE 
        (GETDATE() BETWEEN CFT.CFT_DT_ENVIO AND CFT.CFT_DT_ENVIO_FIM)
        OR GETDATE() < CFT.CFT_DT_ENVIO
),
    ProximoPeriodo AS (
    SELECT TOP 1
        CASE
            WHEN GETDATE() BETWEEN CFT_DT_ENVIO AND CFT_DT_ENVIO_FIM THEN GETDATE()
            WHEN GETDATE() < CFT_DT_ENVIO THEN CFT_DT_ENVIO
            ELSE CFT_DT_ENVIO_FIM
        END AS PROXIMO_DIA_DISPONIVEL, CFT_CNV_COD
    FROM 
        Periodos
    ORDER BY
        CASE 
            WHEN GETDATE() < CFT_DT_ENVIO THEN CFT_DT_ENVIO
            ELSE CFT_DT_ENVIO_FIM
        END
)

SELECT  CNV.CNV_COD COD_CONVENIO,
        CNV.CNV_NOME NOME_CONVENIO,
        SUM(SMM.SMM_VLR) PRODUZIDO,
        (SELECT SUM(B.SMM_VLR) 
            FROM OSM O 
                    INNER JOIN SMM B ON (B.SMM_OSM_SERIE = O.OSM_SERIE AND B.SMM_OSM = O.OSM_NUM) 
                    INNER JOIN FAT ON (B.SMM_FAT = FAT.FAT_NUM) AND (B.SMM_FAT_SERIE = FAT.FAT_SERIE) 
                    INNER JOIN NFS ON (FAT.FAT_NFS_SERIE = NFS.NFS_SERIE) AND (FAT.FAT_NFS_NUMERO = NFS.NFS_NUMERO) AND (FAT.FAT_NFS_TIPO = NFS.NFS_TIPO) 
            WHERE O.OSM_CNV = CNV.CNV_COD AND O.OSM_DTHR >= :DATA_INICIO AND O.OSM_DTHR <= :DATA_FIM 
                AND B.SMM_TIPO_FATURA = 'E' AND B.SMM_EXEC <> 'C' AND B.SMM_SFAT <> 'C' AND B.SMM_PACOTE IN (NULL, 'P')) AS FATURADO,
        (SELECT SUM(B.SMM_VLR) 
            FROM OSM O 
                    INNER JOIN SMM B ON (B.SMM_OSM_SERIE = O.OSM_SERIE AND B.SMM_OSM = O.OSM_NUM) 
                    LEFT JOIN FAT ON (B.SMM_FAT = FAT.FAT_NUM) AND (B.SMM_FAT_SERIE = FAT.FAT_SERIE) 
                    LEFT JOIN NFS ON (FAT.FAT_NFS_SERIE = NFS.NFS_SERIE) AND (FAT.FAT_NFS_NUMERO = NFS.NFS_NUMERO) AND (FAT.FAT_NFS_TIPO = NFS.NFS_TIPO) 
            WHERE O.OSM_CNV = CNV.CNV_COD AND O.OSM_DTHR >= :DATA_INICIO AND O.OSM_DTHR <= :DATA_FIM 
                  AND B.SMM_TIPO_FATURA = 'E' AND B.SMM_EXEC <> 'C' AND B.SMM_SFAT <> 'C' AND B.SMM_PACOTE IN (NULL, 'P') AND NFS.NFS_NUMERO IS NULL) AS PENDENTE,
        CONVERT(varchar, P.PROXIMO_DIA_DISPONIVEL, 103) 'SUGESTÃO DE ENVIO'

FROM OSM
    INNER JOIN CNV ON (OSM.OSM_CNV = CNV.CNV_COD)
    INNER JOIN SMM ON (OSM.OSM_SERIE = SMM.SMM_OSM_SERIE) AND (OSM.OSM_NUM = SMM.SMM_OSM)
    LEFT JOIN ProximoPeriodo P ON (CNV.CNV_COD = P.CFT_CNV_COD)
WHERE 
    OSM.OSM_DTHR >= :DATA_INICIO AND --Filtro de data para trazer apenas um recorte
    OSM.OSM_DTHR <= :DATA_FIM AND
    SMM.SMM_TIPO_FATURA = 'E' AND
    SMM.SMM_EXEC <> 'C' AND
    SMM.SMM_SFAT <> 'C' AND 
    SMM.SMM_PACOTE IN (NULL, 'P') 
GROUP BY 
    CNV.CNV_COD, 
    CNV.CNV_NOME, 
    P.PROXIMO_DIA_DISPONIVEL
ORDER BY 
    CNV.CNV_NOME ASC
