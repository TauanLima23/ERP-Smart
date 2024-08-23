WITH rdsl AS
(
	SELECT  codigo
	       ,descricao_produto
	       ,descricao_atividade
	       ,especie
	       ,fornecedor
	       ,dt_digitacao
	       ,doc
	       ,nro_pedido
	       ,qtde
	       ,dt_previsao_entrega
	       ,saldo_almox SALDO
	       ,cda
	       ,cd7
	       ,cd15
	       ,cd30
	       ,cd45
	       ,cd60
	       ,cd90
	       ,cd120
	       ,Round(Decode(cd7,0,0,saldo_almox / cd7),2) DOS
	       ,situacao
	       ,SYSDATE DT_ARQUIVO
	       ,cust_unit
	       ,ordens_totais
	       ,estoque_min
	       ,estoque_max
	       ,politica
	       ,dos_virtual
	       ,saldo_almox
	       ,saldo_farmacia
	       ,saldo_cdis
	       ,saldo_hospital
	FROM
	(
		SELECT  mat_cod CODIGO
		       ,mat_desc_completa DESCRICAO_PRODUTO
		       ,NULL DESCRICAO_ATIVIDADE
		       ,gmm_nome ESPECIE
		       ,vw.fornecedor FORNECEDOR
		       ,vw.data_digitacao DT_DIGITACAO
		       ,vw.doc DOC
		       ,vw.num_pedido NRO_PEDIDO
		       ,vw.qtde QTDE
		       ,vw.data_entrega DT_PREVISAO_ENTREGA
		       ,(
		SELECT  Nvl(SUM(vcm_consumo),0)
		FROM vw_consumo_mat
		WHERE vcm_mat = mat_cod
		AND vcm_dt >= Trunc(SYSDATE - 1)
		AND vcm_dt < Trunc(SYSDATE)) CDA, (
		SELECT  Nvl(Round(SUM(vcm_consumo) / 7,2),0)
		FROM vw_consumo_mat
		WHERE vcm_mat = mat_cod
		AND vcm_dt >= Trunc(SYSDATE - 7)
		AND vcm_dt < Trunc(SYSDATE)) CD7, (
		SELECT  Nvl(Round(SUM(vcm_consumo) / 15,2),0)
		FROM vw_consumo_mat
		WHERE vcm_mat = mat_cod
		AND vcm_dt >= Trunc(SYSDATE - 15)
		AND vcm_dt < Trunc(SYSDATE)) CD15, (
		SELECT  Nvl(Round(SUM(vcm_consumo) / 30,2),0)
		FROM vw_consumo_mat
		WHERE vcm_mat = mat_cod
		AND vcm_dt >= Trunc(SYSDATE - 30)
		AND vcm_dt < Trunc(SYSDATE)) CD30, (
		SELECT  Nvl(Round(SUM(vcm_consumo) / 45,2),0)
		FROM vw_consumo_mat
		WHERE vcm_mat = mat_cod
		AND vcm_dt >= Trunc(SYSDATE - 45)
		AND vcm_dt < Trunc(SYSDATE)) CD45, (
		SELECT  Nvl(Round(SUM(vcm_consumo) / 60,2),0)
		FROM vw_consumo_mat
		WHERE vcm_mat = mat_cod
		AND vcm_dt >= Trunc(SYSDATE - 60)
		AND vcm_dt < Trunc(SYSDATE)) CD60, (
		SELECT  Nvl(Round(SUM(vcm_consumo) / 90,2),0)
		FROM vw_consumo_mat
		WHERE vcm_mat = mat_cod
		AND vcm_dt >= Trunc(SYSDATE - 90)
		AND vcm_dt < Trunc(SYSDATE)) CD90, (
		SELECT  Nvl(Round(SUM(vcm_consumo) / 120,2),0)
		FROM vw_consumo_mat
		WHERE vcm_mat = mat_cod
		AND vcm_dt >= Trunc(SYSDATE - 120)
		AND vcm_dt < Trunc(SYSDATE)) CD120, CASE WHEN vw.mat IS NOT NULL AND vw.dt_autorizacao IS NULL THEN 'Não autorizado' WHEN vw.mat IS NOT NULL AND vw.dt_autorizacao IS NOT NULL THEN 'Autorizado' END SITUACAO , mat_vlr_pm CUST_UNIT, (
		SELECT  Nvl(SUM(ORDENS.QTD),0)
		FROM
		(
			SELECT  Nvl(SUM(fic_qtde_pendente),0) AS QTD
			       ,FIC_MAT_COD                   AS MATU
			FROM fic, ICP, aft, fne, ine, nfe
			WHERE fic_aft_serie = aft_serie
			AND fic_aft_num = aft_num
			AND fic_qtde_pendente > 0
			AND fic_mat_cod <> 0
			AND aft_fne_cod = fne_cod (+)
			AND fic_fne_cod = ine_fne_cod (+)
			AND fic_cop_serie = ine_cop_serie (+)
			AND fic_cop_num = ine_cop_num (+)
			AND fic_icp_seq = ine_icp_seq (+)
			AND ine_nfe_serie = nfe_serie (+)
			AND ine_nfe_num = nfe_num (+)
			AND ine_fne_cod = nfe_fne_cod (+)
			AND ICP_COP_SERIE = FIC_COP_SERIE(+)
			AND ICP_COP_NUM = FIC_COP_NUM(+)
			AND ICP_SEQ = fic_icp_seq(+)
			AND ICP_STATUS NOT IN ('C', 'S')
			AND (aft_DTHR + fic_prazo_entrega) >= :DATA_CORTE
			GROUP BY  FIC_MAT_COD
			UNION
			SELECT  Nvl(SUM(ism_qtde_solicitada),0) AS QTD
			       ,ISM_MAT_COD                     AS MATU
			FROM sma, ism, mat, cop, FIC, AFT
			WHERE sma_serie = ism_sma_serie
			AND sma_num = ism_sma_num
			AND ism_mat_cod = mat_cod
			AND COP_SERIE(+) = ISM_COP_SERIE
			AND COP_NUM(+) = ISM_COP_NUM
			AND FIC_MAT_COD = MAT_COD
			AND FIC_COP_SERIE(+) = COP_SERIE
			AND FIC_COP_NUM(+) = COP_NUM
			AND AFT_SERIE(+) = FIC_AFT_SERIE
			AND AFT_NUM(+) = FIC_AFT_NUM
			AND ism_qtde_compra < ism_qtde_solicitada
			AND sma_tipo = 'SR'
			AND (FIC_COP_NUM IS NULL OR FIC_QTDE_PENDENTE > 0 AND FIC_AFT_NUM IS NULL OR FIC_DEL_LOGICA = 'S' )
			AND ism_mat_cod <> 0
			AND ism_status = 'A'
			AND sma_data >= :DATA_CORTE
			AND (FIC_DEL_LOGICA = 'S' OR FIC_AFT_NUM IS NULL)
			GROUP BY  ISM_MAT_COD
		) ORDENS
		WHERE ORDENS.MATU = mat_cod) ORDENS_TOTAIS, NULL ESTOQUE_MIN, NULL ESTOQUE_MAX, NULL POLITICA , NULL DOS_VIRTUAL, (
		SELECT  Nvl(SUM(etq_quantidade),0)
		FROM etq
		WHERE etq_mat_cod = mat_cod
		AND etq_sba_cod IN ('CEN', 'FAR', 'ALM-MA', 'MANUT', 'OPME')) SALDO_ALMOX, (
		SELECT  Nvl(SUM(etq_quantidade),0)
		FROM etq, sba
		WHERE etq_mat_cod = mat_cod
		AND etq_sba_cod = sba_cod
		AND ( sba_nome LIKE 'FAR%' OR sba_nome LIKE 'DIS%' )) SALDO_FARMACIA, 0 SALDO_CDIS, (
		SELECT  Nvl(SUM(etq_quantidade),0)
		FROM etq
		WHERE etq_mat_cod = mat_cod) SALDO_HOSPITAL
		FROM mat, lma, gmm,
		(
			SELECT  *
			FROM
			(
				SELECT  vw.*
				FROM
				(
					SELECT  fic_mat_cod mat
					       ,fne_nome_fantasia fornecedor
					       ,aft_dthr data_digitacao
					       ,'OC' doc
					       ,aft_serie ||'.' ||aft_num num_pedido
					       ,fic_qtde_pendente qtde
					       ,Nvl((
					SELECT  MIN(peg_dthr)
					FROM peg, ism
					WHERE peg_sma_serie = ism_sma_serie
					AND peg_sma_num = ism_sma_num
					AND peg_ism_seq = ism_seq
					AND ism_cop_serie = fic_cop_serie
					AND ism_cop_num = fic_cop_num
					AND ism_icp_seq = fic_icp_seq ), CASE WHEN aft_dt_prev_entrega is null THEN (aft_DTHR + fic_prazo_entrega) else aft_dt_prev_entrega end) data_entrega, aft_dthr_aut dt_autorizacao
					FROM fic, ICP, aft, fne, ine, nfe
					WHERE fic_aft_serie = aft_serie
					AND fic_aft_num = aft_num
					AND fic_qtde_pendente > 0
					AND fic_mat_cod <> 0
					AND aft_fne_cod = fne_cod (+)
					AND fic_fne_cod = ine_fne_cod (+)
					AND fic_cop_serie = ine_cop_serie (+)
					AND fic_cop_num = ine_cop_num (+)
					AND fic_icp_seq = ine_icp_seq (+)
					AND ine_nfe_serie = nfe_serie (+)
					AND ine_nfe_num = nfe_num (+)
					AND ine_fne_cod = nfe_fne_cod (+)
					AND ICP_COP_SERIE = FIC_COP_SERIE(+)
					AND ICP_COP_NUM = FIC_COP_NUM(+)
					AND ICP_SEQ = fic_icp_seq(+)
					AND ICP_STATUS NOT IN ('C', 'S')
					AND (aft_DTHR + fic_prazo_entrega) >= :DATA_CORTE
					UNION
					SELECT  ism_mat_cod mat
					       ,NULL fornecedor
					       ,sma_data data_digitacao
					       ,'SC' doc
					       ,sma_serie ||'.' ||sma_num num_pedido
					       ,ism_qtde_solicitada qtde
					       ,NULL data_entrega
					       ,sma_dthr_aut dt_autorizaca
					FROM sma, ism, mat, cop, FIC, AFT, ICP
					WHERE sma_serie = ism_sma_serie
					AND sma_num = ism_sma_num
					AND ism_mat_cod = mat_cod
					AND COP_SERIE(+) = ISM_COP_SERIE
					AND COP_NUM(+) = ISM_COP_NUM
					AND FIC_COP_SERIE = ICP_COP_SERIE(+)
					AND FIC_COP_NUM = ICP_COP_NUM(+)
					AND FIC_MAT_COD = ICP_MAT_COD(+)
					AND FIC_ICP_SEQ = ICP_SEQ(+)
					AND FIC_QTD_REG_COMPRA > 0
					AND FIC_MAT_COD = MAT_COD
					AND FIC_COP_SERIE(+) = COP_SERIE
					AND FIC_COP_NUM(+) = COP_NUM
					AND AFT_SERIE(+) = FIC_AFT_SERIE
					AND AFT_NUM(+) = FIC_AFT_NUM
					AND (ism_qtde_compra < ism_qtde_solicitada )
					AND (FIC_COP_NUM IS NULL OR ICP_STATUS NOT IN ('C', 'S') AND FIC_QTDE_PENDENTE > 0 AND FIC_AFT_NUM IS NULL OR FIC_DEL_LOGICA = 'S' )
					AND sma_tipo = 'SR'
					AND ism_mat_cod <> 0
					AND ism_status = 'A'
					AND sma_data >= :DATA_CORTE 
				) vw
			)
		) vw
		WHERE mat_gmm_cod = gmm_cod
		AND mat_gmm_cod = lma_gmm_cod
		AND mat_lma_cod = lma_cod
		AND mat_cod = vw.mat (+)
		AND mat_cod <> 0
	)
)
SELECT  CODIGO
       ,DESCRICAO_PRODUTO
       ,DESCRICAO_ATIVIDADE
       ,ESPECIE
       ,FORNECEDOR
       ,to_char(DT_DIGITACAO,'dd/mm/yyyy') DT_DIGITACAO
       ,DOC
       ,NRO_PEDIDO
       ,QTDE
       ,to_char(DT_PREVISAO_ENTREGA,'dd/mm/yyyy') DT_PREVISAO_ENTREGA
       ,SALDO
       ,CDA
       ,CD7
       ,CD15
       ,CD30
       ,CD45
       ,CD60
       ,CD90
       ,CD120
       ,DOS
       ,SITUACAO
       ,DT_ARQUIVO
       ,CUST_UNIT
       ,ORDENS_TOTAIS
       ,ESTOQUE_MIN
       ,ESTOQUE_MAX
       ,POLITICA
       ,DOS_VIRTUAL
       ,SALDO_ALMOX
       ,SALDO_FARMACIA
       ,SALDO_CDIS
       ,SALDO_HOSPITAL
FROM rdsl
WHERE (CODIGO LIKE :Mat or :Mat is null)