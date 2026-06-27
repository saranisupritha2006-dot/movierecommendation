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
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Recommendation Engine</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Poppins',sans-serif;
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
    background:#dc3545;
    color:white;
    padding:10px 20px;
    border-radius:8px;
}

.header a:hover{ background:#b52b38; }

.container{
    width:90%;
    max-width:1200px;
    margin:35px auto;
}

.title{
    text-align:center;
    margin-bottom:30px;
}

.title h2{ color:#243B55; margin-bottom:10px; }
.title p{ color:#666; }

.form-box{
    background:white;
    padding:30px;
    border-radius:15px;
    box-shadow:0 8px 20px rgba(0,0,0,.15);
    margin-bottom:30px;
}

label{
    display:block;
    font-weight:600;
    margin-bottom:10px;
}

select{
    width:100%;
    padding:14px;
    font-size:15px;
    border:1px solid #ccc;
    border-radius:8px;
    margin-bottom:20px;
}

select:focus{ outline:none; border-color:#243B55; }

button{
    background:#243B55;
    color:white;
    border:none;
    padding:14px 28px;
    font-size:15px;
    border-radius:8px;
    cursor:pointer;
    transition:.3s;
    font-family:Poppins,sans-serif;
}

button:hover{ background:#141E30; }

.result-title{
    margin-bottom:20px;
    color:#243B55;
    border-left:5px solid #243B55;
    padding-left:12px;
}

.movie-grid{
    display:grid;
    grid-template-columns:repeat(auto-fill,minmax(280px,1fr));
    gap:24px;
}

.movie-card{
    background:white;
    border-radius:15px;
    box-shadow:0 8px 20px rgba(0,0,0,.12);
    overflow:hidden;
    transition:.3s;
    display:flex;
    flex-direction:column;
}

.movie-card:hover{
    transform:translateY(-5px);
    box-shadow:0 12px 28px rgba(0,0,0,.18);
}

.poster-wrap{
    position:relative;
    overflow:hidden;
    cursor:pointer;
}

.movie-poster{
    width:100%;
    height:300px;
    object-fit:cover;
    transition:transform 0.4s ease;
    display:block;
}

.poster-wrap:hover .movie-poster{
    transform:scale(1.05);
}

.poster-overlay{
    position:absolute;
    inset:0;
    background:rgba(36,59,85,0.55);
    display:flex;
    align-items:center;
    justify-content:center;
    opacity:0;
    transition:opacity 0.3s ease;
}

.poster-wrap:hover .poster-overlay{
    opacity:1;
}

.poster-overlay span{
    color:white;
    font-size:14px;
    font-weight:600;
    border:2px solid white;
    padding:8px 20px;
    border-radius:20px;
    letter-spacing:1px;
}

.no-poster{
    width:100%;
    height:300px;
    background:linear-gradient(135deg,#243B55,#141E30);
    display:flex;
    align-items:center;
    justify-content:center;
    color:rgba(255,255,255,0.4);
    font-size:13px;
    letter-spacing:1px;
}

.card-body{
    padding:18px;
    flex:1;
    display:flex;
    flex-direction:column;
}

.movie-name{
    font-size:18px;
    font-weight:700;
    color:#243B55;
    margin-bottom:10px;
}

.card-meta{
    display:flex;
    gap:8px;
    flex-wrap:wrap;
    margin-bottom:12px;
}

.badge{
    padding:4px 12px;
    border-radius:20px;
    font-size:11px;
    font-weight:600;
}

.badge-genre{ background:#e8f0fe; color:#243B55; }
.badge-rating{ background:#FFD54F; color:#333; }
.badge-reason{ background:#d4edda; color:#155724; }

.movie-desc{
    font-size:12px;
    color:#666;
    line-height:1.6;
    margin-bottom:14px;
    display:-webkit-box;
    -webkit-line-clamp:3;
    -webkit-box-orient:vertical;
    overflow:hidden;
}

.reviews-section{
    border-top:1px solid #f0f0f0;
    padding-top:12px;
    margin-top:auto;
}

.reviews-section h4{
    font-size:12px;
    color:#888;
    text-transform:uppercase;
    letter-spacing:0.5px;
    margin-bottom:10px;
}

.mini-review{
    background:#f8f9fa;
    border-radius:8px;
    padding:10px 12px;
    margin-bottom:8px;
}

.reviewer-name{
    font-size:12px;
    font-weight:700;
    color:#243B55;
    margin-bottom:3px;
}

.star-display{
    color:#f5a623;
    font-size:12px;
    margin-left:6px;
}

.review-text{
    font-size:12px;
    color:#555;
    line-height:1.5;
}

.no-reviews{
    font-size:12px;
    color:#aaa;
    font-style:italic;
}

.bottom{
    margin-top:40px;
    display:flex;
    justify-content:center;
    gap:20px;
}

.bottom a{ text-decoration:none; }

/* ══════════════════════════
   MODAL
══════════════════════════ */

.modal-overlay{
    position:fixed;
    inset:0;
    background:rgba(0,0,0,0.75);
    z-index:1000;
    display:flex;
    align-items:center;
    justify-content:center;
    opacity:0;
    visibility:hidden;
    transition:opacity 0.35s ease, visibility 0.35s ease;
    padding:20px;
}

.modal-overlay.active{
    opacity:1;
    visibility:visible;
}

.modal{
    background:white;
    border-radius:20px;
    max-width:800px;
    width:100%;
    max-height:90vh;
    overflow-y:auto;
    display:flex;
    flex-direction:row;
    box-shadow:0 25px 60px rgba(0,0,0,0.4);
    transform:scale(0.85) translateY(40px);
    transition:transform 0.4s cubic-bezier(0.34,1.56,0.64,1);
}

.modal-overlay.active .modal{
    transform:scale(1) translateY(0);
}

.modal-left{
    width:40%;
    flex-shrink:0;
    position:relative;
}

.modal-left img{
    width:100%;
    height:100%;
    object-fit:cover;
    border-radius:20px 0 0 20px;
    animation:fadeInLeft 0.5s ease 0.2s both;
}

.modal-no-img{
    width:100%;
    height:100%;
    min-height:300px;
    background:linear-gradient(135deg,#243B55,#141E30);
    border-radius:20px 0 0 20px;
    display:flex;
    align-items:center;
    justify-content:center;
    color:rgba(255,255,255,0.4);
    font-size:13px;
}

.modal-right{
    padding:30px;
    flex:1;
    display:flex;
    flex-direction:column;
    overflow-y:auto;
}

.modal-close{
    position:absolute;
    top:12px;
    right:12px;
    background:rgba(0,0,0,0.5);
    color:white;
    border:none;
    width:32px;
    height:32px;
    border-radius:50%;
    font-size:18px;
    cursor:pointer;
    display:flex;
    align-items:center;
    justify-content:center;
    line-height:1;
    z-index:10;
    transition:background 0.2s;
    font-family:sans-serif;
}

.modal-close:hover{ background:rgba(220,53,69,0.9); }

/* Animated properties */
.modal-title{
    font-size:22px;
    font-weight:700;
    color:#243B55;
    margin-bottom:12px;
    animation:slideDown 0.4s ease 0.15s both;
}

.modal-badges{
    display:flex;
    gap:8px;
    flex-wrap:wrap;
    margin-bottom:16px;
    animation:slideDown 0.4s ease 0.25s both;
}

.modal-desc{
    font-size:13px;
    color:#555;
    line-height:1.7;
    margin-bottom:20px;
    animation:slideDown 0.4s ease 0.35s both;
}

.modal-reviews-title{
    font-size:12px;
    color:#888;
    text-transform:uppercase;
    letter-spacing:0.5px;
    margin-bottom:10px;
    border-top:1px solid #f0f0f0;
    padding-top:16px;
    animation:slideDown 0.4s ease 0.45s both;
}

.modal-review-item{
    background:#f8f9fa;
    border-radius:10px;
    padding:12px 14px;
    margin-bottom:10px;
    animation:slideDown 0.4s ease 0.5s both;
}

.modal-reviewer{
    font-size:13px;
    font-weight:700;
    color:#243B55;
    margin-bottom:4px;
}

.modal-review-text{
    font-size:13px;
    color:#555;
    line-height:1.5;
}

.modal-no-reviews{
    font-size:13px;
    color:#aaa;
    font-style:italic;
    animation:slideDown 0.4s ease 0.5s both;
}

/* Keyframes */
@keyframes slideDown{
    from{ opacity:0; transform:translateY(-16px); }
    to{   opacity:1; transform:translateY(0); }
}

@keyframes fadeInLeft{
    from{ opacity:0; transform:translateX(-20px); }
    to{   opacity:1; transform:translateX(0); }
}

</style>
</head>

<body>

<div class="header">
    <h1>Movie Recommendation System</h1>
    <a href="logout.jsp">Logout</a>
</div>

<div class="container">

    <div class="title">
        <h2>Recommendation Engine</h2>
        <p>Generate smart movie recommendations based on your favourite genre.</p>
    </div>

    <div class="form-box">
        <form method="post">
            <label>Select Favourite Genre</label>
            <select name="genre">
                <option value="Action">Action</option>
                <option value="Adventure">Adventure</option>
                <option value="Comedy">Comedy</option>
                <option value="Drama">Drama</option>
                <option value="Fantasy">Fantasy</option>
                <option value="Horror">Horror</option>
                <option value="Romance">Romance</option>
                <option value="Sci-Fi">Sci-Fi</option>
                <option value="Thriller">Thriller</option>
                <option value="Animation">Animation</option>
            </select>
            <button type="submit" name="recommend">Generate Recommendations</button>
        </form>
    </div>

    <h2 class="result-title">Recommended Movies</h2>

    <div class="movie-grid">

    <%!
    // Build star string helper
    private String buildStars(int rating)
    {
        String s = "";
        for(int i = 0; i < rating; i++)    s += "&#9733;";
        for(int i = rating; i < 5; i++)    s += "&#9734;";
        return s;
    }
    %>

    <%
    String selectedGenre = request.getParameter("genre");
    boolean isPost       = request.getParameter("recommend") != null;

    PreparedStatement mainPs;

    if(isPost && selectedGenre != null)
    {
        mainPs = con.prepareStatement(
            "SELECT * FROM movies WHERE genre=? ORDER BY rating DESC LIMIT 5"
        );
        mainPs.setString(1, selectedGenre);
    }
    else
    {
        mainPs = con.prepareStatement(
            "SELECT * FROM movies ORDER BY rating DESC LIMIT 5"
        );
    }

    ResultSet mainRs = mainPs.executeQuery();
    boolean found    = false;

    while(mainRs.next())
    {
        found = true;
        String mName   = mainRs.getString("name");
        String mGenre  = mainRs.getString("genre");
        double mRating = mainRs.getDouble("rating");
        String mImg    = mainRs.getString("image_url");
        String mDesc   = mainRs.getString("description");
        if(mDesc  == null) mDesc  = "";
        if(mImg   == null) mImg   = "";

        // Fetch all reviews for modal
        PreparedStatement revPs = con.prepareStatement(
            "SELECT username, review, star_rating FROM reviews " +
            "WHERE movie_name=? ORDER BY id DESC"
        );
        revPs.setString(1, mName);
        ResultSet revRs = revPs.executeQuery();

        // Build reviews HTML for modal
        StringBuilder revHtml = new StringBuilder();
        boolean hasRev = false;
        while(revRs.next())
        {
            hasRev = true;
            int st = revRs.getInt("star_rating");
            revHtml.append("<div class='modal-review-item'>")
                   .append("<div class='modal-reviewer'>")
                   .append(revRs.getString("username"))
                   .append("<span class='star-display'>")
                   .append(buildStars(st))
                   .append("</span></div>")
                   .append("<div class='modal-review-text'>")
                   .append(revRs.getString("review"))
                   .append("</div></div>");
        }
        if(!hasRev)
        {
            revHtml.append("<p class='modal-no-reviews'>No reviews yet for this movie.</p>");
        }
        revRs.close();
        revPs.close();

        String reasonLabel = isPost ? "Matches your genre" : "Top Rated";
        String safeDesc    = mDesc.replace("'", "\\'").replace("\n", " ");
        String safeName    = mName.replace("'", "\\'");
        String safeImg     = mImg.replace("'", "\\'");
        String safeReviews = revHtml.toString().replace("'", "\\'");
    %>

    <!-- Card -->
    <div class="movie-card">

        <!-- Poster (clickable) -->
        <div class="poster-wrap"
             onclick="openModal(
                '<%= safeImg %>',
                '<%= safeName %>',
                '<%= mGenre %>',
                '<%= mRating %>',
                '<%= safeDesc %>',
                '<%= reasonLabel %>',
                '<%= safeReviews %>'
             )">

            <% if(!mImg.isEmpty()) { %>
                <img class="movie-poster"
                     src="<%= mImg %>"
                     alt="<%= mName %>"
                     onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
                <div class="no-poster" style="display:none;">No Image Available</div>
            <% } else { %>
                <div class="no-poster">No Image Available</div>
            <% } %>

            <div class="poster-overlay">
                <span>View Details</span>
            </div>
        </div>

        <div class="card-body">
            <div class="movie-name"><%= mName %></div>
            <div class="card-meta">
                <span class="badge badge-genre"><%= mGenre %></span>
                <span class="badge badge-rating"><%= mRating %> / 5</span>
                <span class="badge badge-reason"><%= reasonLabel %></span>
            </div>
            <% if(!mDesc.isEmpty()) { %>
                <p class="movie-desc"><%= mDesc %></p>
            <% } %>

            <!-- Mini reviews on card -->
            <div class="reviews-section">
                <h4>User Reviews</h4>
                <%
                PreparedStatement cardRevPs = con.prepareStatement(
                    "SELECT username, review, star_rating FROM reviews " +
                    "WHERE movie_name=? ORDER BY id DESC LIMIT 2"
                );
                cardRevPs.setString(1, mName);
                ResultSet cardRevRs = cardRevPs.executeQuery();
                boolean cardHasRev = false;

                while(cardRevRs.next())
                {
                    cardHasRev = true;
                    int st = cardRevRs.getInt("star_rating");
                %>
                <div class="mini-review">
                    <div class="reviewer-name">
                        <%= cardRevRs.getString("username") %>
                        <span class="star-display"><%= buildStars(st) %></span>
                    </div>
                    <div class="review-text"><%= cardRevRs.getString("review") %></div>
                </div>
                <%
                }
                cardRevRs.close();
                cardRevPs.close();
                if(!cardHasRev) { %>
                    <p class="no-reviews">No reviews yet.</p>
                <% } %>
            </div>
        </div>
    </div>

    <%
    }

    mainRs.close();
    mainPs.close();

    // If genre selected but nothing found, fall back to top rated
    if(!found && isPost)
    {
        PreparedStatement fallPs = con.prepareStatement(
            "SELECT * FROM movies ORDER BY rating DESC LIMIT 5"
        );
        ResultSet fallRs = fallPs.executeQuery();
        while(fallRs.next())
        {
            String mName   = fallRs.getString("name");
            String mGenre  = fallRs.getString("genre");
            double mRating = fallRs.getDouble("rating");
            String mImg    = fallRs.getString("image_url");
            String mDesc   = fallRs.getString("description");
            if(mDesc == null) mDesc = "";
            if(mImg  == null) mImg  = "";
            String safeDesc    = mDesc.replace("'", "\\'").replace("\n"," ");
            String safeName    = mName.replace("'", "\\'");
            String safeImg     = mImg.replace("'", "\\'");
    %>

    <div class="movie-card">
        <div class="poster-wrap"
             onclick="openModal('<%= safeImg %>','<%= safeName %>','<%= mGenre %>','<%= mRating %>','<%= safeDesc %>','Popular pick','')">
            <% if(!mImg.isEmpty()) { %>
                <img class="movie-poster" src="<%= mImg %>" alt="<%= mName %>"
                     onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
                <div class="no-poster" style="display:none;">No Image Available</div>
            <% } else { %>
                <div class="no-poster">No Image Available</div>
            <% } %>
            <div class="poster-overlay"><span>View Details</span></div>
        </div>
        <div class="card-body">
            <div class="movie-name"><%= mName %></div>
            <div class="card-meta">
                <span class="badge badge-genre"><%= mGenre %></span>
                <span class="badge badge-rating"><%= mRating %> / 5</span>
                <span class="badge badge-reason">Popular pick</span>
            </div>
            <% if(!mDesc.isEmpty()) { %>
                <p class="movie-desc"><%= mDesc %></p>
            <% } %>
        </div>
    </div>

    <%
        }
        fallRs.close();
        fallPs.close();
    }

    con.close();
    %>

    </div>

    <div class="bottom">
        <a href="admin.jsp"><button type="button">Back to Dashboard</button></a>
        <a href="addMovie.jsp"><button type="button">Manage Movies</button></a>
    </div>

</div>


<!-- ══════════════════════════
     MODAL
══════════════════════════ -->
<div class="modal-overlay" id="modalOverlay" onclick="handleOverlayClick(event)">
    <div class="modal" id="modal">

        <div class="modal-left">
            <button class="modal-close" onclick="closeModal()">&#x2715;</button>
            <img id="modalImg" src="" alt="">
            <div class="modal-no-img" id="modalNoImg" style="display:none;">No Image</div>
        </div>

        <div class="modal-right">
            <div class="modal-title"  id="modalTitle"></div>
            <div class="modal-badges" id="modalBadges"></div>
            <div class="modal-desc"   id="modalDesc"></div>
            <div class="modal-reviews-title">User Reviews</div>
            <div id="modalReviews"></div>
        </div>

    </div>
</div>

<script>

function openModal(img, name, genre, rating, desc, reason, reviews)
{
    // Populate image
    var imgEl   = document.getElementById('modalImg');
    var noImgEl = document.getElementById('modalNoImg');

    if(img && img.trim() !== '')
    {
        imgEl.src           = img;
        imgEl.style.display = 'block';
        noImgEl.style.display = 'none';
        imgEl.onerror = function(){
            imgEl.style.display   = 'none';
            noImgEl.style.display = 'flex';
        };
    }
    else
    {
        imgEl.style.display   = 'none';
        noImgEl.style.display = 'flex';
    }

    // Populate text
    document.getElementById('modalTitle').innerText = name;

    document.getElementById('modalBadges').innerHTML =
        '<span class="badge badge-genre">'  + genre  + '</span>' +
        '<span class="badge badge-rating">' + rating + ' / 5</span>' +
        '<span class="badge badge-reason">' + reason + '</span>';

    document.getElementById('modalDesc').innerText =
        desc && desc.trim() !== '' ? desc : 'No description available.';

    document.getElementById('modalReviews').innerHTML =
        reviews && reviews.trim() !== ''
            ? reviews
            : '<p class="modal-no-reviews">No reviews yet for this movie.</p>';

    // Reset animation by cloning modal
    var modal    = document.getElementById('modal');
    var newModal = modal.cloneNode(true);
    modal.parentNode.replaceChild(newModal, modal);

    document.getElementById('modalOverlay').classList.add('active');
    document.body.style.overflow = 'hidden';
}

function closeModal()
{
    document.getElementById('modalOverlay').classList.remove('active');
    document.body.style.overflow = '';
}

function handleOverlayClick(e)
{
    if(e.target === document.getElementById('modalOverlay'))
        closeModal();
}

document.addEventListener('keydown', function(e){
    if(e.key === 'Escape') closeModal();
});

</script>

</body>
</html>