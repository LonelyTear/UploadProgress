package upload.progress;

public class ProcessStatus {
	public long pContentLength = 1;
	public long pBytesRead = 0;
	public String show = "";
	public int pItems = 0;
	public int rate = 0;

	/**
	 * json格式,全""封闭
	 */
	@Override
	public String toString() {
		return "{\"pContentLength\":\"" + pContentLength + "\", \"pBytesRead\":\"" + pBytesRead + "\", \"show\":\"" + show + "\", \"pItems\":\"" + pItems + "\", \"rate\":\"" + rate + "\"}";
	}

}
