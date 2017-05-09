#!/bin/bash
mongodb-runner start
parse-dashboard --appId PARSE_APPLICATION_ID --masterKey PARSE_MASTER_KEY --serverURL "http://localhost:1337/parse" &
VERBOSE='1' parse-server --appId PARSE_APPLICATION_ID --masterKey PARSE_MASTER_KEY --databaseURI mongodb://localhost/parse 
