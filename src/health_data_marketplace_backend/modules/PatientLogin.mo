import Text "mo:base/Text";
import Result "mo:base/Result";
import Hashing "../utils/Hashing";
import SessionManager "../modules/SessionManager";
import Types "../types/Types";

module {
    public class PatientLogin(sessionManager : SessionManager.SessionManager) {
        public func loginPatient(
            patients : Types.Patients,
            id : Types.PatientID,
            password : Text,
        ) : async Result.Result<Text, Text> {
            switch (patients.get(id)) {
                case (?patient) {
                    let storedHash = patient.password;
                    if (Hashing.verifyPassword(storedHash, password)) {
                        let token = sessionManager.createSession(id);
                        #ok("Login successful. Token: " # token);
                    } else {
                        #err("Invalid password");
                    };
                };
                case (null) {
                    #err("Patient not found");
                };
            };
        };
    };
};
