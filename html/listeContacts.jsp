<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<%@ page import="java.util.*" %>
<%@ page import="domain.Contact" %>
<%@ page import="dao.DAOContact" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<title>Insert title here</title>
</head>
<body>
	<table>
		<caption>Liste contacts :</caption>
		<% DAOContact dao = new DAOContact();
		ArrayList<Contact> liste = dao.getContacts();%>
	
		<%
			for(int i = 0; i < liste.size() ; i++){
				Contact contact = liste.get(i);
				out.println("<tr><td>"+contact.getId()+"</td><td>"+contact.getFirstName()
					+"</td><td>"+contact.getLastName()+"</td><td>"+contact.getEmail()+"</td></tr>");
			}
		%>
	</table>
</body>
</html>