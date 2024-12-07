import Auth "auth/Auth";
import HealthRecord "records/HealthRecord";
import TimeUtils "utils/TimeUtils";
import Types "types/Types";
import Result "mo:base/Result";
import Time "mo:base/Time";
import Principal "mo:base/Principal";

actor {
    private var users = Auth.createUsers();
    private var records = HealthRecord.createRecords();

    // User Module Functions
    public shared({ caller }) func register(name: Text, role: Types.Role) : async Result.Result<Text, Text> {
        let user : Types.User = {
            id = caller;
            name = name;
            role = role;
        };
        await Auth.registerUser(users, user)
    };

    public shared({ caller }) func login() : async Result.Result<Types.User, Text> {
        await Auth.loginUser(users, caller)
    };

    public shared({ caller }) func getRole() : async Result.Result<Types.Role, Text> {
        await Auth.getUserRole(users, caller)
    };

    // Health Record Functions
    public shared({ caller }) func addHealthRecord(record: Types.HealthRecord) : async Result.Result<Text, Text> {
        switch (await Auth.getUserRole(users, caller)) {
            case (#ok(#Doctor)) {
                await HealthRecord.addRecord(records, record)
            };
            case (#ok(_)) {
                #err("Only doctors can add health records")
            };
            case (#err(e)) {
                #err(e)
            };
        }
    };

    public shared({ caller }) func getHealthRecords(patientId: Principal) : async Result.Result<[Types.HealthRecord], Text> {
        switch (await Auth.getUserRole(users, caller)) {
            case (#ok(#Doctor or #Researcher)) {
                #ok(await HealthRecord.getRecords(records, patientId))
            };
            case (#ok(#Patient)) {
                if (caller == patientId) {
                    #ok(await HealthRecord.getRecords(records, patientId))
                } else {
                    #err("Patients can only access their own records")
                }
            };
            case (#err(e)) {
                #err(e)
            };
        }
    };

    // Utility Function
    public func getCurrentTimestamp() : async Text {
        TimeUtils.formatTimestamp(Time.now())
    };
}