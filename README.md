fitbuddy-gympass-server
=======================

Sinatra server to generate the iOS Passbook Pass for FitBuddy-GymPass

To generate a sample pass: curl -X POST -H "Content-Type: application/json" -d '{"memberName" : "member_name","memberId" : "member_id","locations" :[{"name" : "loc_name","address" : "loc_address","latitude" : "99.9999","longitude" : "99.9999"}]}' http://<hostname>/fitbuddy/passbook -o passbook.pks

GymPass Resources

POST  /fitbuddy/passbook - Generate a pass
GET   /health  - Return a health status code
POST  /pass-updates/log - Apple reccomended log endpoint
POST  /devices/{device library id}/registrations/{pass type id}/{serial number} - Apple reccomended endpoint to register devices.
DELETE /devices/{device library id}/registrations/{pass type id}/{serial number} - Apple reccomended endpoint to remove devices.
