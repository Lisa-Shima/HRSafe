import Types "../types/Types";
import Result "mo:base/Result";
import SessionManager "SessionManager";
import Text "mo:base/Text";

module {
    public func registerDoctor(
        doctors : Types.Doctors,
        doctor : Types.Doctor,
    ) : async Types.RegistrationResult {
        switch (doctors.get(doctor.id)) {
            case (null) {
                doctors.put(doctor.id, doctor);
                #success("Doctor registered successfully");
            };
            case (?_) {
                #failure("Doctor already exists");
            };
        };
    };

    public func getDoctor(
        doctors : Types.Doctors,
        sessionManager : SessionManager.SessionManager,
        id : Types.DoctorID,
        token : Text,
    ) : async Result.Result<Types.Doctor, Text> {
        switch (sessionManager.getSession(token)) {
            case (null) {
                #err("Invalid or expired session");
            };
            case (?session) {
                if (session.userId != id) {
                    #err("Unauthorized access");
                } else {
                    switch (doctors.get(id)) {
                        case (?doctor) {
                            #ok(doctor);
                        };
                        case (null) {
                            #err("Doctor not found");
                        };
                    };
                };
            };
        };
    };

};
