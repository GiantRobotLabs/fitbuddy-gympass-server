fitbuddy-gympass-server
=======================

##Description##

Sinatra server to generate the iOS Passbook Pass for FitBuddy-GymPass


##Generate a sample pass##

<pre>curl -X POST -H "Content-Type: application/json" \
  -d '{"memberName" : "member_name","memberId" : "member_id","locations" :[{"name" : "loc_name","address" : "loc_address","latitude" : "99.9999","longitude" : "99.9999"}]}' \
  -o passbook.pkpass \
  http://evilsushi.giantrobotlabs.com/fitbuddy/passbook</pre>

##GymPass Resources##

_POST_  /fitbuddy/passbook
    
    Generate a pass

_GET_   /health
    
    Return a health status code

_POST_  /pass-updates/log
    
    Apple reccomended log endpoint

_POST_  /devices/{device library id}/registrations/{pass type id}/{serial number}
    
    Apple reccomended endpoint to register devices.

_DELETE_ /devices/{device library id}/registrations/{pass type id}/{serial number}
    
    Apple reccomended endpoint to remove devices.
