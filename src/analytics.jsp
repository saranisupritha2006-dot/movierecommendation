<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>

<%
if(session.getAttribute("login")==null)
{
    response.sendRedirect("login.jsp");
    return;
}

String dbUrl = "jdbc:mysql://localhost:3306/your_db_name";
String dbUser = "root";
String dbPass = "your_password";

int totalMovies = -1;
int totalUsers = -1;
double avgRating = -1;

List<String> genreLabels = new ArrayList<>();
List<Integer> genreCounts = new ArrayList<>();

List<String> monthLabels = new ArrayList<>();
List<Integer> monthCounts = new ArrayList<>();

try(Connection con = DriverManager.getConnection(dbUrl, dbUser, dbPass))
{
    try(Statement st = con.createStatement();
        ResultSet rs = st.executeQuery("SELECT COUNT(*) AS cnt FROM movies"))
    {
        if(rs.next()) totalMovies = rs.getInt("cnt");
    }
    catch(Exception e) { totalMovies = -1; }

    try(Statement st = con.createStatement();
        ResultSet rs = st.executeQuery("SELECT COUNT(*) AS cnt FROM users"))
    {
        if(rs.next()) totalUsers = rs.getInt("cnt");
    }
    catch(Exception e) { totalUsers = -1; }

    try(Statement st = con.createStatement();
        ResultSet rs = st.executeQuery("SELECT AVG(rating) AS avgr FROM ratings"))
    {
        if(rs.next()) avgRating = rs.getDouble("avgr");
    }
    catch(Exception e) { avgRating = -1; }

    try(Statement st = con.createStatement();
        ResultSet rs = st.executeQuery("SELECT genre, COUNT(*) AS cnt FROM movies GROUP BY genre ORDER BY cnt DESC"))
    {
        while(rs.next())
        {
            genreLabels.add(rs.getString("genre"));
            genreCounts.add(rs.getInt("cnt"));
        }
    }
    catch(Exception e) { /* leave empty */ }

    try(Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(
            "SELECT DATE_FORMAT(created_at, '%b %Y') AS mon, COUNT(*) AS cnt " +
            "FROM movies GROUP BY DATE_FORMAT(created_at, '%Y-%m') ORDER BY DATE_FORMAT(created_at, '%Y-%m')"))
    {
        while(rs.next())
        {
            monthLabels.add(rs.getString("mon"));
            monthCounts.add(rs.getInt("cnt"));
        }
    }
    catch(Exception e) { /* leave empty */ }
}
catch(Exception e)
{
    e.printStackTrace();
}

StringBuilder genreLabelsJs = new StringBuilder("[");
StringBuilder genreCountsJs = new StringBuilder("[");
for(int i=0; i<genreLabels.size(); i++)
{
    genreLabelsJs.append("\"").append(genreLabels.get(i).replace("\"","'")).append("\"");
    genreCountsJs.append(genreCounts.get(i));
    if(i < genreLabels.size()-1) { genreLabelsJs.append(","); genreCountsJs.append(","); }
}
genreLabelsJs.append("]");
genreCountsJs.append("]");

StringBuilder monthLabelsJs = new StringBuilder("[");
StringBuilder monthCountsJs = new StringBuilder("[");
for(int i=0; i<monthLabels.size(); i++)
{
    monthLabelsJs.append("\"").append(monthLabels.get(i)).append("\"");
    monthCountsJs.append(monthCounts.get(i));
    if(i < monthLabels.size()-1) { monthLabelsJs.append(","); monthCountsJs.append(","); }
}
monthLabelsJs.append("]");
monthCountsJs.append("]");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Analytics Dashboard</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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
    font-size:26px;
}

.back{
    background:#6c757d;
    color:white;
    padding:10px 20px;
    border-radius:8px;
    text-decoration:none;
    transition:.3s;
}

.back:hover{
    background:#565e64;
}

.container{
    width:90%;
    margin:40px auto;
}

.stats-row{
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
    gap:25px;
    margin-bottom:40px;
}

.stat-card{
    background:white;
    border-radius:15px;
    padding:30px;
    text-align:center;
    box-shadow:0 10px 25px rgba(0,0,0,.1);
}

.stat-card .value{
    font-size:36px;
    font-weight:700;
    color:#243B55;
    margin-bottom:8px;
}

.stat-card .label{
    color:#777;
    font-size:14px;
    text-transform:uppercase;
    letter-spacing:.5px;
}

.charts-row{
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(380px,1fr));
    gap:30px;
}

.chart-card{
    background:white;
    border-radius:15px;
    padding:30px;
    box-shadow:0 10px 25px rgba(0,0,0,.1);
}

.chart-card h3{
    color:#243B55;
    margin-bottom:20px;
    font-size:18px;
}

.no-data{
    text-align:center;
    color:#999;
    padding:40px 0;
}

</style>

</head>

<body>

<div class="header">
<h1>Analytics Dashboard</h1>
<a href="admin.jsp" class="back">Back to Dashboard</a>
</div>

<div class="container">

<div class="stats-row">

<div class="stat-card">
<div class="value"><%= totalMovies >= 0 ? totalMovies : "N/A" %></div>
<div class="label">Total Movies</div>
</div>

<div class="stat-card">
<div class="value"><%= totalUsers >= 0 ? totalUsers : "N/A" %></div>
<div class="label">Total Users</div>
</div>

<div class="stat-card">
<div class="value"><%= avgRating >= 0 ? String.format("%.1f", avgRating) : "N/A" %></div>
<div class="label">Average Rating</div>
</div>

</div>

<div class="charts-row">

<div class="chart-card">
<h3>Movies by Genre</h3>
<% if(genreLabels.isEmpty()) { %>
<p class="no-data">No genre data available</p>
<% } else { %>
<canvas id="genreChart"></canvas>
<% } %>
</div>

<div class="chart-card">
<h3>Movies Added Over Time</h3>
<% if(monthLabels.isEmpty()) { %>
<p class="no-data">No timeline data available</p>
<% } else { %>
<canvas id="timelineChart"></canvas>
<% } %>
</div>

</div>

</div>

<script>

<% if(!genreLabels.isEmpty()) { %>
new Chart(document.getElementById('genreChart'), {
    type: 'doughnut',
    data: {
        labels: <%= genreLabelsJs.toString() %>,
        datasets: [{
            data: <%= genreCountsJs.toString() %>,
            backgroundColor: ['#243B55','#3a5a8c','#5b86c2','#8fb3da','#a3c4f3','#bcd4f5','#d6e4f0','#243B55']
        }]
    },
    options: {
        responsive: true,
        plugins: { legend: { position: 'bottom' } }
    }
});
<% } %>

<% if(!monthLabels.isEmpty()) { %>
new Chart(document.getElementById('timelineChart'), {
    type: 'bar',
    data: {
        labels: <%= monthLabelsJs.toString() %>,
        datasets: [{
            label: 'Movies Added',
            data: <%= monthCountsJs.toString() %>,
            backgroundColor: '#243B55',
            borderRadius: 6
        }]
    },
    options: {
        responsive: true,
        plugins: { legend: { display: false } },
        scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
    }
});
<% } %>

</script>

</body>
</html>