package upload.progress;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.ProgressListener;

public class MyProgressListener implements ProgressListener {
	private HttpSession session;

	public MyProgressListener(HttpServletRequest request) {
		session = request.getSession();
		ProcessStatus status = new ProcessStatus();
		session.setAttribute("status", status);
	}

	@Override
	public void update(long pBytesRead, long pContentLength, int pItems) {
		ProcessStatus status = new ProcessStatus();
		status.pBytesRead = pBytesRead;
		status.pContentLength = pContentLength;
		status.pItems = pItems;
		
		status.show = pBytesRead + "/" + pContentLength + " byte";
		status.rate = Math.round(new Float(pBytesRead) / new Float(pContentLength) * 100);
		session.setAttribute("status", status);
		
		System.out.println("We are currently reading item " + pItems);
		if (pContentLength == -1) {
			System.out.println("So far, " + pBytesRead + " bytes have been read.");
		} else {
			System.out.println("So far, " + pBytesRead + " of " + pContentLength + " bytes have been read.");
		}
	}

}
