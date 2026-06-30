
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
<meta charset="UTF-8">
<title>Movie Ratings</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Poppins,sans-serif;
}

body{
    background:#edf2f7;
}

.container{
    width:90%;
    max-width:1200px;
    margin:auto;
    padding:30px;
}

.header{
    background:linear-gradient(135deg,#243B55,#141E30);
    color:white;
    padding:30px;
    border-radius:15px;
    text-align:center;
    box-shadow:0 8px 20px rgba(0,0,0,0.2);
}

.header h1{ font-size:32px; margin-bottom:8px; }
.header p{ font-size:15px; opacity:0.8; }

.back-link{
    display:inline-block;
    margin-top:15px;
    text-decoration:none;
}

.section-title{
    color:#243B55;
    margin:35px 0 15px;
    font-size:22px;
    border-left:5px solid #243B55;
    padding-left:12px;
}

.sort-row{
    display:flex;
    align-items:center;
    gap:12px;
    margin-bottom:25px;
    flex-wrap:wrap;
}

.sort-row select{
    appearance:none;
    -webkit-appearance:none;
    padding:12px 40px 12px 18px;
    border-radius:25px;
    border:1px solid #dfe4ea;
    font-family:Poppins,sans-serif;
    font-size:13px;
    font-weight:500;
    color:#243B55;
    background:white url("data:image/svg+xml;charset=UTF-8,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' width='14' height='14'%3E%3Cpath fill='%23243B55' d='M7 10l5 5 5-5z'/%3E%3C/svg%3E") no-repeat right 16px center;
    box-shadow:0 3px 10px rgba(0,0,0,0.06);
    cursor:pointer;
    transition:.25s;
    min-width:200px;
}

.sort-row select:hover{
    border-color:#243B55;
    box-shadow:0 5px 14px rgba(36,59,85,0.12);
}

.sort-row select:focus{
    outline:none;
    border-color:#243B55;
    box-shadow:0 0 0 3px rgba(36,59,85,0.1);
}

.ratings-table{
    background:white;
    border-radius:15px;
    box-shadow:0 5px 15px rgba(0,0,0,0.10);
    overflow:hidden;
}

table{
    width:100%;
    border-collapse:collapse;
}

th, td{
    padding:16px 20px;
    text-align:left;
}

th{
    background:#243B55;
    color:white;
    font-size:13px;
    text-transform:uppercase;
    letter-spacing:0.5px;
}

tr:nth-child(even) td{
    background:#f8f9fa;
}

td{
    font-size:14px;
    color:#333;
}

.poster-cell{
    display:flex;
    align-items:center;
    gap:12px;
}

.poster-cell img{
    width:45px;
    height:60px;
    object-fit:cover;
    border-radius:6px;
}

.poster-cell .no-img{
    width:45px;
    height:60px;
    border-radius:6px;
    background:linear-gradient(135deg,#243B55,#141E30);
}

.badge{
    padding:3px 12px;
    border-radius:20px;
    font-size:11px;
    font-weight:600;
    background:#e8f0fe;
    color:#243B55;
}

.stars{
    color:#f5a623;
    font-size:14px;
}

.no-results{
    text-align:center;
    padding:50px;
    color:#888;
}

.btn{
    border:none;
    padding:10px 20px;
    border-radius:20px;
    cursor:pointer;
    font-size:14px;
    font-family:Poppins,sans-serif;
    font-weight:600;
}

.btn-primary{ background:#243B55; color:white; }
.btn-primary:hover{ background:#141E30; }

</style>
</head>

<body>
<div class="container">

    <div class="header">
        <h1>Movie Ratings</h1>
        <p>See how every movie is rated</p>
        <a href="user.jsp" class="back-link">
            <button class="btn btn-primary" type="button">Back to Home</button>
        </a>
    </div>

    <%
    String dbHost = System.getenv("MYSQLHOST") != null ? System.getenv("MYSQLHOST") : "localhost";
    String dbPort = System.getenv("MYSQLPORT") != null ? System.getenv("MYSQLPORT") : "3306";
    String dbName = System.getenv("MYSQLDATABASE") != null ? System.getenv("MYSQLDATABASE") : "moviedb";
    String dbUser = System.getenv("MYSQLUSER") != null ? System.getenv("MYSQLUSER") : "root";
    String dbPass = System.getenv("MYSQLPASSWORD") != null ? System.getenv("MYSQLPASSWORD") : "";
    String dbUrl = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName;
    Connection con = DriverManager.getConnection(dbUrl, dbUser, dbPass);

    String sortBy = request.getParameter("sort");
    if(sortBy == null) sortBy = "rating_desc";

    String orderClause;
    if(sortBy.equals("rating_asc"))      orderClause = "ORDER BY rating ASC";
    else if(sortBy.equals("name_asc"))   orderClause = "ORDER BY name ASC";
    else if(sortBy.equals("name_desc"))  orderClause = "ORDER BY name DESC";
    else                                  orderClause = "ORDER BY rating DESC";
    %>

    <h2 class="section-title">All Movies</h2>

    <div class="sort-row">
        <form method="get" id="sortForm">
            <select name="sort" onchange="document.getElementById('sortForm').submit();">
                <option value="rating_desc" <%= sortBy.equals("rating_desc") ? "selected" : "" %>>Highest Rated</option>
                <option value="rating_asc" <%= sortBy.equals("rating_asc") ? "selected" : "" %>>Lowest Rated</option>
                <option value="name_asc" <%= sortBy.equals("name_asc") ? "selected" : "" %>>Name A-Z</option>
                <option value="name_desc" <%= sortBy.equals("name_desc") ? "selected" : "" %>>Name Z-A</option>
            </select>
        </form>
    </div>

    <%
    PreparedStatement rateStmt = con.prepareStatement(
        "SELECT name, genre, rating, image_url FROM movies " + orderClause
    );
    ResultSet rateRs = rateStmt.executeQuery();
    boolean found = false;
    %>

    <div class="ratings-table">
    <table>
        <tr>
            <th>Movie</th>
            <th>Genre</th>
            <th>Rating</th>
        </tr>

        <%
        while(rateRs.next())
        {
            found = true;
            String mName   = rateRs.getString("name");
            String mGenre  = rateRs.getString("genre");
            double mRating = rateRs.getDouble("rating");
            String mImg    = rateRs.getString("image_url");

            int fullStars = (int) Math.round(mRating);
            String starStr = "";
            for(int s = 0; s < fullStars; s++)  starStr += "★";
            for(int s = fullStars; s < 5; s++)  starStr += "☆";
        %>
        <tr>
            <td>
                <div class="poster-cell">
                    <% if(mImg != null && !mImg.trim().isEmpty()) { %>
                        <img src="<%= mImg %>" alt="<%= mName %>"
                             onerror="this.style.display='none';this.nextElementSibling.style.display='block';">
                        <div class="no-img" style="display:none;"></div>
                    <% } else { %>
                        <div class="no-img"></div>
                    <% } %>
                    <strong><%= mName %></strong>
                </div>
            </td>
            <td><span class="badge"><%= mGenre %></span></td>
            <td>
                <span class="stars"><%= starStr %></span>
                &nbsp;<%= mRating %> / 5
            </td>
        </tr>
        <%
        }
        rateRs.close();
        rateStmt.close();
        %>

    </table>
    </div>

    <% if(!found) { %>
    <div class="no-results">
        <h3>No movies found.</h3>
    </div>
    <% } %>

    <%
    con.close();
    %>

</div>
</body>
</html>