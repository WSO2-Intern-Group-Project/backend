import ballerinax/mysql;
import ballerinax/mysql.driver as _;

configurable readonly & DatabaseConfig databaseConfig = ?;

// create the database client with configureable credentials
final mysql:Client dbClient = check new (
    host = databaseConfig.host, user = databaseConfig.user, password = databaseConfig.password, port = databaseConfig.port, database = databaseConfig.name
);

