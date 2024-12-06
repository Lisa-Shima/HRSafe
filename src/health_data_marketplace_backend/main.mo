import Auth "auth/Auth";
import HealthRecord "records/HealthRecord";
import TimeUtils "utils/TimeUtils";
import Types "types/Types";
import Result "mo:base/Result";
import Time "mo:base/Time";

actor {
    private var users = Auth.createUsers();
    private var records = HealthRecord.createRecords();

    // Expose Authentication Functions
    public func register(user: Types.User) : async Result.Result<Text, Text> {
        await Auth.registerUser(users, user)
    };

    public func login(principal: Principal) : async Result.Result<Types.User, Text> {
        await Auth.loginUser(users, principal)
    };

    // Expose Health Record Functions
    public func addHealthRecord(record: Types.HealthRecord) : async Result.Result<Text, Text> {
        await HealthRecord.addRecord(records, record)
    };

    public func getHealthRecords(patientId: Principal) : async [Types.HealthRecord] {
        await HealthRecord.getRecords(records, patientId)
    };

    // Utility Example
    public func getCurrentTimestamp() : async Text {
        TimeUtils.formatTimestamp(Time.now())
    };
}