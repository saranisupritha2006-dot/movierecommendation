<%@ page import="java.sql.*" %>

<%
if(session.getAttribute("login")==null)
{
    response.sendRedirect("login.jsp");
    return;
}

Class.forName("com.mysql.cj.jdbc.Driver");

String dbHost = System.getenv("MYSQLHOST");
String dbPort = System.getenv("MYSQLPORT");
String dbName = System.getenv("MYSQLDATABASE");
String dbUser = System.getenv("MYSQLUSER");
String dbPass = System.getenv("MYSQLPASSWORD");

Connection con = DriverManager.getConnection(
    "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName,
    dbUser,
    dbPass
);
String message = "";
String updatedMovie = "";
double updatedRating = 0;

if(request.getParameter("update") != null)
{
    updatedMovie = request.getParameter("movie");
    updatedRating = Double.parseDouble(request.getParameter("rating"));

    PreparedStatement ps = con.prepareStatement(
        "UPDATE movies SET rating=? WHERE name=?"
    );
    ps.setDouble(1, updatedRating);
    ps.setString(2, updatedMovie);

    int i = ps.executeUpdate();
    if(i > 0)
        message = "Rating updated successfully!";

    ps.close();
}

String search = "";
if(request.getParameter("search") != null)
{
    search = request.getParameter("searchMovie");
}
%>

<!DOCTYPE html>
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
    font-family:'Poppins',sans-serif;
}

body{
    background:#eef2f7;
}

.header{
    background:#243B55;
    padding:20px 40px;
    display:flex;
    justify-content:space-between;
    align-items:center;
    color:white;
}

.header h1{ font-size:28px; }

.logout{
    background:#dc3545;
    color:white;
    text-decoration:none;
    padding:10px 20px;
    border-radius:8px;
}

.logout:hover{ background:#b52b38; }

.container{
    width:92%;
    max-width:1100px;
    margin:30px auto;
}

/* Success banner */
.success-banner{
    background:linear-gradient(135deg,#243B55,#141E30);
    color:white;
    border-radius:15px;
    padding:25px 30px;
    margin-bottom:30px;
    display:flex;
    align-items:center;
    gap:20px;
    box-shadow:0 10px 30px rgba(36,59,85,0.35);
    animation:slideDown 0.5s cubic-bezier(0.34,1.56,0.64,1) both;
}

.success-icon{
    width:55px;
    height:55px;
    background:rgba(255,255,255,0.15);
    border-radius:50%;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:26px;
    flex-shrink:0;
    animation:popIn 0.5s cubic-bezier(0.34,1.56,0.64,1) 0.2s both;
}

.success-text h3{
    font-size:18px;
    margin-bottom:4px;
}

.success-text p{
    font-size:13px;
    opacity:0.85;
}

.updated-rating-display{
    margin-left:auto;
    text-align:center;
    background:rgba(255,255,255,0.12);
    border-radius:12px;
    padding:12px 20px;
    flex-shrink:0;
    animation:fadeIn 0.5s ease 0.3s both;
}

.updated-rating-display .big-rating{
    font-size:32px;
    font-weight:700;
    line-height:1;
}

.updated-rating-display .rating-label{
    font-size:11px;
    opacity:0.7;
    margin-top:4px;
    letter-spacing:0.5px;
    text-transform:uppercase;
}

.stars-display{
    color:#FFD54F;
    font-size:18px;
    margin-top:4px;
    letter-spacing:2px;
}

/* Cards */
.card{
    background:white;
    padding:25px;
    border-radius:15px;
    box-shadow:0 8px 20px rgba(0,0,0,.12);
    margin-bottom:25px;
}

.card h2{
    color:#243B55;
    margin-bottom:20px;
    font-size:18px;
    border-left:4px solid #243B55;
    padding-left:12px;
}

/* Search bar */
.search-wrap{
    display:flex;
    gap:12px;
    align-items:center;
}

.search-wrap input{
    flex:1;
    padding:13px 16px;
    border:2px solid #e2e8f0;
    border-radius:10px;
    font-size:14px;
    font-family:Poppins,sans-serif;
    transition:border-color 0.2s;
    margin:0;
}

.search-wrap input:focus{
    outline:none;
    border-color:#243B55;
}

/* Update form grid */
.form-grid{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:16px;
    align-items:end;
}

.form-group{ display:flex; flex-direction:column; }

.form-group label{
    font-size:13px;
    font-weight:600;
    color:#444;
    margin-bottom:8px;
}

.form-group select,
.form-group input{
    padding:13px 16px;
    border:2px solid #e2e8f0;
    border-radius:10px;
    font-size:14px;
    font-family:Poppins,sans-serif;
    margin:0;
    transition:border-color 0.2s;
}

.form-group select:focus,
.form-group input:focus{
    outline:none;
    border-color:#243B55;
}

/* Star rating picker */
.star-picker{
    display:flex;
    flex-direction:row-reverse;
    justify-content:flex-end;
    gap:6px;
    margin-bottom:4px;
}

.star-picker input{ display:none; }

.star-picker label{
    font-size:32px;
    color:#ddd;
    cursor:pointer;
    margin:0;
    transition:color 0.15s;
}

.star-picker input:checked ~ label,
.star-picker label:hover,
.star-picker label:hover ~ label{
    color:#FFD54F;
}

.rating-value-display{
    font-size:13px;
    color:#243B55;
    font-weight:600;
    margin-top:6px;
    min-height:20px;
}

/* Buttons */
button{
    background:#243B55;
    color:white;
    padding:13px 25px;
    border:none;
    border-radius:10px;
    cursor:pointer;
    font-size:14px;
    font-family:Poppins,sans-serif;
    font-weight:600;
    transition:background 0.2s, transform 0.1s;
}

button:hover{ background:#141E30; }
button:active{ transform:scale(0.97); }

.btn-search{
    background:#243B55;
    white-space:nowrap;
    padding:13px 22px;
}

.btn-clear{
    background:#6c757d;
    padding:13px 18px;
}

.btn-clear:hover{ background:#545b62; }

/* Table */
.table-wrap{ overflow-x:auto; }

table{
    width:100%;
    border-collapse:collapse;
}

thead tr{
    background:#243B55;
    color:white;
}

th{
    padding:14px 16px;
    text-align:center;
    font-size:13px;
    font-weight:600;
}

td{
    padding:14px 16px;
    border-bottom:1px solid #f0f0f0;
    text-align:center;
    font-size:14px;
}

tbody tr{
    transition:background 0.2s;
}

tbody tr:hover{
    background:#f8fafc;
}

/* Highlight updated row */
tbody tr.updated-row{
    background:#fffbea;
    animation:highlightRow 2s ease 0.3s both;
}

@keyframes highlightRow{
    0%  { background:#FFD54F44; }
    100%{ background:#fffbea; }
}

.status-badge{
    padding:5px 14px;
    border-radius:20px;
    font-size:12px;
    font-weight:700;
    display:inline-block;
}

.status-excellent{ background:#d4edda; color:#155724; }
.status-verygood { background:#cce5ff; color:#004085; }
.status-good     { background:#fff3cd; color:#856404; }
.status-average  { background:#f8d7da; color:#721c24; }

.rating-stars{
    color:#FFD54F;
    font-size:14px;
    letter-spacing:1px;
}

/* Back */
.back{
    margin-top:25px;
    text-align:center;
}

.back a{ text-decoration:none; }

/* Animations */
@keyframes slideDown{
    from{ opacity:0; transform:translateY(-20px); }
    to{   opacity:1; transform:translateY(0); }
}

@keyframes popIn{
    from{ transform:scale(0); }
    to{   transform:scale(1); }
}

@keyframes fadeIn{
    from{ opacity:0; }
    to{   opacity:1; }
}

</style>
</head>

<body>

<div class="header">
    <h1>Movie Recommendation System</h1>
    <a href="logout.jsp" class="logout">Logout</a>
</div>

<div class="container">

    <!-- SUCCESS BANNER AT TOP -->
    <% if(!message.equals("")) {

        // Build star string for updated rating
        int fullStars = (int) updatedRating;
        String starStr = "";
        for(int s = 0; s < fullStars; s++)   starStr += "&#9733;";
        for(int s = fullStars; s < 5; s++)   starStr += "&#9734;";
    %>
    <div class="success-banner">
        <div class="success-icon">&#10003;</div>
        <div class="success-text">
            <h3><%= message %></h3>
            <p>
                <b><%= updatedMovie %></b> has been updated to a new rating.
            </p>
        </div>
        <div class="updated-rating-display">
            <div class="big-rating"><%= updatedRating %></div>
            <div class="stars-display"><%= starStr %></div>
            <div class="rating-label">New Rating</div>
        </div>
    </div>
    <% } %>

    <!-- SEARCH -->
    <div class="card">
        <h2>Search Movie</h2>
        <form method="post">
            <div class="search-wrap">
                <input
                    type="text"
                    name="searchMovie"
                    placeholder="Type a movie name to search..."
                    value="<%= search %>">
                <button class="btn-search" type="submit" name="search">Search</button>
                <% if(!search.equals("")) { %>
                <a href="ratings.jsp">
                    <button class="btn-clear" type="button">Clear</button>
                </a>
                <% } %>
            </div>
        </form>
    </div>

    <!-- UPDATE RATING -->
    <div class="card">
        <h2>Update Movie Rating</h2>
        <form method="post" id="updateForm">

            <div class="form-grid">
                <div class="form-group">
                    <label>Select Movie</label>
                    <select name="movie" required onchange="showMovieInfo(this)">
                        <option value="">-- Select a Movie --</option>
                        <%
                        PreparedStatement movieList = con.prepareStatement(
                            "SELECT name, rating FROM movies ORDER BY name"
                        );
                        ResultSet movieRs = movieList.executeQuery();
                        while(movieRs.next())
                        {
                            String mName   = movieRs.getString("name");
                            double mRating = movieRs.getDouble("rating");
                        %>
                        <option value="<%= mName %>" data-rating="<%= mRating %>">
                            <%= mName %>
                        </option>
                        <%
                        }
                        movieRs.close();
                        movieList.close();
                        %>
                    </select>
                    <div id="currentRatingInfo" style="font-size:12px;color:#888;margin-top:6px;min-height:18px;"></div>
                </div>

                <div class="form-group">
                    <label>New Rating</label>
                    <!-- Visual star picker -->
                    <div class="star-picker" id="starPicker">
                        <input type="radio" name="rating" id="r5" value="5.0"><label for="r5">&#9733;</label>
                        <input type="radio" name="rating" id="r4" value="4.0"><label for="r4">&#9733;</label>
                        <input type="radio" name="rating" id="r3" value="3.0"><label for="r3">&#9733;</label>
                        <input type="radio" name="rating" id="r2" value="2.0"><label for="r2">&#9733;</label>
                        <input type="radio" name="rating" id="r1" value="1.0"><label for="r1">&#9733;</label>
                    </div>
                    <div class="rating-value-display" id="ratingValueDisplay">
                        Click a star to select rating
                    </div>
                </div>
            </div>

            <button type="submit" name="update" id="updateBtn" style="margin-top:10px;">
                Update Rating
            </button>

        </form>
    </div>

    <!-- MOVIE RATINGS TABLE -->
    <div class="card">
        <h2>
            Movie Ratings
            <% if(!search.equals("")) { %>
            <span style="font-size:13px;font-weight:400;color:#888;margin-left:8px;">
                — results for "<%= search %>"
            </span>
            <% } %>
        </h2>

        <div class="table-wrap">
        <%
        PreparedStatement ps;
        if(search != null && !search.trim().equals(""))
        {
            ps = con.prepareStatement(
                "SELECT * FROM movies WHERE name LIKE ? ORDER BY rating DESC"
            );
            ps.setString(1, "%" + search + "%");
        }
        else
        {
            ps = con.prepareStatement(
                "SELECT * FROM movies ORDER BY rating DESC"
            );
        }
        ResultSet rs = ps.executeQuery();
        %>

        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Movie Name</th>
                    <th>Genre</th>
                    <th>Stars</th>
                    <th>Rating</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
            <%
            int rowNum = 0;
            while(rs.next())
            {
                rowNum++;
                double rate    = rs.getDouble("rating");
                String rName   = rs.getString("name");
                String rGenre  = rs.getString("genre");

                String status, statusClass;
                if(rate >= 4.5)      { status = "Excellent"; statusClass = "status-excellent"; }
                else if(rate >= 4.0) { status = "Very Good"; statusClass = "status-verygood";  }
                else if(rate >= 3.0) { status = "Good";      statusClass = "status-good";      }
                else                 { status = "Average";   statusClass = "status-average";   }

                // Build star string
                int fullS = (int) rate;
                String rStars = "";
                for(int s = 0; s < fullS; s++)  rStars += "&#9733;";
                for(int s = fullS; s < 5; s++)  rStars += "&#9734;";

                boolean isUpdated = rName.equals(updatedMovie);
            %>
            <tr class="<%= isUpdated ? "updated-row" : "" %>">
                <td style="color:#aaa;font-size:12px;"><%= rowNum %></td>
                <td style="font-weight:600;color:#243B55;text-align:left;"><%= rName %></td>
                <td><%= rGenre %></td>
                <td><span class="rating-stars"><%= rStars %></span></td>
                <td style="font-weight:700;"><%= rate %> / 5</td>
                <td><span class="status-badge <%= statusClass %>"><%= status %></span></td>
            </tr>
            <%
            }
            rs.close();
            ps.close();
            con.close();
            %>
            </tbody>
        </table>
        </div>
    </div>

    <div class="back">
        <a href="admin.jsp">
            <button type="button">Back to Dashboard</button>
        </a>
    </div>

</div>

<script>

// Show current rating when movie is selected
function showMovieInfo(sel)
{
    var opt = sel.options[sel.selectedIndex];
    var info = document.getElementById('currentRatingInfo');

    if(opt.value === '')
    {
        info.innerHTML = '';
        return;
    }

    var cur = opt.getAttribute('data-rating');
    info.innerHTML = 'Current rating: <b>' + cur + ' / 5</b>';
}

// Update label when star is clicked
var radios = document.querySelectorAll('.star-picker input[type=radio]');
radios.forEach(function(r){
    r.addEventListener('change', function(){
        document.getElementById('ratingValueDisplay').innerHTML =
            'Selected: <b>' + this.value + ' / 5</b>';
    });
});

// Validate star selected before submit
document.getElementById('updateForm').addEventListener('submit', function(e){
    var selected = document.querySelector('.star-picker input[type=radio]:checked');
    var movie    = document.querySelector('select[name=movie]').value;

    if(!movie)
    {
        alert('Please select a movie.');
        e.preventDefault();
        return;
    }
    if(!selected)
    {
        alert('Please select a star rating.');
        e.preventDefault();
    }
});

</script>

</body>
</html>