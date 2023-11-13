package librerie;

import edu.fauser.DbUtility;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebListener
public class config implements ServletContextListener, HttpSessionListener, HttpSessionAttributeListener {

    public config() {
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {

        DbUtility dbu = new DbUtility();
        dbu.setDevCredentials("jdbc:mariadb://localhost:3306/dbmusica?maxPoolSize=2&pool", "root", "");
        dbu.setProdCredentials("SECRET", "SECRET", "SECRET");

        ServletContext ctx = sce.getServletContext();
        ctx.setAttribute("dbutility", dbu);
    }
}
