import Types "../types/Types";
import Text "mo:base/Text";
import Result "mo:base/Result";
import SessionManager "SessionManager";
import Time "mo:base/Time";
import Int "mo:base/Int";
import Iter "mo:base/Iter";

module {

    public func addMedicalRecord(
        medicalRecords : Types.MedicalRecords,
        token : Text,
        patientId : Types.PatientID,
        medicalHistory : Text,
        symptoms : [Text],
        diagnoses : [Text],
        prescriptions : [Text],
        treatmentPlan : Text,
        sessionManager : SessionManager.SessionManager,
        doctors : Types.Doctors,
    ) : async Result.Result<Text, Text> {
        switch (sessionManager.getSession(token)) {
            case (null) {
                #err("Invalid or expired session");
            };
            case (?session) {
                switch (doctors.get(session.userId)) {
                    case (null) {
                        #err("Unauthorized access. Only doctors can add medical records.");
                    };
                    case (?doctor) {
                        let recordId = Text.concat(patientId, Text.concat("-", Int.toText(Time.now())));
                        let newRecord : Types.MedicalRecord = {
                            patientId = patientId;
                            doctorId = doctor.id;
                            date = Int.toText(Time.now());
                            medicalHistory = medicalHistory;
                            symptoms = symptoms;
                            diagnoses = diagnoses;
                            prescriptions = prescriptions;
                            treatmentPlan = treatmentPlan;
                        };
                        medicalRecords.put(recordId, newRecord);
                        #ok("Medical record added successfully");
                    };
                };
            };
        };
    };

    public func getRecordsForPatient(
        medicalRecords : Types.MedicalRecords,
        patientId : Types.PatientID,
    ) : [Types.MedicalRecord] {
        Iter.toArray(
            Iter.filter(
                medicalRecords.vals(),
                func(record : Types.MedicalRecord) : Bool {
                    record.patientId == patientId;
                },
            )
        );
    };
};
