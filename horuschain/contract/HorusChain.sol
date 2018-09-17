pragma solidity ^0.4.24;

contract horuschain{
    
    struct users{
        string password;
        uint8 Utype;
    }
    
    struct patients {
        string name;
        string dob;
        uint8 sex;
        string addr;
        string phone;
    }
    
    struct prescriptions {
        string date;
        string medicine;
        string times;
        string doctorId; 
        string note;
    }
    
    struct testReports {
        string date;
        string name;
        string result;
        string doctorId;
        string note;
    }
    
    struct diagonoses {
        string date;
        string result;
        string doctorId;
        string note;
    }
    
    struct doctors {
        string name;
        string designation;
        string qualification;
    }
    
    struct requests {
        address patient;
        address doctor;
        string date;
        uint8 permission; 
        uint8 stus;
        /*
            0 -> Not processed
            1 -> Rejected
            2 -> Accepted
        */
    }
    
    struct acceptance{
        string date;
        uint8 strength; // if 2 or more, access the account
        uint8 permitted;
        
    }
    
    //mapping
    mapping(string => users) user;
    mapping(string => address) gethAddress;
    
    mapping(address => patients) patient;
    
    mapping(address => doctors) doctor;
    
    mapping(address => mapping (uint => address)) patientIce;
    mapping(address => uint) patientIceCount;
    
    mapping(address => mapping(uint => prescriptions)) prescription;
    mapping(address => uint) prescriptionCount;
    
    mapping(address => mapping(uint => testReports)) testReport;
    mapping(address => uint) testReportCount;
    
    mapping(address => mapping(uint => diagonoses)) diagonosis;
    mapping(address => uint) diagonosisCount;
    
    mapping(string => address) biometric;
    
    mapping(address => mapping(uint => requests)) request; //ice(in case of emergency) => count => request [for approval]
    mapping(address => uint) requestCount;
    
    mapping(address => mapping(address => acceptance)) accepted; //doctor => patient => acceptance
    
    //functions
    //Data Seting Function
    function createPatient(address _patientAddress, string _usersname, string _password, string _name, string _dob, uint8 _sex, string _addr, string _phone) public {
        gethAddress[_usersname] = _patientAddress;
        
        user[_usersname].password = _password;
        user[_usersname].Utype = 0;
        
        patient[_patientAddress].name = _name;
        patient[_patientAddress].dob = _dob;
        patient[_patientAddress].sex = _sex;
        patient[_patientAddress].addr = _addr;
        patient[_patientAddress].phone = _phone;
    }
    
    function createBiometric(address _patientAddress, string lf1, string lf2, string lf3, string lf4,string lf5, string rf1, string rf2, string rf3, string rf4, string rf5) public {
        biometric[lf1] = _patientAddress;
        biometric[lf2] = _patientAddress;
        biometric[lf3] = _patientAddress;
        biometric[lf4] = _patientAddress;
        biometric[lf5] = _patientAddress;
        
        biometric[rf1] = _patientAddress;
        biometric[rf2] = _patientAddress;
        biometric[rf3] = _patientAddress;
        biometric[rf4] = _patientAddress;
        biometric[rf5] = _patientAddress;
    }
    
    function createDoctor(address _doctorAddress, string _usersname, string _password,string _name, string _designation, string _qualification) public {
        gethAddress[_usersname] = _doctorAddress;
        
        user[_usersname].password = _password;
        user[_usersname].Utype = 1;
        
        doctor[_doctorAddress].name = _name;
        doctor[_doctorAddress].designation = _designation;
        doctor[_doctorAddress].qualification = _qualification;
    }
    
    function createPatientICE(address _patientAddress, string _iceUserId) public {
        uint count = patientIceCount[_patientAddress];
        
        patientIce[_patientAddress][count] = gethAddress[_iceUserId];
        
        patientIceCount[_patientAddress]++;
    }
    
    function createPrescription(address _patientAddress, string _date, string _medicine, string _times, string _doctorId, string _note) public{
        uint count = prescriptionCount[_patientAddress];
        
        prescription[_patientAddress][count].date = _date;
        prescription[_patientAddress][count].medicine = _medicine;
        prescription[_patientAddress][count].times = _times;
        prescription[_patientAddress][count].doctorId = _doctorId;
        prescription[_patientAddress][count].note = _note;
        
        prescriptionCount[_patientAddress]++;
    }
    
    function createTestReport(address _patientAddress, string _date, string _name, string _result, string _doctorId, string _note) public {
        uint count = testReportCount[_patientAddress];
        
        testReport[_patientAddress][count].name = _name;
        testReport[_patientAddress][count].date = _date;
        testReport[_patientAddress][count].result = _result;
        testReport[_patientAddress][count].doctorId = _doctorId;
        testReport[_patientAddress][count].note = _note;
        
        testReportCount[_patientAddress]++;
    }
    
    function createDiagonosis(address _patientAddress, string _date, string _result, string _doctorId, string _note) public {
        uint count = diagonosisCount[_patientAddress];
        
        diagonosis[_patientAddress][count].date = _date;
        diagonosis[_patientAddress][count].result = _result;
        diagonosis[_patientAddress][count].doctorId = _doctorId;
        diagonosis[_patientAddress][count].note = _note;
        
        diagonosisCount[_patientAddress]++;
    }
    
    function createRequest(address _iceAddress, address _patientAddress, address _doctorAddress, string _date, uint8 _permission, uint8 _status) public {
        uint count = requestCount[_iceAddress];
        
        request[_iceAddress][count].patient = _patientAddress;
        request[_iceAddress][count].doctor = _doctorAddress;
        request[_iceAddress][count].date = _date;
        request[_iceAddress][count].permission = _permission;
        request[_iceAddress][count].stus = _status;
        
        requestCount[_iceAddress]++;
    }
    
    function setAcceptance(address _doctorAddress, address _patientAddress, string _date, uint8 _strength, uint8 _permitted) public {
        accepted[_doctorAddress][_patientAddress].date = _date;
        accepted[_doctorAddress][_patientAddress].strength = _strength;
        accepted[_doctorAddress][_patientAddress].permitted = _permitted;
    }
    
     //Update Function
    function updateRequestStatus(address _iceAddress, uint _requestCount, uint8 statusCode) public {
        request[_iceAddress][_requestCount].stus = statusCode;
    }
    
    //Data Geting Function
    function getAccounts(string _usersname) public constant returns(string _password, uint8 _Utype, address _gethAddress) {
        return(user[_usersname].password, user[_usersname].Utype, gethAddress[_usersname]);
    }
    
    function getPatientFromBiometric(string finger1, string finger2) public constant returns (address _patientAddress){
        if(biometric[finger1] == biometric[finger2]){
            return biometric[finger1];
        }
        else {
            return 0x0;
        }
    }
    
    function getPatientIceCount(address _patientAddress) public constant returns (uint _count){
        return patientIceCount[_patientAddress];
    }
    
    function getPatientIce(address _patientAddress, uint _patientIceCount) public constant returns(address _iceAddress){
        return patientIce[_patientAddress][_patientIceCount];
    }
    
    function getPatient(address _patientAddress) public constant returns(string _name, string _dob, uint8 _sex, string _addr, string _phone) {
        return (patient[_patientAddress].name, patient[_patientAddress].dob, patient[_patientAddress].sex, patient[_patientAddress].addr, patient[_patientAddress].phone);
    }
    
    function getDoctor(address _doctorAddress) public constant returns(string _name, string _designation, string _qualification) {
        return (doctor[_doctorAddress].name, doctor[_doctorAddress].designation, doctor[_doctorAddress].qualification);
    }
    
    function getPrescriptionCount(address _patientAddress) public constant returns (uint _count){
        return prescriptionCount[_patientAddress];
    }
    
    function getPrescription(address _patientAddress, uint _prescriptionCount) public constant returns(string _date, string _medicine, string _times, string _doctorId, string _note){
        return (prescription[_patientAddress][_prescriptionCount].date, prescription[_patientAddress][_prescriptionCount].medicine, prescription[_patientAddress][_prescriptionCount].times, prescription[_patientAddress][_prescriptionCount].doctorId, prescription[_patientAddress][_prescriptionCount].note);
    }
    
    function getTestReportCount(address _patientAddress) public constant returns(uint _count) {
        return testReportCount[_patientAddress];
    }
    
    function getTestReport(address _patientAddress, uint _testReportCount) public constant returns(string _date, string _name, string _result, string _doctorId, string _note) {
        return (testReport[_patientAddress][_testReportCount].date, testReport[_patientAddress][_testReportCount].name, testReport[_patientAddress][_testReportCount].result, testReport[_patientAddress][_testReportCount].doctorId, testReport[_patientAddress][_testReportCount].note);
    }
    
    function getDiagonosisCount(address _patientAddress) public constant returns(uint _count) {
        return diagonosisCount[_patientAddress];
    }
    
    function getDiagonosis(address _patientAddress, uint _diagonosisCount) public constant returns(string _date, string _result, string _doctorId, string _note) {
        return (diagonosis[_patientAddress][_diagonosisCount].date, diagonosis[_patientAddress][_diagonosisCount].result, diagonosis[_patientAddress][_diagonosisCount].doctorId, diagonosis[_patientAddress][_diagonosisCount].note);
    }
    
    function getRequestCount(address _iceAddress) public constant returns(uint _requestCount) {
        return requestCount[_iceAddress];
    }
    
    function getRequest(address _iceAddress, uint _requestCount) public constant returns(address _patientAddress, address _doctorAddress, string _date, uint8 _permission, uint8 _status) {
        return(request[_iceAddress][_requestCount].patient, request[_iceAddress][_requestCount].doctor, request[_iceAddress][_requestCount].date, request[_iceAddress][_requestCount].permission, request[_iceAddress][_requestCount].stus);
    }
    
    function getAcceptance(address _doctorAddress, address _patientAddress) public constant returns (string _date, uint8 _strength, uint8 _permitted) {
        return (accepted[_doctorAddress][_patientAddress].date, accepted[_doctorAddress][_patientAddress].strength, accepted[_doctorAddress][_patientAddress].permitted);
    }

}
