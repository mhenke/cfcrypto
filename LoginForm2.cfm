<script type="text/javascript" language="javascript"  src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
<script type="text/javascript" language="javascript"  src="http://hashmask.googlecode.com/svn/trunk/jquery.sha1.js"></script>

<cfset crypto = createObject('component', 'Crypto') />

<style>body{font-family:courier new}</style>
<div align="center">
	<h3>Example Login Form 2</h3>
	<p>This demonstrates authentication using AJAX and sending a passsword digest using a random salt.</p>
	<p>This technique is for protecting the password in the users' browser’s memory and also transmitt the password to the server instead of as clear text. The technique is described in <a href="http://www.codeotaku.com/blog/2009-10/secure-login-using-ajax/index">Secure login using AJAX</a>.
	<p>
		<ul>
			<li><a href="http://www.plynt.com/blog/2006/06/sending-salted-hashes-just-got/">Sending salted hashes just got more tricky</a></li>			
			<li><a href="http://www.plynt.com/blog/2005/07/searching-memory-for-secrets-w/">Searching Memory for Secrets with WinHex</a></li>
		</ul>
	</p>
	<form name="myform" action="LoginAction.cfm" method="post" onsubmit="javascript:updateLoginHash(); return false;">
		Username: <input type="text" id="username" name="username" value="admin" /> <br />
		Password: <input type="text" id="password" name="password" value="password" /> <br />
		<input  type="hidden" id="password_hash" name="password_hash" /><br />
		
		<input type="submit" />
		<p>To facilitate testing:</p>
		<p>
			<ul>
				<li>Password field above is "open"</li>
			</ul>	
		</p>
	</form>
	<p><a href="AddUserForm.cfm">Try Add User?</a></p>
</div>

<script type="text/javascript">
function updateLoginHash() {
	$.ajax({
		url: "login_salt.cfm",
		type: 'GET',
		async: false,
		cache: false,
		success: function(login_salt) {
			password = $.sha1($('#password').val());
			$('#password').val('');
			$('#password_hash').val($.sha1(password+login_salt));
		}
	});
	
	document.myform.submit();
}
</script>