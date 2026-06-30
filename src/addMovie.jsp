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

if(dbHost == null) dbHost = "localhost";
if(dbPort == null) dbPort = "3306";
if(dbName == null) dbName = "moviedb";
if(dbUser == null) dbUser = "root";
if(dbPass == null) dbPass = "";
Connection con = DriverManager.getConnection(
    "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName,
    dbUser,
    dbPass
);

String message="";

if(request.getParameter("addMovie")!=null)
{
    String name=request.getParameter("movie");
    String genre=request.getParameter("genre");
    double rating=Double.parseDouble(request.getParameter("rating"));
    String imageUrl=request.getParameter("image_url");
    String description=request.getParameter("description");

    PreparedStatement check=con.prepareStatement(
    "SELECT * FROM movies WHERE name=?");
    check.setString(1,name);
    ResultSet crs=check.executeQuery();

    if(!crs.next())
    {
        PreparedStatement ps=con.prepareStatement(
        "INSERT INTO movies(name,genre,rating,image_url,description) VALUES(?,?,?,?,?)");
        ps.setString(1,name);
        ps.setString(2,genre);
        ps.setDouble(3,rating);
        ps.setString(4,imageUrl);
        ps.setString(5,description);
        ps.executeUpdate();
        ps.close();
        message="Movie Added Successfully.";
    }
    else
    {
        message="Movie Already Exists.";
    }

    crs.close();
    check.close();
}

if(request.getParameter("delete")!=null)
{
    PreparedStatement del=con.prepareStatement(
    "DELETE FROM movies WHERE name=?");
    del.setString(1,request.getParameter("delete"));
    del.executeUpdate();
    del.close();
    response.sendRedirect("addMovie.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Movies</title>
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

.header{
    background:#243B55;
    color:white;
    padding:20px 40px;
    display:flex;
    justify-content:space-between;
    align-items:center;
}

.header h1{ font-size:28px; }

.header a{
    text-decoration:none;
    color:white;
    background:#dc3545;
    padding:10px 20px;
    border-radius:8px;
}

.header a:hover{ background:#b52b38; }

.container{
    width:90%;
    max-width:1200px;
    margin:35px auto;
}

.form-box{
    background:white;
    padding:30px;
    border-radius:15px;
    box-shadow:0 8px 20px rgba(0,0,0,.15);
    margin-bottom:30px;
}

.form-box h2{
    margin-bottom:20px;
    color:#243B55;
}

.form-grid{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:0 20px;
}

.form-grid .full-width{
    grid-column: 1 / -1;
}

label{
    display:block;
    margin-bottom:6px;
    font-weight:600;
    color:#333;
}

input, textarea{
    width:100%;
    padding:12px 14px;
    margin-bottom:18px;
    border:1px solid #ccc;
    border-radius:8px;
    font-size:14px;
    font-family:Poppins,sans-serif;
}

textarea{
    resize:vertical;
    min-height:100px;
}

input:focus, textarea:focus{
    outline:none;
    border-color:#243B55;
    box-shadow:0 0 0 3px rgba(36,59,85,0.1);
}

/* Image preview inside form */
.image-preview-wrap{
    margin-bottom:18px;
}

.image-preview-wrap img{
    width:100%;
    max-height:180px;
    object-fit:cover;
    border-radius:8px;
    border:1px solid #ddd;
    display:none;
}

button{
    background:#243B55;
    color:white;
    padding:13px 30px;
    border:none;
    border-radius:8px;
    cursor:pointer;
    font-size:15px;
    font-family:Poppins,sans-serif;
}

button:hover{ background:#141E30; }

.message{
    background:#d4edda;
    padding:15px;
    border-radius:8px;
    color:#155724;
    margin-bottom:20px;
    font-weight:500;
}

/* Movie Cards Grid */
.table-box{
    background:white;
    padding:25px;
    border-radius:15px;
    box-shadow:0 8px 20px rgba(0,0,0,.15);
}

.table-box h2{
    margin-bottom:20px;
    color:#243B55;
}

.movies-grid{
    display:grid;
    grid-template-columns:repeat(auto-fill, minmax(240px, 1fr));
    gap:20px;
}

.movie-card{
    border:1px solid #e2e8f0;
    border-radius:12px;
    overflow:hidden;
    transition:transform 0.2s, box-shadow 0.2s;
    background:#fafafa;
}

.movie-card:hover{
    transform:translateY(-4px);
    box-shadow:0 12px 24px rgba(0,0,0,0.12);
}

.movie-card img{
    width:100%;
    height:200px;
    object-fit:cover;
    background:#e2e8f0;
}

.movie-card .no-image{
    width:100%;
    height:200px;
    background:linear-gradient(135deg,#243B55,#141E30);
    display:flex;
    align-items:center;
    justify-content:center;
    color:white;
    font-size:13px;
    letter-spacing:1px;
}

.card-body{
    padding:15px;
}

.card-body h3{
    font-size:15px;
    color:#243B55;
    margin-bottom:6px;
    white-space:nowrap;
    overflow:hidden;
    text-overflow:ellipsis;
}

.card-meta{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:8px;
}

.genre-badge{
    background:#e8f0fe;
    color:#243B55;
    padding:3px 10px;
    border-radius:20px;
    font-size:11px;
    font-weight:600;
}

.rating-badge{
    background:#243B55;
    color:white;
    padding:3px 10px;
    border-radius:20px;
    font-size:12px;
    font-weight:600;
}

.card-desc{
    font-size:12px;
    color:#666;
    line-height:1.5;
    margin-bottom:12px;
    display:-webkit-box;
    -webkit-line-clamp:3;
    -webkit-box-orient:vertical;
    overflow:hidden;
}

.no-desc{
    font-size:12px;
    color:#aaa;
    font-style:italic;
    margin-bottom:12px;
}

.delete{
    display:block;
    text-align:center;
    background:#dc3545;
    padding:8px;
    border-radius:6px;
    color:white;
    text-decoration:none;
    font-size:13px;
    font-weight:500;
}

.delete:hover{ background:#b52b38; }

.back{
    margin-top:30px;
    text-align:center;
}

</style>
</head>

<body>

<div class="header">
    <h1>Movie Recommendation System</h1>
    <a href="logout.jsp">Logout</a>
</div>

<div class="container">

    <div class="form-box">
        <h2>Add New Movie</h2>

        <% if(!message.equals("")) { %>
        <div class="message"><%= message %></div>
        <% } %>

        <form method="post">
            <div class="form-grid">

                <div>
                    <label>Movie Name</label>
                    <input type="text" name="movie" required>
                </div>

                <div>
                    <label>Genre</label>
                    <input type="text" name="genre" required>
                </div>

                <div>
                    <label>Rating (1 - 5)</label>
                    <input type="number" name="rating" step="0.1" min="1" max="5" required>
                </div>

                <div>
                    <label>Poster Image URL</label>
                    <input type="url" name="image_url" id="imageUrlInput" placeholder="https://example.com/poster.jpg">
                    <!-- live preview -->
                    <div class="image-preview-wrap">
                        <img id="imagePreview" src="" alt="Preview">
                    </div>
                </div>

                <div class="full-width">
                    <label>Description</label>
                    <textarea name="description" placeholder="Write a short synopsis of the movie..."></textarea>
                </div>

            </div>

            <button type="submit" name="addMovie">Add Movie</button>
        </form>
    </div>

    <div class="table-box">
        <h2>Available Movies</h2>

        <%
        PreparedStatement show=con.prepareStatement(
        "SELECT * FROM movies ORDER BY name");
        ResultSet rs=show.executeQuery();
        %>

        <div class="movies-grid">

        <%
        while(rs.next())
        {
            String movieName  = rs.getString("name");
            String movieGenre = rs.getString("genre");
            double movieRating= rs.getDouble("rating");
            String movieImg   = rs.getString("image_url");
            String movieDesc  = rs.getString("description");
        %>

        <div class="movie-card">

            <% if(movieImg != null && !movieImg.trim().isEmpty()) { %>
                <img src="<%= movieImg %>" alt="<%= movieName %> poster"
                     onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
                <div class="no-image" style="display:none;">No Image</div>
            <% } else { %>
                <div class="no-image">NO IMAGE</div>
            <% } %>

            <div class="card-body">
                <h3 title="<%= movieName %>"><%= movieName %></h3>

                <div class="card-meta">
                    <span class="genre-badge"><%= movieGenre %></span>
                    <span class="rating-badge"><%= movieRating %> / 5</span>
                </div>

                <% if(movieDesc != null && !movieDesc.trim().isEmpty()) { %>
                    <p class="card-desc"><%= movieDesc %></p>
                <% } else { %>
                    <p class="no-desc">No description available.</p>
                <% } %>

                <a class="delete"
                   href="addMovie.jsp?delete=<%= movieName %>"
                   onclick="return confirm('Delete <%= movieName %>?');">
                    🗑 Delete
                </a>
            </div>
        </div>

        <%
        }
        rs.close();
        show.close();
        con.close();
        %>

        </div>
    </div>

    <div class="back">
        <a href="admin.jsp"><button type="button">Back to Dashboard</button></a>
    </div>

</div>

<!-- Live image preview script -->
<script>
    const input = document.getElementById('imageUrlInput');
    const preview = document.getElementById('imagePreview');

    input.addEventListener('input', function(){
        const url = this.value.trim();
        if(url){
            preview.src = url;
            preview.style.display = 'block';
            preview.onerror = () => preview.style.display = 'none';
        } else {
            preview.style.display = 'none';
        }
    });
</script>

</body>
</html>