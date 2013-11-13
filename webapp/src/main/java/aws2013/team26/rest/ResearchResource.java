package aws2013.team26.rest;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.core.Response;

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
    public Response queryData(MultivaluedMap<String,String> multivaluedMap) throws SQLException, UnsupportedEncodingException {
    	String query = multivaluedMap.getFirst("sql");
        String resultJSON = new QueryDatabase().executeQuery(URLDecoder.decode(query,"UTF-8"));
        Map model = new HashMap();
        model.put("resultsJSON", resultJSON);
        return Response.ok(new Viewable("/results.jsp", model)).build();

    }
	
}
