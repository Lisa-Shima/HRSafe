import Types "../types/Types";
import Result "mo:base/Result";
import SessionManager "SessionManager";

module {
    public func registerPatient(
        patients : Types.Patients,
        patient : Types.Patient,
    ) : async Types.RegistrationResult {
        switch (patients.get(patient.id)) {
            case (null) {
                patients.put(patient.id, patient);
                #success("Patient registered successfully");
            };
            case (?_) {
                #failure("Patient already exists");
            };
        };
    };

    public func getPatient(
        patients : Types.Patients,
        sessionManager : SessionManager.SessionManager,
        id : Types.PatientID,
        token : Text,
    ) : async Result.Result<Types.Patient, Text> {
        switch (sessionManager.getSession(token)) {
            case (null) {
                #err("Invalid or expired session");
            };
            case (?session) {
                if (session.userId != id) {
                    #err("Unauthorized access");
                } else {
                    switch (patients.get(id)) {
                        case (?patient) {
                            #ok(patient);
                        };
                        case (null) {
                            #err("Patient not found");
                        };
                    };
                };
            };
        };
    };
};
