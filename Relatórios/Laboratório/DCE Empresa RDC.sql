SELECT ctl.ctl_pac,   
         ctl.ctl_hsp,   
         ctl.ctl_dthr,   
         ctl.ctl_temp,   
         ctl.ctl_pr,   
         ctl.ctl_tas,   
         ctl.ctl_tad,   
         ctl.ctl_pam,   
         ctl.ctl_resp,   
         ctl.ctl_pvc,   
         ctl.ctl_pcp,   
         ctl.ctl_dc,   
         ctl.ctl_glic,   
         ctl.ctl_glm,   
         ctl.ctl_pic,   
         cfg.cfg_emp,   
         pac.pac_reg,   
         pac.pac_pront,   
         pac.pac_nome,   
         pac.pac_sexo,   
         pac.pac_nasc,   
         hsp.hsp_num,   
         hsp.hsp_dthre,   
         loc.loc_nome,   
         str.str_nome,   
         ctl.ctl_sato2,   
         hsp.hsp_loc,   
         ( SELECT b.str_nome FROM str b, loc c WHERE c.loc_cod = hsp.hsp_loc AND c.loc_str = b.str_cod ),   
         hsp.hsp_trat_int,   
         ctl.ctl_fc,   
         ctl.ctl_rc,   
         ctl.ctl_dor,   
         ctl.ctl_peso,   
         ctl.ctl_decubito,   
         ctl.ctl_nivel_consciencia,
			psv.psv_conselho,   
         psv.psv_crm,   
         psv.psv_uf,   
         psv.psv_nome , psv.psv_apel, pac_cnv, pac.pac_nome_social,
		 	pac.pac_flag_social,
			pdc.pdc_cor,
			pdc.pdc_religiao,
			pdc.pdc_resp_legal_nome,
			pac.pac_end,
			pac.pac_end_num,
			pac.pac_cep,	
			pac.pac_cartao_sus,
			pac.pac_uf,
			pac.pac_nome_mae,
			pac.pac_nasc,
			COALESCE(CDE.CDE_NOME, PAC.PAC_CID, CDE.CDE_NOME),
			pac.pac_cartao_sus,
			hsp.hsp_stat,
			hsp.hsp_dthra,
			hsp.hsp_dt_prev_alta
			
    FROM (((( ctl LEFT OUTER JOIN hsp ON ( hsp.hsp_pac = ctl.ctl_pac and hsp.hsp_num = ctl.ctl_hsp )
				   LEFT OUTER JOIN loc ON ( loc.loc_cod = hsp.hsp_loc ) 
				   LEFT OUTER JOIN str ON ( str.str_cod = hsp.hsp_str_cod )
					LEFT OUTER JOIN usr ON ( ctl.ctl_usr_login = usr.usr_login ) 
					LEFT OUTER JOIN psv ON ( usr.usr_psv = psv.psv_cod )         
					INNER JOIN pac ON ( pac.pac_reg = ctl.ctl_pac ) ))))  
          lEFT JOIN CDE ON (CONVERT(VARCHAR,CDE.CDE_COD)=PAC.PAC_CID), pdc, CFG
   WHERE ( ctl.ctl_pac = :NPac ) AND  
         ( ctl.ctl_hsp = :NHsp ) AND  
         ( ctl.ctl_dthr >= :dtIni ) AND  
         ( ctl.ctl_dthr <= :dtFim ) AND  
         ( ctl.ctl_del_logica is null OR ctl.ctl_del_logica = 'N' ) AND
			( pdc_pac_reg = hsp.hsp_pac )
            
ORDER BY ctl.ctl_dthr ASC