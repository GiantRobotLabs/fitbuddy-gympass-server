require 'sinatra'
require 'passbook'
require 'active_support/json/encoding'
require 'rubygems'
require 'json'

Passbook.configure do |passbook|
  passbook.p12_password = PassbookConfig.password
  passbook.p12_key = PassbookConfig.key
  passbook.p12_certificate = PassbookConfig.cert
  passbook.wwdc_cert = PassbookConfig.dev_cert
end

get '/fitbuddy/passbook' do
  halt(404,"404: No bueno")
end

=begin
POST REQUEST BODY
{
    "memberName" : "member_name"
    "memberId" : "member_id",
    "locations" :[
    {
      "name" : "loc_name",
      "address" : "loc_address",
      "latitude" : 99.9999,
      "longitude" : 99.9999
    }]
}
=end
post '/fitbuddy/passbook' do
  params = JSON.parse request.body.read
  passbook = getPassport(params)
  response['Content-Type'] = 'application/vnd.apple.pkpass'
  attachment 'FitBuddy-GymPass.pkpass'
  passbook.stream.string
end

post '/pass-updates/log' do
  puts("[Error] Description: #{params[:description]}}")
  puts(params)
  halt 200
end

# Register a device to receive push notifications for a pass.
post '/devices/:device_library_identifier/registrations/:pass_type_identifier/:serial_number/?' do
  halt 200
end

# Unregister a device so it no longer receives push notifications for a pass.
delete '/devices/:device_library_identifier/registrations/:pass_type_identifier/:serial_number/?' do
  halt 200
end

get '/health' do
  "the time where this server lives is #{Time.now}
    <br /><br />check out your <a href=\"/agent\">user_agent</a>"
end

get '/agent' do
  halt(200, "you're using #{request.user_agent}")
end

def getPassport(data)

  memberName = data["memberName"]
  memberId = data["memberId"]

  location = data["locations"][0]
  locationName = location ["name"]
  locationAddress = location ["address"]
  locationLat = location ["latitude"]
  locationLon = location ["longitude"]

  file = File.open(PassbookConfig.pass_dir + '/pass.json')
  json = file.read

  json = json.gsub("__memberName__", memberName)
  json = json.gsub("__memberId__", memberId)
  json = json.gsub("__locationName__", locationName)
  json = json.gsub("__locationAddress__", locationAddress)
  json = json.gsub("__locationLat__", locationLat.to_s())
  json = json.gsub("__locationLon__", locationLon.to_s())

  passbook = Passbook::PKPass.new json
  passbook.addFiles [PassbookConfig.pass_dir + '/logo.png', PassbookConfig.pass_dir + '/logo@2x.png', PassbookConfig.pass_dir + '/icon.png', PassbookConfig.pass_dir + '/icon@2x.png']

  return passbook

end
