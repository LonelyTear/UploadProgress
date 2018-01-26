package listener;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.ProgressListener;

import vo.ProcessStatusVo;

public class MyProgressListener implements ProgressListener {
	private HttpSession session;

	/**
	 * 
	 * @param request
	 */
	public MyProgressListener(HttpServletRequest request) {
		session = request.getSession();
		ProcessStatusVo status = new ProcessStatusVo();
		session.setAttribute("status", status);
	}

	/**
	 * @param pBytesRead 已读字节数
	 * @param pContentLength 总字节数
	 * @param pItems 每几个文件(这个参数不标准,别使用)
	 */
	@Override
	public void update(long pBytesRead, long pContentLength, int pItems) {
		ProcessStatusVo status = new ProcessStatusVo();
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
