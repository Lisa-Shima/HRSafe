import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Types "./types/Types";
import Result "mo:base/Result";
import PatientRegistration "./modules/PatientRegistration";
import SessionManager "./modules/SessionManager";
import PatientLogin "./modules/PatientLogin";
import DoctorLogin "./modules/DoctorLogin";
import DoctorRegistration "./modules/DoctorRegister";
import Hashing "utils/Hashing";
import MedicalRecords "modules/MedicalRecords";

actor {
    let sessionManager = SessionManager.SessionManager();
    let patientLogin = PatientLogin.PatientLogin(sessionManager);
    let doctorLogin = DoctorLogin.DoctorLogin(sessionManager);

    stable var patientsEntries : [(Types.PatientID, Types.Patient)] = [];
    var patients : Types.Patients = HashMap.fromIter(patientsEntries.vals(), 10, Text.equal, Text.hash);

    stable var doctorsEntries : [(Types.DoctorID, Types.Doctor)] = [];
    var doctors : Types.Doctors = HashMap.fromIter(doctorsEntries.vals(), 10, Text.equal, Text.hash);

    stable var medicalRecordsEntries : [(Text, Types.MedicalRecord)] = [];
    var medicalRecords : HashMap.HashMap<Text, Types.MedicalRecord> = HashMap.fromIter(medicalRecordsEntries.vals(), 10, Text.equal, Text.hash);

    system func preupgrade() {
        patientsEntries := Iter.toArray(patients.entries());
        doctorsEntries := Iter.toArray(doctors.entries());
        medicalRecordsEntries := Iter.toArray(medicalRecords.entries());

    };

    system func postupgrade() {
        patients := HashMap.fromIter(patientsEntries.vals(), 10, Text.equal, Text.hash);
        patientsEntries := [];
        doctors := HashMap.fromIter(doctorsEntries.vals(), 10, Text.equal, Text.hash);
        doctorsEntries := [];
        medicalRecords := HashMap.fromIter(medicalRecordsEntries.vals(), 10, Text.equal, Text.hash);
        medicalRecordsEntries := [];
    };

    public shared ({ caller }) func loginPatient(id : Types.PatientID, password : Text) : async Result.Result<Text, Text> {
        await patientLogin.loginPatient(patients, id, password);
    };

    public shared ({ caller }) func loginDoctor(id : Types.DoctorID, password : Text) : async Result.Result<Text, Text> {
        await doctorLogin.loginDoctor(doctors, id, password);
    };

    public shared ({ caller }) func registerPatient(
        id : Types.PatientID,
        name : Text,
        age : Nat,
        address : Text,
        contact : Text,
        insuranceTitle : Text,
        insuranceNumber : Text,
        password : Text,
    ) : async Types.RegistrationResult {
        // Validate required fields
        if (id == "" or name == "" or address == "" or contact == "" or contact.size() < 10 or insuranceTitle == "" or insuranceNumber == "" or password == "" or name.size() <= 3 or insuranceNumber.size() <= 8) {
            return #failure("All fields are required and must not have valid values");
        };

        // Validate age
        if (age == 0) {
            return #failure("Age must be greater than 0");
        };

        // If validations pass, proceed with registration

        let insuranceDetails = {
            title = insuranceTitle;
            number = insuranceNumber;
        };
        let patient = {
            id = id;
            name = name;
            age = age;
            address = address;
            contact = contact;
            insuranceDetails = insuranceDetails;
            password = Hashing.hashPassword(password);
        };
        await PatientRegistration.registerPatient(patients, patient);
    };

    public shared ({ caller }) func registerDoctor(
        id : Types.DoctorID,
        name : Text,
        age : Nat,
        address : Text,
        contact : Text,
        email : Text,
        hospitalName : Text,
        hospitalLocation : Text,
        specialization : Text,
        password : Text,
    ) : async Types.RegistrationResult {
        // Validate required fields
        if (id == "" or name == "" or address == "" or contact == "" or email == "" or specialization == "" or password == "") {
            return #failure("All fields are required");
        };

        // Validate age
        if (age == 0) {
            return #failure("Age must be greater than 0");
        };

        let hptlDetails = {
            name = hospitalName;
            location = hospitalLocation;
        };
        let doctor = {
            id = id;
            name = name;
            age = age;
            address = address;
            contact = contact;
            email = email;
            hospital = hptlDetails;
            specialization = specialization;
            password = Hashing.hashPassword(password);
        };
        await DoctorRegistration.registerDoctor(doctors, doctor);
    };

    public shared ({ caller }) func getPatient(id : Types.PatientID, token : Text) : async Result.Result<Types.Patient, Text> {
        await PatientRegistration.getPatient(patients, sessionManager, id, token);
    };

    public shared ({ caller }) func getDoctor(id : Types.DoctorID, token : Text) : async Result.Result<Types.Doctor, Text> {
        await DoctorRegistration.getDoctor(doctors, sessionManager, id, token);
    };

    public shared ({ caller }) func getAllPatients(token : Text) : async Result.Result<[Types.Patient], Text> {
        switch (sessionManager.getSession(token)) {
            case (null) {
                #err("Invalid or expired session");
            };
            case (?session) {
                switch (doctors.get(session.userId)) {
                    case (null) {
                        #err("Unauthorized access. Only doctors can retrieve all patients.");
                    };
                    case (?_doctor) {
                        let patientList = Iter.toArray(patients.vals());
                        #ok(patientList);
                    };
                };
            };
        };
    };

    public shared ({ caller }) func searchPatients(token : Text, searchTerm : Text) : async Result.Result<[Types.Patient], Text> {
        switch (sessionManager.getSession(token)) {
            case (null) {
                #err("Invalid or expired session");
            };
            case (?session) {
                switch (doctors.get(session.userId)) {
                    case (null) {
                        #err("Unauthorized access. Only doctors can search patients.");
                    };
                    case (?_doctor) {
                        let matchingPatients = Iter.toArray(
                            Iter.filter(
                                patients.vals(),
                                func(patient : Types.Patient) : Bool {
                                    Text.contains(patient.name, #text searchTerm) or Text.contains(patient.id, #text searchTerm) or Text.contains(patient.address, #text searchTerm) or Text.contains(patient.contact, #text searchTerm);
                                },
                            )
                        );
                        #ok(matchingPatients);
                    };
                };
            };
        };
    };

    public shared ({ caller }) func addMedicalRecord(
        token : Text,
        patientId : Types.PatientID,
        medicalHistory : Text,
        symptoms : [Text],
        diagnoses : [Text],
        prescriptions : [Text],
        treatmentPlan : Text,
    ) : async Result.Result<Text, Text> {
        // Check if the patient is registered
        switch (patients.get(patientId)) {
            case (null) { return #err("Patient not found") };
            case (?_patient) {
                return await MedicalRecords.addMedicalRecord(
                    medicalRecords,
                    token,
                    patientId,
                    medicalHistory,
                    symptoms,
                    diagnoses,
                    prescriptions,
                    treatmentPlan,
                    sessionManager,
                    doctors,
                );
            };
        };
    };

    public shared ({ caller }) func getPatientRecords(token : Text, patientId : Types.PatientID) : async Result.Result<[Types.MedicalRecord], Text> {
        switch (sessionManager.getSession(token)) {
            case (null) {
                return #err("Invalid session. Please log in.");
            };
            case (?session) {
                // Verify that the caller matches the session owner
                if (session.userId != patientId) {
                    return #err("Session mismatch. Please log in again.");
                };

                // Check if the patient exists and matches the session owner
                switch (patients.get(patientId)) {
                    case (null) {
                        return #err("Patient not found");
                    };
                    case (?_patient) {
                        // Verify that the patient ID matches the session owner
                        if (patientId != session.userId) {
                            return #err("You can only access your own records");
                        };

                        // Patient exists and is authorized, now fetch their records
                        let patientRecords = MedicalRecords.getRecordsForPatient(medicalRecords, patientId);

                        // Check if any records were found
                        if (patientRecords.size() == 0) {
                            return #err("No medical records found for this patient");
                        } else {
                            return #ok(patientRecords);
                        };
                    };
                };
            };
        };
    };
};
