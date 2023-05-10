# Database configuration.
# 
# + host - Database Host 
# + user - Database User  
# + password - Database Password
# + name - Database Name 
# + port - Database Port
public type DatabaseConfig record {
    string host;
    string user;
    string password;
    string name;
    int port;
};
