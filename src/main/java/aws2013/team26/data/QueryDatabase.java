package aws2013.team26.data;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class QueryDatabase {

	public String executeQuery(String query) throws SQLException {
		try {
			// This will load the MySQL driver, each DB has its own driver
			Class.forName("com.mysql.jdbc.Driver");
			// Setup the connection with the DB
			Connection connect = DriverManager.getConnection("jdbc:mysql://localhost/aws2013db?"
											+ "user=aws2013&password=aws2013team26");
			// Statements allow to issue SQL queries to the database
			Statement statement = connect.createStatement();
		      // Result set get the result of the SQL query
		    ResultSet  resultSet = statement.executeQuery(query);
		    return ResultSetConverter.convert(resultSet).toString();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		return "";
	}
	
	@Deprecated
	private String resultSetToString(ResultSet resultSet) throws SQLException {
		StringBuffer result = new StringBuffer();
	    // ResultSet is initially before the first data set
	    while (resultSet.next()) {
	      // It is possible to get the columns via name
	      // also possible to get the columns via the column number
	      // which starts at 1
	      // e.g. resultSet.getSTring(2);
	      String user = resultSet.getString("myuser");
	      String website = resultSet.getString("webpage");
	      String summary = resultSet.getString("summary");
	      Date date = resultSet.getDate("datum");
	      String comment = resultSet.getString("comments");
	      result.append("User: " + user);
	      result.append("Website: " + website);
	      result.append("Summary: " + summary);
	      result.append("Date: " + date);
	      result.append("Comment: " + comment);
	    }
		return result.toString();
	  }
	
	
	
}
