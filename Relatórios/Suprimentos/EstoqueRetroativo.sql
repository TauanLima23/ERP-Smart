SELECT
    MAT.MAT_COD,
    MAT.MAT_DESC_RESUMIDA,
    CAST(MMA.MMA_DATA_MOV AS DATE),
    SUM(MMA.mma_qtd * MMA.mma_tipo_es_fator * -1)
FROM
    MMA
    INNER JOIN MAT ON (MAT.MAT_COD = MMA.MMA_MAT_COD)
WHERE
    MMA.MMA_DATA_MOV >= '2023-06-01 23:59:59'
GROUP BY
    MAT.MAT_COD,
    MAT.MAT_DESC_RESUMIDA,
    CAST(MMA.MMA_DATA_MOV AS DATE)
ORDER BY
    MAT.MAT_DESC_RESUMIDA ASC,
    CAST(MMA.MMA_DATA_MOV AS DATE)