package aws2013.team26.data;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

public class QueryDatabase {
	private final static Properties properties = new Properties();

	
	static {
	try {
		properties.put("url", "jdbc:postgresql://localhost/donors?user=postgres&password=postgres");
		properties.put("driver", "org.postgresql.Driver");
		InputStream is = QueryDatabase.class.getResourceAsStream("db.properties");
		if (is != null) properties.load(is);
		System.out.println(properties);
	} catch (IOException e) {
		e.printStackTrace();
	}
	
	}
	
	public String executeQuery(String query) throws SQLException {
		try {
			// This will load the MySQL driver, each DB has its own driver
			Class.forName(properties.getProperty("driver"));
			// Setup the connection with the DB
			Connection connect = DriverManager.getConnection(properties.getProperty("url"));
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
