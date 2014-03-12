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
  passbook = getPassport(params)
  response['Content-Type'] = 'application/vnd.apple.pkpass'
  attachment 'FitBuddy-GymPass.pkpass'
  passbook.stream.string
end

post '/fitbuddy/passbook' do
  params = JSON.parse request.body.read
  passbook = getPassport(params)
  response['Content-Type'] = 'application/vnd.apple.pkpass'
  attachment 'FitBuddy-GymPass.pkpass'
  passbook.stream.string
end

get '/health' do
  "the time where this server lives is #{Time.now}
    <br /><br />check out your <a href=\"/agent\">user_agent</a>"
end

get '/agent' do
  "you're using #{request.user_agent}"
end

def getPassport(params)

  memberName = params["memberName"]
  memberId = params["memberId"]
  locationName = params["locationName"]
  locationAddress = params["locationAddress"]
  locationLat = params["locationLat"]
  locationLon = params["locationLon"]

  file = File.open(PassbookConfig.pass_dir + '/pass.json')
  json = file.read

  json = json.gsub("__memberName__", memberName)
  json = json.gsub("__memberId__", memberId)
  json = json.gsub("__locationName__", locationName)
  json = json.gsub("__locationAddress__", locationAddress)
  json = json.gsub("__locationLat__", locationLat)
  json = json.gsub("__locationLon__", locationLon)

  passbook = Passbook::PKPass.new json
  passbook.addFiles [PassbookConfig.pass_dir + '/logo.png', PassbookConfig.pass_dir + '/logo@2x.png', PassbookConfig.pass_dir + '/icon.png', PassbookConfig.pass_dir + '/icon@2x.png']

  return passbook

end
