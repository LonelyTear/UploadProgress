package upload.progress;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class MyProgressServlet extends HttpServlet {
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) {
		this.doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		ProcessStatus status = (ProcessStatus) session.getAttribute("status");
		response.reset();
		try {
			System.out.println(status.toString());
			response.getWriter().write(status.toString());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
