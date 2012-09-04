<cfsetting showDebugOutput="No">
<cfcontent reset="true" type="application/json" />
<!---  response["Content-Type"] = 'application/json' --->
<cfset crypto = createObject('component', 'Crypto') />

<!--- for coldfusion to use on login action --->
<cfset session.login_salt = crypto.genSalt()>

<!--- for javascript / ajax call --->
<cfoutput>#SerializeJSON(session.login_salt)#</cfoutput>