<%@ page import="java.sql.*" %>


<%

String movie=request.getParameter("movie_name");

String user=request.getParameter("user_name");

String review=request.getParameter("review_text");


String url="jdbc:mysql://localhost:3306/moviedb";
String dbuser="root";
String pass="";


Class.forName("com.mysql.cj.jdbc.Driver");


Connection con=DriverManager.getConnection(
url,dbuser,pass
);



PreparedStatement ps=con.prepareStatement(

"INSERT INTO reviews(movie_name,user_name,review_text) VALUES(?,?,?)"

);



ps.setString(1,movie);

ps.setString(2,user);

ps.setString(3,review);



ps.executeUpdate();



ps.close();

con.close();


response.sendRedirect("user.jsp");


%>