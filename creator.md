# Core modules
embit feature -n auth
embit feature -n home           --nav-bar --icon Icons.home_outlined             --label "Home"
embit feature -n appointments   --nav-bar --icon Icons.calendar_today_outlined   --label "Appointments"
embit feature -n medical_records --nav-bar --icon Icons.folder_outlined          --label "Records"
embit feature -n services       --nav-bar --icon Icons.medical_services_outlined --label "Services"
embit feature -n profile        --nav-bar --icon Icons.person_outline            --label "Profile"

# Non-nav modules
embit feature -n abdm
embit feature -n billing
embit feature -n notifications
embit feature -n vitals
embit feature -n pharmacy
embit feature -n insurance
embit feature -n care_plan


# patient_auth table — OTP, session, device tokens
embit model -f auth -n patient_auth \
  --string phoneNumber \
  --string email \
  --string accountStatus \
  --string otpHash \
  --string refreshTokenHash \
  --string lastLoginIp \
  --with-state

# device session (maps to device_tokens JSON in patient_auth)
embit model -f auth -n device_session \
  --string deviceId \
  --string platform \
  --string pushToken


  # Home summary — aggregated dashboard data
embit model -f home -n home_summary \
  --with-state

# Appointment preview card for home feed
embit model -f home -n appointment_preview \
  --string appointmentId \
  --string doctorName \
  --string departmentName \
  --string hospitalBranch \
  --string appointmentDate \
  --string slotTime \
  --string status \
  --int tokenNumber

# Health alert banner
embit model -f home -n health_alert \
  --string title \
  --string message \
  --string alertType \
  --string priority


  # patients table — full demographics
embit model -f profile -n patient_profile \
  --string firstName \
  --string middleName \
  --string lastName \
  --string dateOfBirth \
  --string genderCode \
  --string pronouns \
  --string profilePhotoUrl \
  --string abhaId \
  --string abhaAddress \
  --string alternatePhone \
  --string preferredLanguage \
  --string addressLine1 \
  --string addressLine2 \
  --string city \
  --string state \
  --string pincode \
  --string bloodGroupCode \
  --string maritalStatus \
  --double heightCm \
  --double weightKg \
  --double bmi \
  --with-state

# patient_lifestyle table
embit model -f profile -n lifestyle_profile \
  --string occupation \
  --string employerName \
  --string workType \
  --string tobaccoUse \
  --string alcoholUse \
  --string exerciseFrequency \
  --string exerciseType \
  --string dietType \
  --double waterIntakeLitres \
  --double sleepHoursAvg \
  --string stressLevel \
  --int workHoursPerDay

# family_members table
embit model -f profile -n family_member \
  --string firstName \
  --string lastName \
  --string dateOfBirth \
  --string genderCode \
  --string relation \
  --string phoneNumber \
  --string bloodGroupCode \
  --string abhaId \
  --bool isDependent \
  --bool isEmergencyContact

# emergency_contacts table
embit model -f profile -n emergency_contact \
  --string name \
  --string relation \
  --string phonePrimary \
  --string phoneSecondary \
  --string email \
  --string address \
  --bool isLegalGuardian \
  --bool isAuthorizedForMedicalDecisions \
  --int priorityOrder


  # appointments table — full booking entity
embit model -f appointments -n appointment \
  --string patientId \
  --string doctorId \
  --string departmentId \
  --string branchId \
  --string familyMemberId \
  --string appointmentDate \
  --string slotStartTime \
  --string slotEndTime \
  --string bookingSource \
  --string appointmentType \
  --string visitReason \
  --string chiefComplaint \
  --string priority \
  --string status \
  --string cancellationReason \
  --string cancelledBy \
  --int tokenNumber \
  --with-state

# doctors table
embit model -f appointments -n doctor \
  --string firstName \
  --string lastName \
  --string salutation \
  --string genderCode \
  --string specialization \
  --string subSpecialization \
  --string qualifications \
  --string profilePhotoUrl \
  --string mciRegistrationNumber \
  --int experienceYears \
  --double consultationFee \
  --double followUpFee \
  --bool isAvailableOnline \
  --int maxPatientsPerDay \
  --int avgConsultationMin

# departments table
embit model -f appointments -n department \
  --string name \
  --string code \
  --string description

# organization_branches table
embit model -f appointments -n hospital_branch \
  --string branchName \
  --string branchCode \
  --string addressLine1 \
  --string city \
  --string state \
  --string pincode \
  --string phone \
  --string email \
  --double latitude \
  --double longitude

# doctor_schedules table
embit model -f appointments -n doctor_schedule \
  --string doctorId \
  --string branchId \
  --string slotStartTime \
  --string slotEndTime \
  --string effectiveFrom \
  --string effectiveUntil \
  --int dayOfWeek \
  --int maxTokens \
  --bool isActive

# queue_status table
embit model -f appointments -n queue_status \
  --string doctorId \
  --string queueDate \
  --string status \
  --int currentToken \
  --int totalTokensIssued \
  --int avgWaitMinutes \
  --with-state



  # medical_records table — unified document store
embit model -f medical_records -n medical_record \
  --string recordTypeCode \
  --string recordTitle \
  --string fileUrl \
  --string fileType \
  --string source \
  --string recordDate \
  --string description \
  --int fileSizeKb \
  --bool isVerified \
  --bool isSharedAbdm \
  --with-state

# prescriptions table
embit model -f medical_records -n prescription \
  --string prescriptionNumber \
  --string prescriptionDate \
  --string doctorId \
  --string appointmentId \
  --string diagnosis \
  --string chiefComplaint \
  --string clinicalNotes \
  --string advice \
  --string followUpDate \
  --string prescriptionPdfUrl \
  --string status \
  --bool isDigitallySigned

# prescription_items table (drug line items)
embit model -f medical_records -n prescription_item \
  --string drugName \
  --string drugGenericName \
  --string formCode \
  --string strength \
  --string route \
  --string dose \
  --string frequency \
  --string timing \
  --string specialInstructions \
  --int durationDays \
  --int quantity \
  --bool isSubstitutionAllowed

# lab_orders table
embit model -f medical_records -n lab_report \
  --string orderNumber \
  --string orderDate \
  --string labId \
  --string orderingDoctorId \
  --string priority \
  --string status \
  --string reportPdfUrl \
  --string clinicalInfo \
  --with-state

# lab_order_tests — individual test results
embit model -f medical_records -n lab_test_result \
  --string testName \
  --string resultValue \
  --string resultUnit \
  --string referenceRangeLow \
  --string referenceRangeHigh \
  --string resultFlag \
  --string resultText

# vaccinations table
embit model -f medical_records -n vaccination \
  --string vaccineName \
  --string vaccineCode \
  --string administeredDate \
  --string administeredBy \
  --string batchNumber \
  --string manufacturer \
  --string site \
  --string route \
  --string nextDueDate \
  --string adverseReaction \
  --string certificateUrl \
  --int doseNumber \
  --int totalDosesRequired

# patient_allergies table
embit model -f medical_records -n allergy \
  --string allergenName \
  --string allergenType \
  --string reactionDescription \
  --string severity \
  --string onsetDate \
  --bool isActive

# patient_medical_history table
embit model -f medical_records -n medical_history_entry \
  --string conditionName \
  --string icd10Code \
  --string conditionType \
  --string diagnosedDate \
  --string resolvedDate \
  --string treatingDoctor \
  --string notes \
  --bool isActive


  # patient_vitals table (time-series)
embit model -f vitals -n vital_record \
  --string recordedAt \
  --string recordedByType \
  --string deviceSource \
  --string bpPosition \
  --string temperatureSite \
  --string glucoseType \
  --string notes \
  --int bpSystolic \
  --int bpDiastolic \
  --int pulseRate \
  --int respiratoryRate \
  --double temperatureCelsius \
  --double spo2Percent \
  --double weightKg \
  --double heightCm \
  --double bmi \
  --double bloodGlucoseMgdl \
  --bool isAbnormal \
  --with-state



  # lab_test_catalog table
embit model -f services -n lab_test \
  --string testCode \
  --string testName \
  --string loincCode \
  --string category \
  --string sampleType \
  --string preparationInstructions \
  --double price \
  --int turnAroundHours

# lab_orders table (patient-facing order)
embit model -f services -n lab_order \
  --string orderNumber \
  --string orderDate \
  --string priority \
  --string status \
  --string clinicalInfo \
  --string reportPdfUrl \
  --with-state

# pharmacy_orders table
embit model -f services -n pharmacy_order \
  --string orderNumber \
  --string orderType \
  --string deliveryAddress \
  --string paymentStatus \
  --string orderStatus \
  --double totalAmount \
  --double discountAmount \
  --double gstAmount \
  --double finalAmount \
  --with-state

# pharmacy_order_items table
embit model -f services -n pharmacy_order_item \
  --string drugName \
  --string batchNumber \
  --string expiryDate \
  --string manufacturer \
  --string substitutedDrug \
  --int quantity \
  --double unitPrice \
  --double discountPercent \
  --double totalPrice \
  --bool isSubstituted



  # invoices table
embit model -f billing -n invoice \
  --string invoiceNumber \
  --string invoiceDate \
  --string invoiceType \
  --string paymentDueDate \
  --string status \
  --string notes \
  --double subtotal \
  --double discountAmount \
  --double cgstAmount \
  --double sgstAmount \
  --double totalTax \
  --double totalAmount \
  --double insuranceCovered \
  --double patientPayable \
  --with-state

# invoice_items table
embit model -f billing -n invoice_item \
  --string itemName \
  --string itemType \
  --double quantity \
  --double unitPrice \
  --double discountPercent \
  --double gstPercent \
  --double gstAmount \
  --double totalPrice

# payments table
embit model -f billing -n payment \
  --string paymentNumber \
  --string paymentMethod \
  --string paymentGateway \
  --string gatewayTransactionId \
  --string upiVpa \
  --string bankName \
  --string chequeNumber \
  --string status \
  --string paidAt \
  --double amount \
  --double refundedAmount \
  --with-state



  # insurance_providers table
embit model -f insurance -n insurance_provider \
  --string name \
  --string providerType \
  --string irdaRegistration \
  --string tpaName \
  --string contactPhone \
  --string contactEmail

# patient_insurance table
embit model -f insurance -n insurance_policy \
  --string policyHolderName \
  --string policyHolderRelation \
  --string planName \
  --string policyStartDate \
  --string policyEndDate \
  --string premiumFrequency \
  --string cardImageUrl \
  --string policyDocumentUrl \
  --double sumInsured \
  --double premiumAmount \
  --double copayPercent \
  --double deductibleAmount \
  --bool isCashlessEnabled \
  --bool preAuthRequired \
  --bool isVerified \
  --with-state

# insurance_claims table
embit model -f insurance -n insurance_claim \
  --string claimNumber \
  --string claimType \
  --string preAuthNumber \
  --string admissionDate \
  --string dischargeDate \
  --string diagnosis \
  --string status \
  --string rejectionReason \
  --double claimedAmount \
  --double approvedAmount \
  --double settledAmount


  # abdm_consents table
embit model -f abdm -n abdm_consent \
  --string abdmConsentRequestId \
  --string abdmConsentArtefactId \
  --string purposeCode \
  --string purposeText \
  --string dateRangeFrom \
  --string dateRangeTo \
  --string expiryAt \
  --string frequencyUnit \
  --string consentStatus \
  --string grantedAt \
  --string revokedAt \
  --string revokeReason \
  --int frequencyValue \
  --with-state

# abdm_health_links table
embit model -f abdm -n health_link \
  --string linkToken \
  --string linkReference \
  --string linkStatus \
  --string linkedAt \
  --string unlinkedAt

# abha_profile (from patients table ABDM fields)
embit model -f abdm -n abha_profile \
  --string abhaId \
  --string abhaAddress \
  --bool abhaVerified


  # chronic_conditions table
embit model -f care_plan -n chronic_condition \
  --string conditionName \
  --string icd10Code \
  --string diagnosedDate \
  --string severity \
  --string notes \
  --bool isActive

# care_plans table
embit model -f care_plan -n care_plan \
  --string planName \
  --string description \
  --string assignedDoctorId \
  --string startDate \
  --string endDate \
  --string status \
  --string nextReviewDate \
  --int reviewFrequencyDays \
  --int version \
  --with-state

# care_plan_tasks table
embit model -f care_plan -n care_plan_task \
  --string taskName \
  --string taskType \
  --string description \
  --string frequency \
  --string dueDate \
  --string completedAt \
  --string status




  3️⃣ USECASES
AUTH
embit usecase -f auth -n send_otp              -t custom --string phoneNumber --with-event
embit usecase -f auth -n verify_otp            -t custom --string phoneNumber --string otp --with-event
embit usecase -f auth -n refresh_token         -t custom --with-event
embit usecase -f auth -n logout                -t custom --with-event
embit usecase -f auth -n get_account_status    -t get    --with-event

HOME
embit usecase -f home -n get_home_summary          -t get      --with-event
embit usecase -f home -n get_health_alerts         -t get-list --with-event
embit usecase -f home -n get_upcoming_appointments -t get-list --with-event

PROFILE
embit usecase -f profile -n get_patient_profile      -t get    --with-event
embit usecase -f profile -n update_patient_profile   -t update --with-event
embit usecase -f profile -n get_lifestyle_profile    -t get    --with-event
embit usecase -f profile -n update_lifestyle_profile -t update --with-event

embit usecase -f profile -n get_family_members    -t get-list --with-event
embit usecase -f profile -n add_family_member     -t create   --with-event
embit usecase -f profile -n update_family_member  -t update   --string memberId --with-event
embit usecase -f profile -n delete_family_member  -t delete   --string memberId --with-event

embit usecase -f profile -n get_emergency_contacts   -t get-list --with-event
embit usecase -f profile -n add_emergency_contact    -t create   --with-event
embit usecase -f profile -n update_emergency_contact -t update   --string contactId --with-event
embit usecase -f profile -n delete_emergency_contact -t delete   --string contactId --with-event

APPOINTMENTS
embit usecase -f appointments -n get_doctors              -t get-list --with-event
embit usecase -f appointments -n get_doctor_detail        -t get      --string doctorId --with-event
embit usecase -f appointments -n get_departments          -t get-list --with-event
embit usecase -f appointments -n get_hospital_branches    -t get-list --with-event
embit usecase -f appointments -n get_doctor_schedule      -t get-list --string doctorId --with-event
embit usecase -f appointments -n get_queue_status         -t get      --string doctorId --with-event
embit usecase -f appointments -n get_upcoming_appointments -t get-list --with-event
embit usecase -f appointments -n get_past_appointments    -t get-list --with-event
embit usecase -f appointments -n get_appointment_detail   -t get      --string appointmentId --with-event
embit usecase -f appointments -n create_appointment       -t create   --with-event
embit usecase -f appointments -n cancel_appointment       -t delete   --string appointmentId --with-event
embit usecase -f appointments -n reschedule_appointment   -t update   --string appointmentId --with-event

MEDICAL RECORDS
embit usecase -f medical_records -n get_medical_records  -t get-list --with-event
embit usecase -f medical_records -n get_record_detail    -t get      --string recordId --with-event
embit usecase -f medical_records -n upload_record        -t create   --with-event
embit usecase -f medical_records -n delete_record        -t delete   --string recordId --with-event

embit usecase -f medical_records -n get_prescriptions    -t get-list --with-event
embit usecase -f medical_records -n get_prescription_detail -t get   --string prescriptionId --with-event

embit usecase -f medical_records -n get_lab_reports      -t get-list --with-event
embit usecase -f medical_records -n get_lab_report_detail -t get     --string labOrderId --with-event

embit usecase -f medical_records -n get_vaccinations     -t get-list --with-event
embit usecase -f medical_records -n get_allergies        -t get-list --with-event
embit usecase -f medical_records -n get_medical_history  -t get-list --with-event

VITALS
embit usecase -f vitals -n get_vitals_history   -t get-list --with-event
embit usecase -f vitals -n get_latest_vitals    -t get      --with-event
embit usecase -f vitals -n log_vitals           -t create   --with-event

SERVICES
bash# Lab
embit usecase -f services -n get_lab_tests       -t get-list --with-event
embit usecase -f services -n create_lab_order    -t create   --with-event
embit usecase -f services -n get_lab_orders      -t get-list --with-event
embit usecase -f services -n get_lab_order_detail -t get     --string orderId --with-event
embit usecase -f services -n get_lab_results     -t get-list --string labOrderId --with-event

# Pharmacy
embit usecase -f services -n create_pharmacy_order    -t create   --with-event
embit usecase -f services -n get_pharmacy_orders      -t get-list --with-event
embit usecase -f services -n get_pharmacy_order_detail -t get     --string orderId --with-event
embit usecase -f services -n cancel_pharmacy_order    -t delete   --string orderId --with-event

BILLING
embit usecase -f billing -n get_invoices         -t get-list --with-event
embit usecase -f billing -n get_invoice_detail   -t get      --string invoiceId --with-event
embit usecase -f billing -n pay_invoice          -t create   --string invoiceId --double amount --with-event
embit usecase -f billing -n get_payment_history  -t get-list --with-event

INSURANCE
embit usecase -f insurance -n get_insurance_policies   -t get-list --with-event
embit usecase -f insurance -n add_insurance_policy     -t create   --with-event
embit usecase -f insurance -n update_insurance_policy  -t update   --string policyId --with-event
embit usecase -f insurance -n delete_insurance_policy  -t delete   --string policyId --with-event
embit usecase -f insurance -n get_insurance_claims     -t get-list --with-event
embit usecase -f insurance -n get_claim_detail         -t get      --string claimId  --with-event
embit usecase -f insurance -n submit_insurance_claim   -t create   --with-event

ABDM
embit usecase -f abdm -n link_abha            -t create --string abhaId     --with-event
embit usecase -f abdm -n get_abha_profile     -t get    --with-event
embit usecase -f abdm -n get_health_links     -t get-list --with-event
embit usecase -f abdm -n request_consent      -t create --with-event
embit usecase -f abdm -n revoke_consent       -t update --string consentId  --with-event
embit usecase -f abdm -n get_consent_history  -t get-list --with-event

CARE PLAN
embit usecase -f care_plan -n get_chronic_conditions  -t get-list --with-event
embit usecase -f care_plan -n get_care_plans          -t get-list --with-event
embit usecase -f care_plan -n get_care_plan_detail    -t get      --string planId --with-event
embit usecase -f care_plan -n get_care_plan_tasks     -t get-list --string planId --with-event
embit usecase -f care_plan -n update_task_status      -t update   --string taskId --with-event

NOTIFICATIONS
embit usecase -f notifications -n get_notifications         -t get-list --with-event
embit usecase -f notifications -n mark_notification_read    -t update   --string notificationId --with-event
embit usecase -f notifications -n mark_all_read             -t update   --with-event
embit usecase -f notifications -n delete_notification       -t delete   --string notificationId --with-event
embit usecase -f notifications -n get_notification_settings -t get      --with-event
embit usecase -f notifications -n update_notification_settings -t update --with-event