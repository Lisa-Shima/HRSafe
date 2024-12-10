import Text "mo:base/Text";
import Sha256 "mo:sha2/Sha256";
import Blob "mo:base/Blob";
import Nat8 "mo:base/Nat8";

module Hashing {
    private func toHex(hash : [Nat8]) : Text {
        let hexChars = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"];
        var result = "";
        for (byte in hash.vals()) {
            result #= hexChars[Nat8.toNat(byte) / 16] # hexChars[Nat8.toNat(byte) % 16];
        };
        result;
    };

    public func hashPassword(password : Text) : Text {
        let passwordBlob = Text.encodeUtf8(password);
        let hash = Sha256.fromBlob(#sha256, passwordBlob);
        return toHex(Blob.toArray(hash));
    };

    public func verifyPassword(storedHash : Text, password : Text) : Bool {
        return storedHash == hashPassword(password);
    };
};
