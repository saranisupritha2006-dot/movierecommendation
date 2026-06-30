<%@ page import="java.sql.*" %>

<html>
<head>
<title>Recommended Movies</title>
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

.filter-row{
    display:flex;
    align-items:center;
    gap:12px;
    margin-bottom:25px;
    flex-wrap:wrap;
}

.filter-row select{
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

.filter-row select:hover{
    border-color:#243B55;
    box-shadow:0 5px 14px rgba(36,59,85,0.12);
}

.filter-row select:focus{
    outline:none;
    border-color:#243B55;
    box-shadow:0 0 0 3px rgba(36,59,85,0.1);
}

.movie-grid{
    display:grid;
    grid-template-columns:repeat(auto-fill,minmax(260px,1fr));
    gap:24px;
}

.movie-card{
    background:white;
    border-radius:15px;
    box-shadow:0 5px 15px rgba(0,0,0,0.10);
    overflow:hidden;
    transition:transform 0.3s, box-shadow 0.3s;
    display:flex;
    flex-direction:column;
}

.movie-card:hover{
    transform:translateY(-5px);
    box-shadow:0 12px 25px rgba(0,0,0,0.15);
}

.movie-poster{
    width:100%;
    height:220px;
    object-fit:cover;
}

.no-poster{
    width:100%;
    height:220px;
    background:linear-gradient(135deg,#243B55,#141E30);
    display:flex;
    align-items:center;
    justify-content:center;
    color:rgba(255,255,255,0.5);
    font-size:13px;
    letter-spacing:1px;
}

.card-body{
    padding:16px;
    flex:1;
    display:flex;
    flex-direction:column;
}

.card-body h3{
    color:#243B55;
    font-size:16px;
    margin-bottom:8px;
}

.card-meta{
    display:flex;
    gap:8px;
    flex-wrap:wrap;
    margin-bottom:10px;
}

.badge{
    padding:3px 12px;
    border-radius:20px;
    font-size:11px;
    font-weight:600;
}

.badge-genre{ background:#e8f0fe; color:#243B55; }
.badge-rating{ background:#243B55; color:white; }
.badge-recommended{ background:#cce5ff; color:#004085; }

.card-desc{
    font-size:12px;
    color:#666;
    line-height:1.6;
    margin-bottom:12px;
    display:-webkit-box;
    -webkit-line-clamp:3;
    -webkit-box-orient:vertical;
    overflow:hidden;
}

.no-results{
    text-align:center;
    padding:50px;
    color:#888;
    background:white;
    border-radius:15px;
    box-shadow:0 5px 15px rgba(0,0,0,0.08);
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
    <h1>Recommended For You</h1>
    <p>Discover highly rated movies you haven't watched yet.</p>

    <a href="user.jsp" class="back-link">
        <button class="btn btn-primary" type="button">
            Back to Home
        </button>
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

    String genreFilter = request.getParameter("genre");
    if(genreFilter == null) genreFilter = "";
    %>

    <h2 class="section-title">Browse by Genre</h2>
    <div class="filter-row">
       <form method="get" action="recommendations.jsp" id="genreForm">
            <select name="genre" onchange="document.getElementById('genreForm').submit();">
                <option value="">All Genres</option>
                <%
                PreparedStatement genreStmt = con.prepareStatement(
                    "SELECT DISTINCT genre FROM movies ORDER BY genre"
                );
                ResultSet genreRs = genreStmt.executeQuery();
                while(genreRs.next())
                {
                    String g = genreRs.getString("genre");
                    String selected = g.equals(genreFilter) ? "selected" : "";
                %>
                <option value="<%= g %>" <%= selected %>><%= g %></option>
                <%
                }
                genreRs.close();
                genreStmt.close();
                %>
            </select>
        </form>
    </div>

    <h2 class="section-title">Top Picks</h2>

    <%
    PreparedStatement rec;

if(genreFilter.equals(""))
{
    rec = con.prepareStatement(

        "SELECT * FROM movies " +
        "WHERE name NOT IN " +
        "(SELECT movie_name FROM watch_history) " +
        "ORDER BY rating DESC " +
        "LIMIT 20"

    );
}
else
{
    rec = con.prepareStatement(

        "SELECT * FROM movies " +
        "WHERE genre=? " +
        "AND name NOT IN " +
        "(SELECT movie_name FROM watch_history) " +
        "ORDER BY rating DESC " +
        "LIMIT 20"

    );

    rec.setString(1, genreFilter);
}

ResultSet recRs = rec.executeQuery();

boolean found = false;
    %>

    <div class="movie-grid">
    <%
    while(recRs.next())
    {
        found = true;
        String mName   = recRs.getString("name");
        String mGenre  = recRs.getString("genre");
        double mRating = recRs.getDouble("rating");
        String mImg    = recRs.getString("image_url");
        String mDesc   = recRs.getString("description");
    %>

    <div class="movie-card">

        <% if(mImg != null && !mImg.trim().isEmpty()) { %>
            <img class="movie-poster" src="<%= mImg %>" alt="<%= mName %>"
                 onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
            <div class="no-poster" style="display:none;">No Image</div>
        <% } else { %>
            <div class="no-poster">No Image</div>
        <% } %>

        <div class="card-body">
            <h3><%= mName %></h3>

            <div class="card-meta">
                <span class="badge badge-genre"><%= mGenre %></span>
                <span class="badge badge-rating"><%= mRating %> / 5</span>
                <span class="badge badge-recommended">Recommended</span>
            </div>

            <% if(mDesc != null && !mDesc.trim().isEmpty()) { %>
                <p class="card-desc"><%= mDesc %></p>
            <% } %>
        </div>
    </div>

    <%
    }
    recRs.close();
    rec.close();
    %>
    </div>

    <% if(!found) { %>
    <div class="no-results">
        <h3>No movies found for this genre.</h3>
    </div>
    <% } %>

    <%
    con.close();
    %>

</div>
</body>
</html>