import Types "../types/Types";
import Result "mo:base/Result";
import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";

module {
    public func createUsers() : Types.Users {
        HashMap.HashMap<Principal, Types.User>(10, Principal.equal, Principal.hash);
    };

    public func registerUser(users : Types.Users, user : Types.User) : async Result.Result<Text, Text> {
        switch (users.get(user.id)) {
            case (null) {
                users.put(user.id, user);
                #ok("User registered successfully");
            };
            case (?_) {
                #err("User already exists");
            };
        };
    };

    public func loginUser(users : Types.Users, principal : Principal) : async Result.Result<Types.User, Text> {
        switch (users.get(principal)) {
            case (?user) {
                #ok(user);
            };
            case (null) {
                #err("User not found");
            };
        };
    };

    public func getUserRole(users : Types.Users, principal : Principal) : async Result.Result<Types.Role, Text> {
        switch (users.get(principal)) {
            case (?user) {
                #ok(user.role);
            };
            case (null) {
                #err("User not found");
            };
        };
    };
};
