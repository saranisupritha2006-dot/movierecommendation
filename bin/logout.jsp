<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%
session.invalidate();
response.setHeader("Refresh","2;URL=login.jsp");
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Logout</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

<style>

*{
margin:0;
padding:0;
box-sizing:border-box;
font-family:'Poppins',sans-serif;
}

body{

height:100vh;

display:flex;

justify-content:center;

align-items:center;

background:linear-gradient(135deg,#141E30,#243B55);

}

.container{

background:white;

padding:50px;

border-radius:15px;

box-shadow:0 10px 25px rgba(0,0,0,.3);

text-align:center;

width:420px;

}

h1{

color:#243B55;

margin-bottom:20px;

}

p{

color:#666;

margin-bottom:30px;

font-size:16px;

}

a{

display:inline-block;

background:#243B55;

color:white;

text-decoration:none;

padding:12px 30px;

border-radius:8px;

transition:.3s;

}

a:hover{

background:#141E30;

}

</style>

</head>

<body>

<div class="container">

<h1>Logged Out Successfully</h1>

<p>

Thank you for using the Movie Recommendation System.

<br><br>

Redirecting to Login Page...

</p>

<a href="login.jsp">

Login Again

</a>

</div>

</body>

</html>