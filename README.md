# patient_app

Patient Flutter app generated and maintained with Embit CLI.

## Appointments Feature Status

Appointments page and feature scaffolding are completed via CLI generation.

### Feature command used

```bash
embit feature -n appointments --nav-bar --icon Icons.calendar_today_outlined --label "Appointments"
```

### Models generated (from `creator.md`)

```bash
embit model -f appointments -n appointment --string patientId --string doctorId --string departmentId --string branchId --string familyMemberId --string appointmentDate --string slotStartTime --string slotEndTime --string bookingSource --string appointmentType --string visitReason --string chiefComplaint --string priority --string status --string cancellationReason --string cancelledBy --int tokenNumber --with-state
embit model -f appointments -n doctor --string firstName --string lastName --string salutation --string genderCode --string specialization --string subSpecialization --string qualifications --string profilePhotoUrl --string mciRegistrationNumber --int experienceYears --double consultationFee --double followUpFee --bool isAvailableOnline --int maxPatientsPerDay --int avgConsultationMin
embit model -f appointments -n department --string name --string code --string description
embit model -f appointments -n hospital_branch --string branchName --string branchCode --string addressLine1 --string city --string state --string pincode --string phone --string email --double latitude --double longitude
embit model -f appointments -n doctor_schedule --string doctorId --string branchId --string slotStartTime --string slotEndTime --string effectiveFrom --string effectiveUntil --int dayOfWeek --int maxTokens --bool isActive
embit model -f appointments -n queue_status --string doctorId --string queueDate --string status --int currentToken --int totalTokensIssued --int avgWaitMinutes --with-state
```

### Usecases generated (from `creator.md`)

```bash
embit usecase -f appointments -n get_doctors -t get-list --with-event
embit usecase -f appointments -n get_doctor_detail -t get --string doctorId --with-event
embit usecase -f appointments -n get_departments -t get-list --with-event
embit usecase -f appointments -n get_hospital_branches -t get-list --with-event
embit usecase -f appointments -n get_doctor_schedule -t get-list --string doctorId --with-event
embit usecase -f appointments -n get_queue_status -t get --string doctorId --with-event
embit usecase -f appointments -n get_upcoming_appointments -t get-list --with-event
embit usecase -f appointments -n get_past_appointments -t get-list --with-event
embit usecase -f appointments -n get_appointment_detail -t get --string appointmentId --with-event
embit usecase -f appointments -n create_appointment -t create --with-event
embit usecase -f appointments -n cancel_appointment -t delete --string appointmentId --with-event
embit usecase -f appointments -n reschedule_appointment -t update --string appointmentId --with-event
```

### Routing and navigation

- Route path added: `/appointments`
- Detail path added: `/appointments/:appointmentsId`
- Appointments tab added to role-based navigation

### Verification run

```bash
flutter pub get
flutter analyze
```

Current analyzer status after appointments integration:
- Appointments generation errors are resolved.
- One unrelated existing project error remains in `test/widget_test.dart` (`App` type reference).

## Home Feature Status

Home page and feature scaffolding are completed via CLI generation and manual page rewrite.

### Feature command used

```bash
embit feature -n home --nav-bar --icon Icons.home_outlined --label "Home"
```

### Models generated (from `creator.md`)

```bash
embit model -f home -n home_summary --with-state
embit model -f home -n appointment_preview --string appointmentId --string doctorName --string departmentName --string hospitalBranch --string appointmentDate --string slotTime --string status --int tokenNumber
embit model -f home -n health_alert --string title --string message --string alertType --string priority
```

Note:
- Installed CLI `v0.9.2` does not accept `--with-state` without fields, so `home_summary` was generated with a compatible fallback field:
  `embit model -f home -n home_summary --string summaryTitle`

### Usecases generated (from `creator.md`)

```bash
embit usecase -f home -n get_home_summary -t get --with-event
embit usecase -f home -n get_health_alerts -t get-list --with-event
embit usecase -f home -n get_upcoming_appointments -t get-list --with-event
```

### Routing and page wiring

- Route path wired to page: `/home -> HomePage`
- Replaced placeholder home route in router with feature page.
- Rewrote home page UI into a dashboard-style implementation with stats, quick actions, and recent items.

### Verification run

```bash
flutter pub get
flutter analyze
```

Current analyzer status after home integration:
- Home generation errors are resolved.
- Existing project-wide warning set remains.
- One unrelated existing project error remains in `test/widget_test.dart` (`App` type reference).
