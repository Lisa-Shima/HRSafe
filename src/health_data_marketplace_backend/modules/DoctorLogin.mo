import SessionManager "SessionManager";
import Types "../types/Types";
import Result "mo:base/Result";
import Hashing "../utils/Hashing";
module {

    public class DoctorLogin(sessionManager : SessionManager.SessionManager) {
        public func loginDoctor(
            doctors : Types.Doctors,
            id : Types.DoctorID,
            password : Text,
        ) : async Result.Result<Text, Text> {
            switch (doctors.get(id)) {
                case (?doctor) {
                    let storedHash = doctor.password;
                    if (Hashing.verifyPassword(storedHash, password)) {
                        let token = sessionManager.createSession(id);
                        #ok("Login successful. Token: " # token);
                    } else {
                        #err("Invalid password");
                    };
                };
                case (null) {
                    #err("Doctor not found");
                };
            };
        };
    };
}