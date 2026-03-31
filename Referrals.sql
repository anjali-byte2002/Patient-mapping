--Providerwise

--eCW
SELECT
    /* ====================== Identifiers ====================== */
    r.ReferralId                            AS referral_id,
    r.patientID                             AS ndid,
    rd.encounterID                          AS encounter_id,

    /* ====================== Referral Details ====================== */
    r.UnitType                              AS referral_type,   -- PR (PROCEDURE), V (VISIT)
    NULL                                    AS referral_direction,
    r.status                                AS referral_status,
    NULL                                    AS referral_priority,
    COALESCE(r.refStDate, r.refEnddate)     AS referral_date,
    r.apptDate                              AS scheduled_appointment_date,
    NULL                                    AS appointment_id,
    NULL                                    AS completed_date,

    /* ====================== Referring Provider (FROM) ====================== */
    NULL                                    AS referring_provider_id,
    NULL                                    AS referring_provider_name,

    /* ====================== Referred To Provider ====================== */
    r.RefTo                                 AS referred_to_provider_id,
    r.assignedTo                            AS referred_to_provider_name,
    COALESCE(r.speciality, r.refToName)     AS referred_to_specialty,

    /* ====================== Clinical ====================== */
    nx.reason                               AS referral_reason,
    NULL                                    AS chief_complaint,
    COALESCE(nx.diagnosis, r.diagnosis)     AS diagnosis_code,  -- nhxreferral includes diagnosis desc
    r.procedures                            AS service_procedure_code,
    COALESCE(nx.notes, r.clinicalNotes)     AS clinical_summary,
    NULL                                    AS requested_service,

    /* ====================== Authorization ====================== */
    NULL                                    AS authorization_required,
    r.authNo                                AS authorization_number,

    /* ====================== Flags & Follow-up ====================== */
    NULL                                    AS patient_contacted,
    NULL                                    AS specialist_report_received,
    NULL                                    AS specialist_report_text,
    NULL                                    AS follow_up_required,
    NULL                                    AS referral_loop_closed,
    NULL                                    AS out_of_network_flag,
    NULL                                    AS patient_declined_flag

FROM referral r

LEFT JOIN referraldetail rd
    ON rd.ReferralId = r.ReferralId

LEFT JOIN nhxreferral nx
    ON nx.ReferralId = r.ReferralId;



--ATHENAONE

SELECT
    /* ====================== Identifiers ====================== */
    ral.REFERRALID                          AS referral_id,
    NULL                                    AS ndid,
    NULL                                    AS encounter_id,

    /* ====================== Referral Details ====================== */
    NULL                                    AS referral_type,
    NULL                                    AS referral_direction,
    NULL                                    AS referral_status,
    NULL                                    AS referral_priority,
    NULL                                    AS referral_date,
    NULL                                    AS scheduled_appointment_date,
    ral.APPOINTMENTID                       AS appointment_id,
    NULL                                    AS completed_date,

    /* ====================== Referring Provider (FROM) ====================== */
    rauth.REFERRINGPROVIDERID               AS referring_provider_id,
    NULL                                    AS referring_provider_name,

    /* ====================== Referred To Provider ====================== */
    NULL                                    AS referred_to_provider_id,
    NULL                                    AS referred_to_provider_name,
    rauth.REFERRALAUTHSPECIALTY             AS referred_to_specialty,

    /* ====================== Clinical ====================== */
    NULL                                    AS referral_reason,
    NULL                                    AS chief_complaint,
    rdiag.DIAGNOSISCODE                     AS diagnosis_code,
    rproc.PROCEDURECODE                     AS service_procedure_code,
    rauth.NOTES                             AS clinical_summary,
    rauth.NOTES                             AS requested_service,  -- RALEIGH specific

    /* ====================== Authorization ====================== */
    rauth.REFERRALAUTHNUMBER                AS authorization_required,
    COALESCE(
        rdiag.REFERRALAUTHID,
        rauth.REFERRALAUTHID,
        rproc.REFERRALAUTHID
    )                                       AS authorization_number,

    /* ====================== Flags & Follow-up ====================== */
    NULL                                    AS patient_contacted,
    NULL                                    AS specialist_report_received,
    NULL                                    AS specialist_report_text,
    NULL                                    AS follow_up_required,
    NULL                                    AS referral_loop_closed,
    NULL                                    AS out_of_network_flag,
    NULL                                    AS patient_declined_flag

FROM REFERRALAPPOINTMENTLINK ral

LEFT JOIN REFERRALAUTHORIZATION rauth
    ON rauth.REFERRALAUTHID = ral.REFERRALAUTHID

LEFT JOIN REFERRALAUTHDIAGNOSISCODE rdiag
    ON rdiag.REFERRALAUTHID = rauth.REFERRALAUTHID

LEFT JOIN REFERRALAUTHPROCEDURECODE rproc
    ON rproc.REFERRALAUTHID = rauth.REFERRALAUTHID;


-- GREENWAY
SELECT
    /* ====================== Identifiers ====================== */
    ipc.InsPreCertID                        AS referral_id,
    ipc.PatientID                           AS ndid,
    ipc.VisitID                             AS encounter_id,

    /* ====================== Referral Details ====================== */
    NULL                                    AS referral_type,
    NULL                                    AS referral_direction,
    NULL                                    AS referral_status,
    NULL                                    AS referral_priority,
    ipc.ReferredDate                        AS referral_date,
    ipc.ApptDate                            AS scheduled_appointment_date,
    NULL                                    AS appointment_id,
    NULL                                    AS completed_date,

    /* ====================== Referring Provider (FROM) ====================== */
    rrp.ReferringProviderID                 AS referring_provider_id,
    NULL                                    AS referring_provider_name,

    /* ====================== Referred To Provider ====================== */
    NULL                                    AS referred_to_provider_id,
    NULL                                    AS referred_to_provider_name,
    cps.Description                         AS referred_to_specialty,

    /* ====================== Clinical ====================== */
    ipc.ReferralReason                      AS referral_reason,
    NULL                                    AS chief_complaint,
    NULL                                    AS diagnosis_code,
    NULL                                    AS service_procedure_code,
    NULL                                    AS clinical_summary,
    ipc.Description                         AS requested_service,

    /* ====================== Authorization ====================== */
    NULL                                    AS authorization_required,
    NULL                                    AS authorization_number,

    /* ====================== Flags & Follow-up ====================== */
    NULL                                    AS patient_contacted,
    NULL                                    AS specialist_report_received,
    NULL                                    AS specialist_report_text,
    NULL                                    AS follow_up_required,
    NULL                                    AS referral_loop_closed,
    NULL                                    AS out_of_network_flag,
    NULL                                    AS patient_declined_flag

FROM InsurancePreCert ipc

LEFT JOIN ReferralsReferringProvider rrp
    ON rrp.ReferralID = ipc.InsPreCertID

LEFT JOIN CareProviderToSpecialty cpts
    ON cpts.CareProviderID = rrp.ReferringProviderID

LEFT JOIN CareProviderSpecialty cps
    ON cps.Code = cpts.SpecialtyCode;


--ATHENAPRACTICE
SELECT
    /* ====================== Identifiers ====================== */
    NULL                                        AS referral_id,
    COALESCE(pp.PatientId, pp.Pld)              AS ndid,
    NULL                                        AS encounter_id,

    /* ====================== Referral Details ====================== */
    NULL                                        AS referral_type,
    NULL                                        AS referral_direction,
    NULL                                        AS referral_status,
    NULL                                        AS referral_priority,
    NULL                                        AS referral_date,
    NULL                                        AS scheduled_appointment_date,
    ap.AppointmentsId                           AS appointment_id,
    NULL                                        AS completed_date,

    /* ====================== Referring Provider (FROM) ====================== */
    NULL                                        AS referring_provider_id,
    NULL                                        AS referring_provider_name,

    /* ====================== Referred To Provider ====================== */
    NULL                                        AS referred_to_provider_id,
    NULL                                        AS referred_to_provider_name,
    NULL                                        AS referred_to_specialty,

    /* ====================== Clinical ====================== */
    NULL                                        AS referral_reason,
    NULL                                        AS chief_complaint,
    NULL                                        AS diagnosis_code,
    COALESCE(pvp.CPTCode, pvp.Code)             AS service_procedure_code,
    ap.Notes                                    AS clinical_summary,
    COALESCE(pvp.Description, o.DESCRIPTION)    AS requested_service,

    /* ====================== Authorization ====================== */
    NULL                                        AS authorization_required,
    NULL                                        AS authorization_number,

    /* ====================== Flags & Follow-up ====================== */
    NULL                                        AS patient_contacted,
    NULL                                        AS specialist_report_received,
    NULL                                        AS specialist_report_text,
    NULL                                        AS follow_up_required,
    NULL                                        AS referral_loop_closed,
    NULL                                        AS out_of_network_flag,
    NULL                                        AS patient_declined_flag

FROM PatientProfile pp

LEFT JOIN Appointments ap
    ON ap.PatientProfileId = pp.PatientProfileId

LEFT JOIN PatientVisitProcs pvp
    ON pvp.PatientVisitId = ap.PatientVisitId

LEFT JOIN ORDERS o
    ON o.OrderId = pvp.OrderId;

--------------------------------------------


-- Schemawise

-- RALEIGH
-- =============================================
SELECT
    ral.REFERRALID                          AS referral_id,
    NULL                                    AS ndid,
    NULL                                    AS encounter_id,
    NULL                                    AS referral_type,
    NULL                                    AS referral_direction,
    NULL                                    AS referral_status,
    NULL                                    AS referral_priority,
    NULL                                    AS referral_date,
    NULL                                    AS scheduled_appointment_date,
    ral.APPOINTMENTID                       AS appointment_id,
    NULL                                    AS completed_date,
    NULL                                    AS referring_provider_id,
    NULL                                    AS referring_provider_name,
    NULL                                    AS referred_to_provider_id,
    NULL                                    AS referred_to_provider_name,
    NULL                                    AS referred_to_specialty,
    NULL                                    AS referral_reason,
    NULL                                    AS chief_complaint,
    rdiag.DIAGNOSISCODE                     AS diagnosis_code,
    rproc.PROCEDURECODE                     AS service_procedure_code,
    NULL                                    AS clinical_summary,
    NULL                                    AS requested_service,
    NULL                                    AS authorization_required,
    COALESCE(rdiag.REFERRALAUTHID, rproc.REFERRALAUTHID) AS authorization_number,
    NULL                                    AS patient_contacted,
    NULL                                    AS specialist_report_received,
    NULL                                    AS specialist_report_text,
    NULL                                    AS follow_up_required,
    NULL                                    AS referral_loop_closed,
    NULL                                    AS out_of_network_flag,
    NULL                                    AS patient_declined_flag,
    'raleigh'                               AS schema_name
FROM raleigh.REFERRALAPPOINTMENTLINK ral
LEFT JOIN raleigh.REFERRALAUTHDIAGNOSISCODE rdiag ON rdiag.REFERRALAUTHID = ral.REFERRALID
LEFT JOIN raleigh.REFERRALAUTHPROCEDURECODE rproc ON rproc.REFERRALAUTHID = ral.REFERRALID

UNION ALL

SELECT
    rauth.REFERRALAUTHID                    AS referral_id,
    NULL                                    AS ndid,
    NULL                                    AS encounter_id,
    NULL                                    AS referral_type,
    NULL                                    AS referral_direction,
    NULL                                    AS referral_status,
    NULL                                    AS referral_priority,
    NULL                                    AS referral_date,
    NULL                                    AS scheduled_appointment_date,
    NULL                                    AS appointment_id,
    NULL                                    AS completed_date,
    rauth.REFERRINGPROVIDERID               AS referring_provider_id,
    NULL                                    AS referring_provider_name,
    NULL                                    AS referred_to_provider_id,
    NULL                                    AS referred_to_provider_name,
    rauth.REFERRALAUTHSPECIALTY             AS referred_to_specialty,
    NULL                                    AS referral_reason,
    NULL                                    AS chief_complaint,
    NULL                                    AS diagnosis_code,
    NULL                                    AS service_procedure_code,
    NULL                                    AS clinical_summary,
    rauth.NOTES                             AS requested_service,  -- raleigh: NOTES = requested_service
    rauth.REFERRALAUTHNUMBER                AS authorization_required,
    rauth.REFERRALAUTHID                    AS authorization_number,
    NULL                                    AS patient_contacted,
    NULL                                    AS specialist_report_received,
    NULL                                    AS specialist_report_text,
    NULL                                    AS follow_up_required,
    NULL                                    AS referral_loop_closed,
    NULL                                    AS out_of_network_flag,
    NULL                                    AS patient_declined_flag,
    'raleigh'                               AS schema_name
FROM raleigh.REFERRALAUTHORIZATION rauth

UNION ALL

-- =============================================
-- DCND
-- =============================================
SELECT
    ral.REFERRALID                          AS referral_id,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    ral.APPOINTMENTID                       AS appointment_id,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    rdiag.DIAGNOSISCODE                     AS diagnosis_code,
    rproc.PROCEDURECODE                     AS service_procedure_code,
    NULL, NULL, NULL,
    COALESCE(rdiag.REFERRALAUTHID, rproc.REFERRALAUTHID) AS authorization_number,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    'dcnd'                                  AS schema_name
FROM dcnd.REFERRALAPPOINTMENTLINK ral
LEFT JOIN dcnd.REFERRALAUTHDIAGNOSISCODE rdiag ON rdiag.REFERRALAUTHID = ral.REFERRALID
LEFT JOIN dcnd.REFERRALAUTHPROCEDURECODE rproc ON rproc.REFERRALAUTHID = ral.REFERRALID

UNION ALL

SELECT
    rauth.REFERRALAUTHID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL,
    rauth.REFERRINGPROVIDERID               AS referring_provider_id,
    NULL, NULL, NULL,
    rauth.REFERRALAUTHSPECIALTY             AS referred_to_specialty,
    NULL, NULL, NULL, NULL,
    rauth.NOTES                             AS clinical_summary,  -- dcnd: NOTES = clinical_summary
    NULL,
    rauth.REFERRALAUTHNUMBER                AS authorization_required,
    rauth.REFERRALAUTHID                    AS authorization_number,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    'dcnd'                                  AS schema_name
FROM dcnd.REFERRALAUTHORIZATION rauth

UNION ALL

-- =============================================
-- TNCPA
-- =============================================
SELECT
    ral.REFERRALID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    ral.APPOINTMENTID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    rdiag.DIAGNOSISCODE,
    rproc.PROCEDURECODE,
    NULL, NULL, NULL,
    COALESCE(rdiag.REFERRALAUTHID, rproc.REFERRALAUTHID),
    NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    'tncpa'                                 AS schema_name
FROM tncpa.REFERRALAPPOINTMENTLINK ral
LEFT JOIN tncpa.REFERRALAUTHDIAGNOSISCODE rdiag ON rdiag.REFERRALAUTHID = ral.REFERRALID
LEFT JOIN tncpa.REFERRALAUTHPROCEDURECODE rproc ON rproc.REFERRALAUTHID = ral.REFERRALID

UNION ALL

SELECT
    rauth.REFERRALAUTHID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL,
    rauth.REFERRINGPROVIDERID,
    NULL, NULL, NULL,
    rauth.REFERRALAUTHSPECIALTY,
    NULL, NULL, NULL, NULL,
    rauth.NOTES,   -- tncpa: NOTES = clinical_summary
    NULL,
    rauth.REFERRALAUTHNUMBER,
    rauth.REFERRALAUTHID,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    'tncpa'                                 AS schema_name
FROM tncpa.REFERRALAUTHORIZATION rauth

UNION ALL

-- =============================================
-- TNG-ATHENAONE
-- =============================================
SELECT
    ral.REFERRALID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    ral.APPOINTMENTID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    rdiag.DIAGNOSISCODE,
    rproc.PROCEDURECODE,
    NULL, NULL, NULL,
    COALESCE(rdiag.REFERRALAUTHID, rproc.REFERRALAUTHID),
    NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    'tng-athenaone'                         AS schema_name
FROM `tng-athenaone`.REFERRALAPPOINTMENTLINK ral
LEFT JOIN `tng-athenaone`.REFERRALAUTHDIAGNOSISCODE rdiag ON rdiag.REFERRALAUTHID = ral.REFERRALID
LEFT JOIN `tng-athenaone`.REFERRALAUTHPROCEDURECODE rproc ON rproc.REFERRALAUTHID = ral.REFERRALID

UNION ALL

SELECT
    rauth.REFERRALAUTHID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL,
    rauth.REFERRINGPROVIDERID,
    NULL, NULL, NULL,
    rauth.REFERRALAUTHSPECIALTY,
    NULL, NULL, NULL, NULL,
    rauth.NOTES,   -- tng-athenaone: NOTES = clinical_summary
    NULL,
    rauth.REFERRALAUTHNUMBER,
    rauth.REFERRALAUTHID,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    'tng-athenaone'                         AS schema_name
FROM `tng-athenaone`.REFERRALAUTHORIZATION rauth

UNION ALL

-- =============================================
-- TNG_ATHENA_ONE
-- =============================================
SELECT
    ral.REFERRALID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    ral.APPOINTMENTID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    rdiag.DIAGNOSISCODE,
    rproc.PROCEDURECODE,
    NULL, NULL, NULL,
    COALESCE(rdiag.REFERRALAUTHID, rproc.REFERRALAUTHID),
    NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    'tng_athena_one'                        AS schema_name
FROM tng_athena_one.REFERRALAPPOINTMENTLINK ral
LEFT JOIN tng_athena_one.REFERRALAUTHDIAGNOSISCODE rdiag ON rdiag.REFERRALAUTHID = ral.REFERRALID
LEFT JOIN tng_athena_one.REFERRALAUTHPROCEDURECODE rproc ON rproc.REFERRALAUTHID = ral.REFERRALID

UNION ALL

SELECT
    rauth.REFERRALAUTHID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL,
    rauth.REFERRINGPROVIDERID,
    NULL, NULL, NULL,
    rauth.REFERRALAUTHSPECIALTY,
    NULL, NULL, NULL, NULL,
    rauth.NOTES,   -- tng_athena_one: NOTES = clinical_summary
    NULL,
    rauth.REFERRALAUTHNUMBER,
    rauth.REFERRALAUTHID,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    'tng_athena_one'                        AS schema_name
FROM tng_athena_one.REFERRALAUTHORIZATION rauth;
