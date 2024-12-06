import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Types "../types/Types";

module {

    public func encryptData(data : Text) : Text {
        return Text.concat(data, "_encrypted");
    };

    public func decryptData(data : Text) : Text {
        let encryptedSuffix = "_encrypted";
        if (Text.endsWith(data, #text encryptedSuffix)) {
            let parts = Iter.toArray(Text.split(data, #text encryptedSuffix));

            return parts[0];
        } else {
            return data;
        };
    };

    public func hasAccess(userRole : Types.Role, requiredRole : Types.Role) : Bool {
        return userRole == requiredRole;
    };
};
