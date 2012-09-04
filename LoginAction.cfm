<!--- 
	def login
		@title = "Mail Administration Login"
	
		if request.post?
			account = MailAccount.with_address(request[:username])
			success = false
		
			if account
				Ramaze::Log.info "Authenticating account #{account.name}..."

				if request[:password_hash]
					Ramaze::Log.info "\twith #{request[:password_hash]} and #{session[:login_salt]}"
					success = account.digest_authenticate(request[:password_hash], session[:login_salt])
				elsif request[:password]
					Ramaze::Log.info "\twith #{request[:password]}"
					success = account.plaintext_authenticate(request[:password])
				end
			end
		
			if success
				Ramaze::Log.info "Authentication successful!"
				session[:mail_account] = account.id
				redirect MainController.r(:index)
			end
		
			Ramaze::Log.warn "Authentication failed!"
		end
	end 
--->

	<style>body{font-family:courier new}</style>
	<cfparam name="form.username" default="" />
	<cfparam name="form.password" default="" />
	<cfset setUpUsers() />

<!--------------------------------------------------------------------------------
                        //Begin
 --------------------------------------------------------------------------------->

	<!---// Get the utility object --->
	<cfset crypto = createObject('component' ,'Crypto') />
	<!---// Get user password hash and salt from db --->
	<cfset  user = getUserHash(form.username) />
	
	<div align="center">
		
		<cfif not isdefined("form.PASSWORD_HASH")>
			<!---// Form 1: Hash what was entered in the form using the salt from the target user: --->
			<cfset formPasswordHash = crypto.computeHash(password=form.password,salt=user.salt,iterations=1024) />
			<cfset ourPasswordHash = user.password_hash>
		<cfelse>
			<!---//Form 2: Hash what was entered in the form using the salt from the target user: --->
			<cfset formPasswordHash = form.PASSWORD_HASH />
			<cfset ourPasswordHash = crypto.computeHash( 
										password=crypto.computeHash( password=user.password,algorithm='SHA-1' ),
										salt= session.login_salt,
										algorithm='SHA-1')>
		</cfif>
		
	    <!--- FORM EXAMPLE
	      Onec we have the password hash from the db and the hash from the
	      password entered by the user, we simply compare the 2 strings.
	     --->
		<cfif formPasswordHash.equals(ourPasswordHash)>
		  <strong>Valid User!</strong>
		 <cfelse>
		  <strong style="color:darkred">Invalid User</strong>
		</cfif>
	
	<cfif not isdefined("form.PASSWORD_HASH")>
		<p><a href="LoginForm.cfm">Try Another?</a></p>
	<cfelse>
		<p><a href="LoginForm2.cfm">Try Another?</a></p>
	</cfif>
	
    <p><a href="AddUserForm.cfm">Try Add User Example?</a></p>
  </div>

<!--------------------------------------------------------------------------------
                         //End
 --------------------------------------------------------------------------------->

<p><hr size="1" noshade="true" /></p>
<h4 align="center">Debug Info</h4>

<cfdump var="#form#" label="You submitted the following data:">

<pre>
<cfoutput>
 <strong>formPasswordHash</strong>: #formPasswordHash#<br />
 <strong>ourPasswordHash</strong>:  #ourPasswordHash#<br />
</cfoutput>
</pre>

 <p>Example data. Normally this would be in a database or other persisted store.</p>

<cffunction name="setUpUsers" hint="Just sets a bunch of test users up for testing.">
<cf_querysim>
users
id,username,password,password_hash,salt
1|admin|password|f5e2dd38088bced1d485e167c3a6b3967a9b20eda6aaba7fa48df0c7a04ff14fed98991a53fb15c57e40a4338336bd40933c93a3eaad630114df40b79ad55f49|N6lUg9fdHQsY8A8iJTPygA==
2|jenjen|iloveyou|ddadeb0281ccc6af81363582913b1558ab5accc06d8d762e97ecf31143fbfce3ae98290d3ddce00f2873024d1095532d3815c491c52187a1737f85cc4cda761b|BcNP/J3Y91a9+daj9DrFkQ==
3|blinky|miss4you|8d7c659faf50bdbe942ea9a19e141ad2c44f4aefbf8048f3ca98a300f1b7fbc6022fb8fb5d8cbab63024e18907023eb957fde5ff7a2b3f3f7fad906ae4237e22|lCw/0pHTWQgG2ULj6FxhqA==
4|fabfive|password19|bbc94c1505b020544ec58cadbc64831d2b794cf314b5784b752c25e33c4b3a57472b67049808b055ca43ba2f9e9d2e8cbd5371380bc907896eb9ecc1cbc49430|UTskcZLgCFk/BML6uJKwvA==
5|bushman|ganja|81f3c703bbb6d1148ec71f52e8d6a29555c0e496a79752227d64fa9254168f520adf42f0b802c6cf364c82b423bafb6df922b0d7ccb6f7e8a8074e2b721a4b7f|hUIO43NZfAT62EsiByHBWg==
6|rastapasta|phuckyou|a31312c5c4c9c7249b497f32fdb3c645e8fbaca0c82ea6ede9cf9c30834f21e478f55596cb8f63e13bafb419452e83e2768eab649e1e8cdb084744ec638221fe|eAYWfcEw+X4ky3KnPAt16Q==
7|belladonna|tink69|5ec7464102b5b75846c52be7d4fad00cd9808cd88793ae83f272c219f0c0f30af909fac1b46f2ec5b79d564d040cdfe1a4066ce3936e952dced5bdcabe3fc1af|SX01/9fMu0+nJmlSGGjeag==
</cf_querysim>
</cffunction>

<cfdump var="#users#" label="list of example users.">

<cffunction name="getUserHash">
  <cfargument name="username">
  <cfquery name="q" dbtype="query" maxrows="1">
    select password_hash,salt,password from users where username=<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="24" value="#arguments.username#" />
  </cfquery>
  <cfreturn q />
</cffunction>
<!---
<cfset saltyHash()>
--->
<!--- Util to populate query above --->
<cffunction name="saltyHash">
  	<cfset var salt = ''>
	<textarea cols="200" rows="16">
	<cfoutput query="users">
	 	<cfset salt = crypto.genSalt() />
	 	#id#|#username#|#password#|#crypto.computeHash(password=password,salt=salt,iterations=1024)#|#salt##chr(10)#
	 </cfoutput>
	</textarea>
</cffunction>


