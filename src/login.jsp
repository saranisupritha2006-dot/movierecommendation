<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%
String error="";

if(request.getParameter("login")!=null)
{
    String username=request.getParameter("username");
    String password=request.getParameter("password");
    String role=request.getParameter("role");

    if(role.equals("admin") &&
       username.equals("admin") &&
       password.equals("admin123"))
    {
        session.setAttribute("login","admin");
        response.sendRedirect("admin.jsp");
        return;
    }

    else if(role.equals("user") &&
            username.equals("user") &&
            password.equals("user123"))
    {
        session.setAttribute("login","user");
        response.sendRedirect("user.jsp");
        return;
    }

    else
    {
        error="Invalid Username or Password";
    }
}
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>Movie Recommendation System - Login</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<style>

*{
margin:0;
padding:0;
box-sizing:border-box;
font-family:Poppins,sans-serif;
}

body{

background:linear-gradient(135deg,#141E30,#243B55);

height:100vh;

display:flex;

justify-content:center;

align-items:center;

}

.login-box{

width:420px;

background:white;

padding:40px;

border-radius:20px;

box-shadow:0 10px 30px rgba(0,0,0,.3);

}

h1{

text-align:center;

color:#243B55;

margin-bottom:10px;

}

.subtitle{

text-align:center;

color:gray;

margin-bottom:30px;

}

label{

font-weight:600;

display:block;

margin-bottom:8px;

}

input,select{

width:100%;

padding:14px;

border:1px solid #ccc;

border-radius:10px;

margin-bottom:20px;

font-size:15px;

}

input:focus,
select:focus{

outline:none;

border-color:#243B55;

}

button{

width:100%;

padding:15px;

background:#243B55;

color:white;

font-size:16px;

border:none;

border-radius:10px;

cursor:pointer;

transition:.3s;

}

button:hover{

background:#141E30;

}

.error{

background:#ffe5e5;

color:red;

padding:12px;

border-radius:8px;

margin-bottom:20px;

text-align:center;

}

.footer{

margin-top:20px;

text-align:center;

color:#666;

font-size:14px;

}

</style>

</head>

<body>

<div class="login-box">

<h1>Movie Recommendation System</h1>

<p class="subtitle">

Login to Continue

</p>

<%
if(!error.equals(""))
{
%>

<div class="error">

<%=error%>

</div>

<%
}
%>

<form method="post">

<label>Select Role</label>

<select name="role">

<option value="admin">Admin</option>

<option value="user">User</option>

</select>

<label>Username</label>

<input
type="text"
name="username"
placeholder="Enter Username"
required>

<label>Password</label>

<input
type="password"
name="password"
placeholder="Enter Password"
required>

<button
type="submit"
name="login">

Login

</button>

</form>

<div class="footer">

Movie Recommendation System

</div>

</div>

</body>

</html>