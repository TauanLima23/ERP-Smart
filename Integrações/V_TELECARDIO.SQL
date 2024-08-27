CREATE VIEW V_TELECARDIO AS
SELECT	RCL.RCL_PAC, 
		PAC.PAC_NOME, 
		PAC.PAC_SEXO, 
		PAC.PAC_NASC, 
		CONCAT(SMM.SMM_OSM_SERIE,'.',SMM.SMM_OSM,'-' ,SMM.SMM_NUM) AS ACC,
                'CPF' AS NM_DOCUMENTO,
                PAC.PAC_NUMCPF AS NU_DOC,
                PAC.PAC_PESO AS NU_PESO,
                PAC.PAC_ALT AS NU_ALTURA,
                SMK.SMK_IND_DICOM AS CD_MODALIDADE,
                SMK.SMK_ROT AS NM_EXAME,
                CNV.CNV_COD AS CD_MDT_EMPRESA_SOLICITANTE,
                CNV.CNV_NOME AS NM_MDT_EMPRESA_SOLICITANTE,
                PAC.PAC_REG AS CD_MDT_REG_FUNC,
                CASE 
                    WHEN OSM.OSM_ATEND = 'ASS' THEN 'Assistencial'
                    WHEN OSM.OSM_ATEND = 'ADM' THEN 'Admissional'
                    WHEN OSM.OSM_ATEND = 'CRG' THEN 'Cirurgia'
                    WHEN OSM.OSM_ATEND = 'DEM' THEN 'Demissional'
                    WHEN OSM.OSM_ATEND = 'EME' THEN 'Emergência'
                    WHEN OSM.OSM_ATEND = 'INT' THEN 'Internamento'
                    WHEN OSM.OSM_ATEND = 'PER' THEN 'Periódico'
                    WHEN OSM.OSM_ATEND = 'TAM' THEN 'Trat. Ambulat'
                    WHEN OSM.OSM_ATEND = 'RTB' THEN 'Retorno ao Trabalho'
                    WHEN OSM.OSM_ATEND = 'ACT' THEN 'Acidente Trabalho'
                    WHEN OSM.OSM_ATEND = 'MDF' THEN 'Mudança de Função/Área'
                    WHEN OSM.OSM_ATEND = 'APC' THEN 'APAC'
                    WHEN OSM.OSM_ATEND = 'S' THEN 'Supletivo'
                    ELSE 'Tipo Desconhecido'
                END AS DE_MDT_MOTIVO_EXAME
                
FROM	RCL
                INNER JOIN PAC ON (RCL.RCL_PAC = PAC.PAC_REG)
                INNER JOIN OSM ON (RCL.RCL_OSM_SERIE = OSM.OSM_SERIE) AND (RCL.RCL_OSM = OSM.OSM_NUM) 
				INNER JOIN SMM ON (RCL.RCL_OSM_SERIE = SMM.SMM_OSM_SERIE) AND (RCL.RCL_OSM = SMM.SMM_OSM) AND (RCL.RCL_SMM = SMM.SMM_NUM)
                INNER JOIN SMK ON (RCL.RCL_COD = SMK.SMK_COD) AND (RCL.RCL_TPCOD = SMK.SMK_TIPO)
                INNER JOIN CNV ON (OSM.OSM_CNV = CNV.CNV_COD)

WHERE SMK.SMK_IND_DICOM IS NOT NULL
GO