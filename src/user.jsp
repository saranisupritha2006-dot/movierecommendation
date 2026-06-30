<%@ page import="java.sql.*" %>

<html>
<head>
<title>Movie Recommendation System</title>
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

.section-title{
    color:#243B55;
    margin:35px 0 15px;
    font-size:22px;
    border-left:5px solid #243B55;
    padding-left:12px;
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
.badge-watched{ background:#d4edda; color:#155724; }
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

.card-reviews{
    border-top:1px solid #f0f0f0;
    padding-top:10px;
    margin-top:auto;
}

.card-reviews h4{
    font-size:11px;
    color:#888;
    text-transform:uppercase;
    letter-spacing:0.5px;
    margin-bottom:8px;
}

.mini-review{
    background:#f8f9fa;
    border-radius:8px;
    padding:8px 10px;
    margin-bottom:6px;
}

.mini-review .reviewer{
    font-size:11px;
    font-weight:700;
    color:#243B55;
    margin-bottom:2px;
}

.mini-review .review-text{
    font-size:11px;
    color:#555;
    line-height:1.4;
}

.no-reviews{
    font-size:11px;
    color:#aaa;
    font-style:italic;
}

.form-card{
    background:white;
    padding:25px;
    border-radius:15px;
    box-shadow:0 5px 15px rgba(0,0,0,0.10);
}

.form-card label{
    display:block;
    font-weight:600;
    margin-bottom:6px;
    color:#333;
    font-size:14px;
}

.form-card input,
.form-card textarea,
.form-card select{
    width:100%;
    padding:11px 14px;
    margin-bottom:16px;
    border:1px solid #ccc;
    border-radius:8px;
    font-size:14px;
    font-family:Poppins,sans-serif;
}

.form-card input:focus,
.form-card textarea:focus,
.form-card select:focus{
    outline:none;
    border-color:#243B55;
    box-shadow:0 0 0 3px rgba(36,59,85,0.1);
}

.form-card textarea{ resize:vertical; min-height:90px; }

.star-row{
    display:flex;
    flex-direction:row-reverse;
    justify-content:flex-end;
    gap:4px;
    margin-bottom:16px;
}

.star-row input{ display:none; }

.star-row label{
    font-size:30px;
    color:#ddd;
    cursor:pointer;
    margin:0;
}

.star-row input:checked ~ label,
.star-row label:hover,
.star-row label:hover ~ label{
    color:#f5a623;
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
.btn-logout{ background:#dc3545; color:white; }
.btn-logout:hover{ background:#b52b38; }

.footer{
    text-align:center;
    background:white;
    margin-top:50px;
    padding:25px;
    border-radius:15px;
    box-shadow:0 5px 15px rgba(0,0,0,0.08);
}

.footer h2{ color:#243B55; margin-bottom:6px; }
.footer p{ color:#888; font-size:13px; margin-bottom:15px; }

.message{
    background:#d4edda;
    color:#155724;
    padding:12px 16px;
    border-radius:8px;
    margin:20px 0;
    font-weight:500;
}

/* Home Options */
.option-grid{
    display:grid;
    grid-template-columns:repeat(2,1fr);
    gap:25px;
    margin-top:30px;
    margin-bottom:35px;
}

.option-card{
    background:white;
    border-radius:15px;
    padding:35px;
    text-align:center;
    box-shadow:0 5px 15px rgba(0,0,0,0.10);
    transition:.3s;
}

.option-card:hover{
    transform:translateY(-5px);
    box-shadow:0 12px 25px rgba(0,0,0,.15);
}

.option-card h3{
    color:#243B55;
    margin-bottom:10px;
}

.option-card p{
    color:#777;
    font-size:13px;
    margin-bottom:20px;
    line-height:1.6;
}

@media(max-width:768px){
    .option-grid{
        grid-template-columns:1fr;
    }
}

</style>
</head>

<body>
<div class="container">

    <div class="header">
    <h1>Movie Recommendation System</h1>
    <p>Find movies based on your interest</p>
</div>



    <%
    String dbHost = System.getenv("MYSQLHOST") != null ? System.getenv("MYSQLHOST") : "localhost";
String dbPort = System.getenv("MYSQLPORT") != null ? System.getenv("MYSQLPORT") : "3306";
String dbName = System.getenv("MYSQLDATABASE") != null ? System.getenv("MYSQLDATABASE") : "moviedb";
String dbUser = System.getenv("MYSQLUSER") != null ? System.getenv("MYSQLUSER") : "root";
String dbPass = System.getenv("MYSQLPASSWORD") != null ? System.getenv("MYSQLPASSWORD") : "";
String dbUrl = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName;
Connection con = DriverManager.getConnection(dbUrl, dbUser, dbPass);
    String reviewMsg = "";
    if(request.getParameter("submitReview") != null)
    {
        String movieName  = request.getParameter("movie_name");
        String userName   = request.getParameter("user_name");
        String reviewText = request.getParameter("review_text");
        int starRating    = Integer.parseInt(request.getParameter("star_rating"));

        PreparedStatement insRev = con.prepareStatement(
    "INSERT INTO reviews(movie_name, username, review, star_rating) VALUES(?,?,?,?)"
);
insRev.setString(1, movieName);
insRev.setString(2, userName);
insRev.setString(3, reviewText);
insRev.setInt(4, starRating);
        insRev.executeUpdate();
        insRev.close();
        reviewMsg = "Your review was submitted successfully!";
    }

    boolean hasHistory = false;
    PreparedStatement check = con.prepareStatement("SELECT COUNT(*) FROM watch_history");
    ResultSet checkRs = check.executeQuery();
    if(checkRs.next() && checkRs.getInt(1) > 0) hasHistory = true;
    checkRs.close();
    check.close();
    %>

    <% if(!reviewMsg.equals("")) { %>
    <div class="message"><%= reviewMsg %></div>
    <% } %>


     <h2 class="section-title">Explore</h2>

<div class="option-grid">

    <div class="option-card">

        <h3>Movie Recommendations</h3>

        <p>
            Browse movies recommended for you based on ratings and your watch history.
        </p>

        <a href="recommendations.jsp" style="text-decoration:none;">
            <button class="btn btn-primary">
                View Recommendations
            </button>
        </a>

    </div>

    <div class="option-card">

        <h3>Movie Ratings</h3>

        <p>
            View ratings of every movie and sort them by name or rating.
        </p>

        <a href="ratings.jsp" style="text-decoration:none;">
            <button class="btn btn-primary">
                View Ratings
            </button>
        </a>

    </div>

</div>
    <!-- WRITE A REVIEW -->
    <h2 class="section-title">Write a Review</h2>
    <div class="form-card">
        <form method="post">

            <label>Movie Name</label>
            <select name="movie_name" required>
                <option value="">-- Select a Movie --</option>
                <%
                PreparedStatement movieList = con.prepareStatement(
                    "SELECT name FROM movies ORDER BY name"
                );
                ResultSet mlRs = movieList.executeQuery();
                while(mlRs.next()) {
                %>
                <option value="<%= mlRs.getString("name") %>">
                    <%= mlRs.getString("name") %>
                </option>
                <%
                }
                mlRs.close();
                movieList.close();
                %>
            </select>

            <label>Your Name</label>
            <input type="text" name="user_name" placeholder="Enter your name" required>

            <label>Star Rating</label>
            <div class="star-row">
                <input type="radio" name="star_rating" id="s5" value="5"><label for="s5">&#9733;</label>
                <input type="radio" name="star_rating" id="s4" value="4"><label for="s4">&#9733;</label>
                <input type="radio" name="star_rating" id="s3" value="3"><label for="s3">&#9733;</label>
                <input type="radio" name="star_rating" id="s2" value="2"><label for="s2">&#9733;</label>
                <input type="radio" name="star_rating" id="s1" value="1"><label for="s1">&#9733;</label>
            </div>

            <label>Your Review</label>
            <textarea name="review_text"
                      placeholder="Share your thoughts about the movie..."
                      required></textarea>

            <button class="btn btn-primary" type="submit" name="submitReview">
                Submit Review
            </button>

        </form>
    </div>


    <!-- FOOTER -->
    <div class="footer">
        <h2>Movie Recommendation System</h2>
        <p>Built using JSP, JDBC and MySQL</p>
        <a href="logout.jsp">
            <button class="btn btn-logout">Logout</button>
        </a>
    </div>

    <%
    con.close();
    %>

</div>
</body>
</html>