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
    rapl.APPOINTMENTID                      AS appointment_id,
    NULL                                    AS completed_date,

    /* ====================== Referring Provider (FROM) ====================== */
    rauth.REFERRINGPROVIDERID               AS referring_provider_id,
    NULL                                    AS referring_provider_name,

    /* ====================== Referred To Provider ====================== */
    rauth.REFERRINGPROVIDERID               AS referred_to_provider_id,
    rsrc.NAME                               AS referred_to_provider_name,
    NULL                                    AS referred_to_specialty,

    /* ====================== Clinical ====================== */
    NULL                                    AS referral_reason,
    NULL                                    AS chief_complaint,
    rdiag.DIAGNOSISCODE                     AS diagnosis_code,
    rproc.PROCEDURECODE                     AS service_procedure_code,
    rauth.NOTES                             AS clinical_summary,
    NULL                                    AS requested_service,

    /* ====================== Authorization ====================== */
    NULL                                    AS authorization_required,
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

LEFT JOIN REFERRALSOURCE rsrc
    ON rsrc.REFERRALSOURCEID = rauth.REFERRALSOURCEID

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
