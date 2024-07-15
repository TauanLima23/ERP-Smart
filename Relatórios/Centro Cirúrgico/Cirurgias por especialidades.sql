/*
Relatório de Acompanhamento de Cirurgia por Especialidade

O relatório de acompanhamento de cirurgia por especialidade fornece uma visão abrangente das cirurgias realizadas, detalhando informações cruciais para a gestão hospitalar. Ele inclui os seguintes dados:

Paciente: Nome do paciente submetido à cirurgia.
Idade: Idade do paciente no momento da cirurgia.
Sexo: Gênero do paciente.
Cirurgia: Tipo de cirurgia realizada.
Porte: Classificação do porte da cirurgia (pequeno, médio, grande).
Especialidade: Área médica responsável pela cirurgia (ortopedia, cardiologia, etc.).
Cirurgião: Nome do médico responsável pela realização da cirurgia.
Convênio: Plano de saúde ou convênio responsável pelo paciente.
Classificação: Natureza da cirurgia, indicando se foi Urgente ou Eletiva.
Data de Início e Fim: Período de realização da cirurgia, indicando a data e hora de início e término.
Este relatório é essencial para monitorar e analisar o desempenho cirúrgico por especialidade, auxiliando na avaliação da eficiência e qualidade dos procedimentos realizados. Ele permite uma visão detalhada de diversos aspectos das cirurgias, facilitando a identificação de tendências, necessidades de melhorias e alocação de recursos.

Além disso, o relatório ajuda na gestão de convênios e na compreensão do perfil dos pacientes atendidos, fornecendo dados valiosos para a tomada de decisões estratégicas no ambiente hospitalar.
*/

SELECT DISTINCT
       PAC.PAC_NOME AS PACIENTE,
       TRUNC(MONTHS_BETWEEN(SYSDATE, PAC.PAC_NASC) / 12) AS IDADE,
       CASE WHEN PAC.PAC_SEXO = 'M' THEN 'MASCULINO' ELSE 'FEMININO' END AS SEXO,
       SMK.SMK_NOME CICURGIA,
       CASE WHEN RCI.RCI_PORTE IS NULL THEN 0 ELSE RCI.RCI_PORTE END AS PORTE,
       ESP.ESP_NOME AS ESPECIALIDADE,
       PSV.PSV_APEL CIRURGIÃO,
       CNV.CNV_NOME CONVÊNIO,
       CASE WHEN RCI.RCI_IND_URG = 'S' THEN 'URGENTE' ELSE 'ELETIVO' END AS CLASSIFICAÇÃO,
       RCI.RCI_DTHR_INI AS INICIO,
       RCI.RCI_DTHR_FIM AS FIM
FROM RCI
     INNER JOIN PAC ON (PAC.PAC_REG = RCI.RCI_PAC_REG)
     INNER JOIN HSP ON (HSP.HSP_NUM = RCI.RCI_HSP_NUM) AND (HSP.HSP_PAC = PAC.PAC_REG)
     INNER JOIN SMK ON (SMK.SMK_COD = RCI.RCI_SMK_COD) AND (SMK.SMK_TIPO = RCI.RCI_SMK_TIPO)
     INNER JOIN PSV ON (PSV.PSV_COD = RCI.RCI_PSV_COD)
     INNER JOIN CNV ON (CNV.CNV_COD = RCI.RCI_CNV_COD)
     LEFT JOIN ESP ON (ESP.ESP_COD = SMK.SMK_ESP_COD)
WHERE RCI.RCI_PORTE IS NOT NULL
ORDER BY  RCI.RCI_DTHR_INI ASC