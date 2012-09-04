<style>body{font-family:courier new}</style>
<div align="center">
<h3>Example Login Form</h3>
<p>This demonstrates authentication performed by comparing password hashes (SHA-512) instead of comparing the actual passwords</p>

<form name="myform" action="LoginAction.cfm" method="post">
	<form action="LoginAction.cfm" method="post">
		Username: <input type="text" id="username" name="username" value="admin" /> <br />
		Password: <input type="text" id="password" name="password" value="password" /> <br />
<input type="submit" />

<p>Password field above is "open" to facilitate testing.</p>
</form>
	<p><a href="AddUserForm.cfm">Try Add User?</a></p>
</div>