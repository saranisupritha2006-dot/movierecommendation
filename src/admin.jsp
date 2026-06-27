<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%
if(session.getAttribute("login")==null)
{
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Poppins',sans-serif;
}

body{
    background:#eef2f7;
}

.header{

    width:100%;
    background:#243B55;
    color:white;
    padding:20px 50px;

    display:flex;
    justify-content:space-between;
    align-items:center;

}

.header h1{
    font-size:28px;
}

.logout{

    background:#dc3545;
    color:white;
    padding:10px 20px;
    border-radius:8px;
    text-decoration:none;
    transition:.3s;

}

.logout:hover{
    background:#b52a37;
}

.container{

    width:90%;
    margin:40px auto;

}

.welcome{

    text-align:center;
    margin-bottom:40px;

}

.welcome h2{

    color:#243B55;
    margin-bottom:10px;

}

.welcome p{

    color:#666;

}

.dashboard{

    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(280px,1fr));
    gap:30px;

}

.card{

    background:white;
    border-radius:15px;
    padding:35px;
    text-align:center;
    box-shadow:0 10px 25px rgba(0,0,0,.15);
    transition:.3s;

}

.card:hover{

    transform:translateY(-8px);

}

.card h2{

    color:#243B55;
    margin-bottom:15px;

}

.card p{

    color:#666;
    margin-bottom:25px;

}

.card a{

    text-decoration:none;

}

.btn{

    background:#243B55;
    color:white;
    padding:12px 30px;
    border:none;
    border-radius:8px;
    cursor:pointer;
    font-size:15px;
    transition:.3s;

}

.btn:hover{

    background:#141E30;

}

.footer{

    margin-top:60px;
    text-align:center;
    color:#777;
    padding-bottom:20px;

}

</style>

</head>

<body>

<div class="header">

<h1>Movie Recommendation System</h1>

<a href="logout.jsp" class="logout">
Logout
</a>

</div>

<div class="container">

<div class="welcome">

<h2>Administrator Dashboard</h2>

<p>
Manage movies, ratings and recommendation system from one place.
</p>

</div>

<div class="dashboard">

<div class="card">

<h2>Add Movies</h2>

<p>
Add new movies into the database and manage movie information.
</p>

<a href="addMovie.jsp">
<button class="btn">
Open
</button>
</a>

</div>

<div class="card">

<h2>Movie Ratings</h2>

<p>
View all available movies along with their ratings.
</p>

<a href="ratings.jsp">
<button class="btn">
Open
</button>
</a>

</div>

<div class="card">

<h2>Recommendations</h2>

<p>
View the recommendation engine and test movie suggestions.
</p>

<a href="recommendation.jsp">
<button class="btn">
Open
</button>
</a>

</div>

</div>

</div>

<div class="footer">

Movie Recommendation System | Admin Panel

</div>

</body>
</html>