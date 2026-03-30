-- ecw
SELECT
    /* ====================== Identifiers ====================== */
    NULL                                    AS hist_id,
    NULL                                    AS ndid,
    sh.encounterID                          AS encounterid,
    NULL                                    AS enc_date,

    /* ====================== Dates ====================== */
    NULL                                    AS history_episode_date,
    NULL                                    AS ChartID,
    sh.date                                 AS history_date,

    /* ====================== Surgical History Details ====================== */
    NULL                                    AS hist_category,
    sh.reason                               AS hist_name,       -- Procedure name
    NULL                                    AS hist_question,
    NULL                                    AS hist_value,
    NULL                                    AS Surgical_Code,
    NULL                                    AS Surgical_Coding_System,
    NULL                                    AS Surgical_Notes,
    NULL                                    AS Codes

FROM surgicalhistory sh;

-- Athenaone
SELECT
    /* ====================== Identifiers ====================== */
    COALESCE(psh.PATIENTSURGICALHISTORYID, ps.PATIENTSURGERYID)     AS hist_id,
    NULL                                                             AS ndid,
    NULL                                                             AS encounterid,
    NULL                                                             AS enc_date,

    /* ====================== Dates ====================== */
    NULL                                                             AS history_episode_date,
    ps.CHARTID                                                       AS ChartID,
    NULL                                                             AS history_date,

    /* ====================== Surgical History Details ====================== */
    NULL                                                             AS hist_category,
    COALESCE(ps.PROCEDURE, shp.NAME)                                 AS hist_name,
    NULL                                                             AS hist_question,
    NULL                                                             AS hist_value,
    NULL                                                             AS Surgical_Code,
    NULL                                                             AS Surgical_Coding_System,
    psh.NOTE                                                         AS Surgical_Notes,
    COALESCE(psh.SNOMEDCODE, snomd.SNOMEDCODE)                       AS Codes

FROM PATIENTSURGICALHISTORY psh

LEFT JOIN PATIENTSURGERY ps
    ON ps.PATIENTSURGERYID = psh.PATIENTSURGERYID

LEFT JOIN SURGICALHISTORYPROCEDURE shp
    ON shp.PATIENTSURGERYID = ps.PATIENTSURGERYID

LEFT JOIN SURGICALHXPROCEDURESNOMED snomd
    ON snomd.PATIENTSURGICALHISTORYID = psh.PATIENTSURGICALHISTORYID;

--GREENWAY
SELECT
    /* ====================== Identifiers ====================== */
    COALESCE(ps.PatHistSurgicalID, ph.PatHistSurgicalID)    AS hist_id,
    psh.PatientID                                           AS ndid,
    NULL                                                    AS encounterid,
    NULL                                                    AS enc_date,

    /* ====================== Dates ====================== */
    NULL                                                    AS history_episode_date,
    NULL                                                    AS ChartID,
    psh.HistoryDate                                         AS history_date,

    /* ====================== Surgical History Details ====================== */
    NULL                                                    AS hist_category,
    NULL                                                    AS hist_name,
    NULL                                                    AS hist_question,
    NULL                                                    AS hist_value,
    NULL                                                    AS Surgical_Code,
    NULL                                                    AS Surgical_Coding_System,
    psh.PSHNote                                             AS Surgical_Notes,
    NULL                                                    AS Codes

FROM PatHistSurgicalHistory psh

LEFT JOIN PatHistSurgical ps
    ON ps.PatHistSurgicalID = psh.PatHistSurgicalID

LEFT JOIN PatHist ph
    ON ph.PatHistSurgicalID = psh.PatHistSurgicalID;
