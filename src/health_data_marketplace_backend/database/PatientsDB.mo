import Types "../types/Types";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";

module {
    public func initPatientsDB(): Types.Patients {
        HashMap.HashMap<Types.PatientID, Types.Patient>(20, Text.equal, Text.hash);
    };
}
