import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";

module {
    public type Role = { #Patient; #Doctor; #Researcher };

    public type User = {
        id : Principal;
        name : Text;
        role : Role;
    };

    public type HealthRecord = {
        patientId : Principal;
        doctorId : Principal;
        record : Text;
        timestamp : Int;
    };

    public type Records = HashMap.HashMap<Principal, [HealthRecord]>;

    public type Users = HashMap.HashMap<Principal, User>;


};
