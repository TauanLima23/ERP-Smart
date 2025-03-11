CREATE
OR REPLACE FORCE VIEW "SMART"."V_ORPAG_OPER" (
    "V_CODIGO",
    "V_OSM_SERIE",
    "V_OSM_NUM",
    "V_TIPO_GUIA"
) AS
select
    max (a.orpag_bm_cod_oper) as v_codigo,
    osm.osm_serie as v_osm_serie,
    osm_num as v_osm_num,
    a.orpag_bm_tiss_guia as v_tipo_guia
from
    osm,
    smm,
    smk,
    orpag_bradesco_mq a
where
    osm.osm_serie = smm.smm_osm_serie
    and osm.osm_num = smm.smm_osm
    and smm.smm_tpcod = smk.smk_tipo
    and smm.smm_cod = smk.smk_cod
    and osm.osm_cnv = a.orpag_bm_cnv_cod
    and osm.osm_str = a.orpag_bm_str_solic
    and smk.smk_tipo = a.orpag_bm_ctf_tipo
    anD (
        a.orpag_bm_CTF_cod IN (
            (
                SELECT
                    sk.SMK_CTF
                FROM
                    SMM sm,
                    OSM os,
                    SMK sk
                WHERE
                    sm.SMM_COD = sk.SMK_COD
                    AND sm.SMM_TPCOD = sk.SMK_TIPO
                    AND sm.SMM_OSM_SERIE = os.OSM_SERIE
                    AND sm.SMM_OSM = os.OSM_NUM
                    AND os.osm_serie = osm.osm_serie
                    and os.osm_num = osm.osm_num
                    and sm.SMM_SFAT <> 'C'
                    AND os.OSM_STR = a.orpag_bm_str_solic
                    AND sk.SMK_CTF = a.orpag_bm_CTF_cod
                    AND os.OSM_CNV = a.orpag_bm_cnv_cod
                    AND EXISTS (
                        SELECT
                            1
                        FROM
                            orpag_bradesco_mq MQ
                        WHERE
                            os.OSM_STR = MQ.orpag_bm_str_solic
                            AND sk.SMK_CTF = MQ.orpag_bm_CTF_cod
                            AND os.OSM_CNV = MQ.orpag_bm_cnv_cod
                            AND MQ.orpag_bm_smk_cod = sm.SMM_COD
                    )
            )
        )
        OR a.orpag_bm_CTF_cod IN (
            (
                SELECT
                    SMK_CTF
                FROM
                    SMM sm,
                    OSM os,
                    SMK sk
                WHERE
                    SMM_COD = SMK_COD
                    AND sm.SMM_TPCOD = sk.SMK_TIPO
                    AND sm.SMM_OSM_SERIE = os.OSM_SERIE
                    AND sm.SMM_OSM = os.OSM_NUM
                    AND os.osm_serie = osm.osm_serie
                    and os.osm_num = osm.osm_num
                    and sm.SMM_SFAT <> 'C'
                    AND os.OSM_STR = a.orpag_bm_str_solic
                    AND sk.SMK_CTF = a.orpag_bm_CTF_cod
                    AND os.OSM_CNV = a.orpag_bm_cnv_cod
                    AND NOT EXISTS (
                        SELECT
                            1
                        FROM
                            orpag_bradesco_mq MQ
                        WHERE
                            os.OSM_STR = MQ.orpag_bm_str_solic
                            AND sk.SMK_CTF = MQ.orpag_bm_CTF_cod
                            AND os.OSM_CNV = MQ.orpag_bm_cnv_cod
                            AND MQ.orpag_bm_smk_cod = sm.SMM_COD
                    )
            )
        )
    )
    AND (
        a.orpag_bm_smk_cod = (
            SELECT
                sm.SMM_COD
            FROM
                SMM sm,
                OSM os,
                SMK sk
            WHERE
                sm.SMM_COD = sk.SMK_COD
                AND sm.SMM_TPCOD = sk.SMK_TIPO
                AND sm.SMM_OSM_SERIE = os.OSM_SERIE
                AND sm.SMM_OSM = os.OSM_NUM
                AND os.osm_serie = osm.osm_serie
                and os.osm_num = osm.osm_num
                and sm.SMM_SFAT <> 'C'
                AND os.OSM_STR = a.orpag_bm_str_solic
                AND sk.SMK_CTF = a.orpag_bm_CTF_cod
                AND os.OSM_CNV = a.orpag_bm_cnv_cod
                AND EXISTS (
                    SELECT
                        1
                    FROM
                        orpag_bradesco_mq MQ
                    WHERE
                        os.OSM_STR = MQ.orpag_bm_str_solic
                        AND sk.SMK_CTF = MQ.orpag_bm_CTF_cod
                        AND os.OSM_CNV = MQ.orpag_bm_cnv_cod
                        AND MQ.orpag_bm_smk_cod = sm.SMM_COD
                )
        )
        OR a.orpag_bm_smk_cod = '%'
        AND NOT EXISTS (
            SELECT
                1
            FROM
                orpag_bradesco_mq MQ,
                SMM sm,
                OSM os,
                SMK sk
            WHERE
                os.OSM_STR = MQ.orpag_bm_str_solic
                AND sk.SMK_CTF = MQ.orpag_bm_CTF_cod
                AND os.OSM_CNV = MQ.orpag_bm_cnv_cod
                AND MQ.orpag_bm_smk_cod = sm.SMM_COD
                AND sm.SMM_COD = sk.SMK_COD
                AND sm.SMM_TPCOD = sk.SMK_TIPO
                AND sm.SMM_OSM_SERIE = os.OSM_SERIE
                AND sm.SMM_OSM = os.OSM_NUM
                AND os.osm_serie = osm.osm_serie
                and os.osm_num = osm.osm_num
                and sm.SMM_SFAT <> 'C'
        )
    )
group by
    osm_serie,
    osm_num,
    orpag_bm_tiss_guia;

GRANT
SELECT
    ON "SMART"."V_ORPAG_OPER" TO "RL_VIEWS_SMART";

GRANT
SELECT
    ON "SMART"."V_ORPAG_OPER" TO "FALQONQLIK";

GRANT
SELECT
    ON "SMART"."V_ORPAG_OPER" TO "R_CUBO_SMART";

GRANT
SELECT
    ON "SMART"."V_ORPAG_OPER" TO "CUBO";

GRANT
SELECT
    ON "SMART"."V_ORPAG_OPER" TO "PIXEON";

GRANT
SELECT
    ON "SMART"."V_ORPAG_OPER" TO "INGENIUM";

GRANT
SELECT
    ON "SMART"."V_ORPAG_OPER" TO "TREASY";

GRANT
SELECT
    ON "SMART"."V_ORPAG_OPER" TO "INTEGRACAO";

GRANT FLASHBACK ON "SMART"."V_ORPAG_OPER" TO "SMARTCP200";

GRANT DEBUG ON "SMART"."V_ORPAG_OPER" TO "SMARTCP200";

GRANT QUERY REWRITE ON "SMART"."V_ORPAG_OPER" TO "SMARTCP200";

GRANT ON COMMIT REFRESH ON "SMART"."V_ORPAG_OPER" TO "SMARTCP200";

GRANT REFERENCES ON "SMART"."V_ORPAG_OPER" TO "SMARTCP200";

GRANT
UPDATE
    ON "SMART"."V_ORPAG_OPER" TO "SMARTCP200";

GRANT
SELECT
    ON "SMART"."V_ORPAG_OPER" TO "SMARTCP200";

GRANT
INSERT
    ON "SMART"."V_ORPAG_OPER" TO "SMARTCP200";

GRANT DELETE ON "SMART"."V_ORPAG_OPER" TO "SMARTCP200";

GRANT
SELECT
    ON "SMART"."V_ORPAG_OPER" TO "SMARTBI";

GRANT
SELECT
    ON "SMART"."V_ORPAG_OPER" TO "SMARTUSER";

GRANT MERGE VIEW ON "SMART"."V_ORPAG_OPER" TO "SMARTPROD";

GRANT FLASHBACK ON "SMART"."V_ORPAG_OPER" TO "SMARTPROD";

GRANT DEBUG ON "SMART"."V_ORPAG_OPER" TO "SMARTPROD";

GRANT QUERY REWRITE ON "SMART"."V_ORPAG_OPER" TO "SMARTPROD";

GRANT ON COMMIT REFRESH ON "SMART"."V_ORPAG_OPER" TO "SMARTPROD";

GRANT REFERENCES ON "SMART"."V_ORPAG_OPER" TO "SMARTPROD";

GRANT
UPDATE
    ON "SMART"."V_ORPAG_OPER" TO "SMARTPROD";

GRANT
SELECT
    ON "SMART"."V_ORPAG_OPER" TO "SMARTPROD";

GRANT
INSERT
    ON "SMART"."V_ORPAG_OPER" TO "SMARTPROD";

GRANT DELETE ON "SMART"."V_ORPAG_OPER" TO "SMARTPROD";