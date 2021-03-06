SET @Provider = :provider;
SET @StartDate = :begin_date;
SET @EndDate = :end_date;
SET @ProblemCode = :problem_code;
SET @MedicationCode = :medication_code;
SET @MedicationAllergyCode = :allergy_code;
SET @RaceCode = :race;
SET @EthnicityCode = :ethnicity;
SET @SexCode = :sex;
SET @CommunicationCode = :phone_publicity;
SET @AgeFrom = :ageFrom;
SET @AgeTo = :ageTo;
SET @MaritalCode = :marital;
SET @LanguageCode = :language;

SELECT patient.pid,
		CONCAT_WS('', patient.fname, ' ', patient.mname, ' ', patient.lname) as patient_name,
		DATE_FORMAT(patient.DOB, '%e %b %Y') as DateOfBirth,
        TIMESTAMPDIFF(YEAR, patient.DOB, CURDATE()) AS Age,
        Race.option_name as Race,
        Ethnicity.option_name as Ethnicity,
        Communication.option_name as Communication,
        Sex.option_name as sex_name,
        MaritalStatus.option_name as marital_status,
        LanguageSpoken.option_name as language_name,

        # Encounter Service Dates
        (SELECT
			GROUP_CONCAT(DATE_FORMAT(encounters.service_date, '%e %b %Y') SEPARATOR ', <br>') as service_dates
		FROM encounters
		WHERE patient.pid = encounters.pid) AS service_dates,

		# Patient providers
		(SELECT
			GROUP_CONCAT(CONCAT_WS('', fname, ' ', mname, ' ', lname) SEPARATOR ', <br>') as providers
		FROM users
		WHERE users.id = encounters.provider_uid AND
        CASE
		WHEN @Provider IS NOT NULL
			THEN FIND_IN_SET(users.id, @Provider)
			ELSE 1=1
		END) AS providers,

        # Patient Medications
		(SELECT
			GROUP_CONCAT(distinct(STR) SEPARATOR ', <br>') as STR
		FROM patient_medications
		WHERE patient.pid = patient_medications.pid AND
        CASE
		WHEN @MedicationCode IS NOT NULL
			THEN FIND_IN_SET(patient_medications.RXCUI, @MedicationCode)
			ELSE 1=1
		END) AS medications,

		# Patient Active Problems
		(SELECT
			GROUP_CONCAT(distinct(code_text) SEPARATOR '<br>') as code_text
		FROM patient_active_problems
		WHERE patient_active_problems.pid = patient.pid AND
        CASE
		WHEN @ProblemCode IS NOT NULL
			THEN FIND_IN_SET(patient_active_problems.code, @ProblemCode)
			ELSE 1=1
		END) AS problems,

		# Patient Medication Allergies
		(SELECT
			GROUP_CONCAT(distinct(allergy) SEPARATOR '<br>') as allergy
		FROM patient_allergies
		WHERE patient_allergies.pid = patient.pid AND
		CASE
			WHEN @MedicationAllergyCode IS NOT NULL
			THEN FIND_IN_SET(patient_allergies.allergy_code, @MedicationAllergyCode)
			ELSE 1=1
		END) AS allergies,

        # Laboratories Orders/Results/Values
		(SELECT
			GROUP_CONCAT(CONCAT_WS('', PO.description, ": ",PORO.value," ",PORO.units) SEPARATOR ', <br>') as laboratories
		FROM patient_orders AS PO
		LEFT JOIN patient_order_results AS POR ON POR.order_id  = PO.id
		LEFT JOIN patient_order_results_observations AS PORO ON PORO.result_id = POR.id
		WHERE PO.pid = patient.pid AND order_type = 'lab'
		:WHERE_sub_lab_order
		) AS laboratories

FROM patient

# Encounters Join
LEFT JOIN encounters ON patient.pid = encounters.pid

# Patient Medications Join
LEFT JOIN patient_medications ON encounters.eid = patient_medications.eid

# Active Problems Join
LEFT JOIN patient_active_problems ON encounters.eid = patient_active_problems.eid

# Medication Allergies Join
LEFT JOIN patient_allergies ON encounters.eid = patient_allergies.eid

# Providers Join
LEFT JOIN users as Providers ON Providers.id = encounters.provider_uid

# Laboratory Orders Join
LEFT JOIN patient_orders ON patient.pid = patient_orders.pid AND order_type = 'lab'

# Laboratory Orders Results Join
LEFT JOIN patient_order_results ON patient_order_results.order_id  = patient_orders.id

# Laboratory Orders Results Observations Join
LEFT JOIN patient_order_results_observations ON patient_order_results_observations.result_id = patient_order_results.id

# Race Join
LEFT JOIN combo_lists_options as Race ON Race.option_value = patient.race AND Race.list_id = 14

# Ethnicity Join
LEFT JOIN combo_lists_options as Ethnicity ON Ethnicity.option_value = patient.ethnicity AND Ethnicity.list_id = 59

# Phone Publicity (Communication)
LEFT JOIN combo_lists_options as Communication ON Communication.option_value = patient.phone_publicity AND Communication.list_id = 132

# Patient Gender
LEFT JOIN combo_lists_options as Sex ON Sex.option_value = patient.sex AND Sex.list_id = 95

# Marital Status
LEFT JOIN combo_lists_options as MaritalStatus ON MaritalStatus.option_value = patient.marital_status AND MaritalStatus.list_id = 12

# Patient Language
LEFT JOIN combo_lists_options as LanguageSpoken ON LanguageSpoken.option_value = patient.language AND LanguageSpoken.list_id = 10

WHERE

# Where StartDate and EndDate
CASE
	WHEN @StartDate IS NOT NULL AND @EndDate IS NOT NULL
	THEN encounters.service_date BETWEEN @StartDate AND @EndDate
    ELSE 1=1
END

AND

# Where MedicationCode
CASE
	WHEN @MedicationCode IS NOT NULL
	THEN FIND_IN_SET(patient_medications.RXCUI, @MedicationCode)
	ELSE 1=1
END

AND

# Where Active Problems
CASE
	WHEN @ProblemCode IS NOT NULL
	THEN FIND_IN_SET(patient_active_problems.code, @ProblemCode)
    ELSE 1=1
END

AND

# Where Race
CASE
    WHEN @RaceCode IS NOT NULL
	THEN FIND_IN_SET(patient.race, @RaceCode)
    ELSE 1=1
END

AND

# Where Ethnicity
CASE
    WHEN @EthnicityCode IS NOT NULL
	THEN FIND_IN_SET(patient.ethnicity, @EthnicityCode)
    ELSE 1=1
END

AND

# Where Communication
CASE
    WHEN @CommunicationCode IS NOT NULL
	THEN FIND_IN_SET(patient.phone_publicity, @CommunicationCode)
    ELSE 1=1
END

AND

# Where Language
CASE
    WHEN @LanguageCode IS NOT NULL
	THEN FIND_IN_SET(patient.language, @LanguageCode)
    ELSE 1=1
END

AND

# Where Marital Status
CASE
    WHEN @MaritalCode IS NOT NULL
	THEN FIND_IN_SET(patient.marital_status, @MaritalCode)
    ELSE 1=1
END

AND

# Where Patient Gender
CASE
    WHEN @SexCode IS NOT NULL
	THEN FIND_IN_SET(patient.sex, @SexCode)
    ELSE 1=1
END

AND

# Where Medication Allergies
CASE
	WHEN @MedicationAllergyCode IS NOT NULL
	THEN FIND_IN_SET(patient_allergies.allergy_code, @MedicationAllergyCode)
    ELSE 1=1
END

AND

# Where Provider
CASE
	WHEN @Provider IS NOT NULL
	THEN FIND_IN_SET(encounters.provider_uid, @Provider)
	ELSE 1=1
END

AND

# Where AgeFrom and AgeTo
CASE
    WHEN @AgeFrom IS NOT NULL AND @AgeTo IS NOT NULL
    THEN TIMESTAMPDIFF(YEAR, patient.DOB, CURDATE()) BETWEEN @AgeFrom AND @AgeTo
    ELSE 1=1
END

:WHERE_lab_order

GROUP BY patient.pid
:ux-sort
:ux-pagination;
