pragma solidity ^0.4.24;

contract DDC {
    /**
     * User
     *
     * Struct holding the profile deatils of the user.
     */
    struct User {
        uint creationDate;      // date user was created
        string username;        // username of the user
        string description;     // user profile description
        string contact;
        string amount;
        string category;
        address owner;          // address of the account who created the user
        string picture;         // IFPS hash of the user's profile picture
        string[] donations;        // array that holds the user's donations
    }

    /**
     * Maps the hash of a username to the deatils of the user*/
    mapping (bytes32 => User) public users;

    /**
     * owners
     *
     * Maps the address of the owner account to the username hash of the 
     * owned user. This is needed so we can retrieve an account from the
     * current address */
    
    mapping (address => bytes32) public owners;
    
    /**
     * New Donation
     *
     * Event to be emitted once a donation is stored in the contract
     * {bytes32} _from - hashed username of user who posted the donation.
     *                          This field is indexed so it can be filtered.
     * {string} donation - the donation contents
     */
    event NewDonation(
        bytes32 indexed _from,
        string donation,
        uint time
    );

    /**
     * createAccount
     *
     * Creates a user account, storing the user (and user details) in the contract.
     * Additionally, a mapping is created between the owner who created the user
     * {string} username - the username of the user
     * {string} description - the user profile description
     */
    function createAccount(string username, string category,string description,string contact, string amount) public {
        // ensure a null or empty string wasn't passed in
        require(bytes(username).length > 0,"Hello");

        // generate the username hash
        bytes32 usernameHash = keccak256(abi.encodePacked(username));

        // reject if username already registered
        require(users[usernameHash].creationDate == 0,"Hello");

        // reject if sending adddress already created a user
        require(owners[msg.sender] == 0,"Hello");

        
        // add a user to the users mapping and populate details 
        // (creationDate, owner, username, description)

        // add entry to our owners mapping so we can retrieve
        // user by their address
        users[usernameHash].creationDate = now;
        users[usernameHash].owner = msg.sender;
        users[usernameHash].username = username;
        users[usernameHash].category = category;
        users[usernameHash].description = description;
        users[usernameHash].contact = contact;
        users[usernameHash].amount = amount;

        owners[msg.sender] = usernameHash;
        
    }
    /**
     * editAccount
     *
     * Edits the deteails of a user's profile.
     * {bytes32} usernameHash - hashed username of the user to edit
     * {string} description (optional) - the updated user profile description
     */
    function editAccount(bytes32 usernameHash, string description,string contact, string amount, string pictureHash) public {
        // ensure the user exists and that the creator of the user is the
        // sender of the transaction
        require(users[usernameHash].owner == msg.sender,"Owner");

        // update the description (could be empty)
        users[usernameHash].description = description;
        users[usernameHash].contact = contact;
        users[usernameHash].amount = amount;

        // only update the user's picture if the hash passed in is
        // not empty or null (essentially disallows deletions)
        if (bytes(pictureHash).length > 0) {
            users[usernameHash].picture = pictureHash;

        }
    }

    /**
     * userExists
     *
     * Validates whether or not a user has an account in the user mapping
     * {bytes32} usernameHash - the keccak256-hashed username of the user to validate
     * {bool} - returns true if the hashed username exists in the user mapping, false otherwise
     */
    function userExists(bytes32 usernameHash) public view returns (bool) {
        // must check a property... bc solidity!
        return users[usernameHash].creationDate != 0;

        
    }

    /**
     * donation
     *
     * Adds a donation to the user's donations and emits an event notifying listeners
     * that a donation happened. Assumes the user sending the transaction is the owner.
     * {string} content - the donation content
     */
    function donation(string content) public {
        // ensure the sender has an account
        require(owners[msg.sender].length > 0);

        // get the username hash of the sender's account
        bytes32 usernameHash = owners[msg.sender];

        // get our user
        User storage user = users[usernameHash];
        // get our new donation index
        uint donationIndex = user.donations.length++;

        // update the user's donations at the donation index
        user.donations[donationIndex] = content;
        // emit the donation event and notify the listeners
        emit NewDonation(usernameHash, content, now);
    }

}
