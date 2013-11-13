package aws2013.team26.rest;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.sql.SQLException;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.MultivaluedMap;

import com.sun.jersey.api.view.Viewable;

import aws2013.team26.data.QueryDatabase;

/**
 * Root resource (exposed at "research" path)
 */
@Path("research")
public class ResearchResource {

    @POST
    @Produces(MediaType.TEXT_PLAIN)
    @Consumes("application/x-www-form-urlencoded,text/plain,text/html")
    public String queryData(MultivaluedMap<String,String> multivaluedMap) throws SQLException, UnsupportedEncodingException {
    	String query = multivaluedMap.getFirst("sql");
        return new QueryDatabase().executeQuery(URLDecoder.decode(query,"UTF-8"));
        
    }
	
}
