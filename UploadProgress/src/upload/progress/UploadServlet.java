package upload.progress;

import java.io.File;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FilenameUtils;

/**
 * 文件上传主入口Servlet
 * commons-fileupload同时上传多个文件,缺点是只能显示一个总的进度条
 * @author King
 *
 */
public class UploadServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doPost(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Check that we have a file upload request
		boolean isMultipart = ServletFileUpload.isMultipartContent(request);
		if (isMultipart) {
			// Create a factory for disk-based file items
			// DiskFileItemFactory应当属于重量级对象,个人不建议每次servlet调用都new一份,最好在静态static中声明
			DiskFileItemFactory factory = new DiskFileItemFactory();

			// Set factory constraints
			factory.setSizeThreshold(1024 * 1024 * 10);// 超过10M的数据采用临时文件缓存
			// Configure a repository (to ensure a secure temp location is used)
			factory.setRepository(new File("D:/temp/tempDir"));// 临时目录不设置的话取默认路径

			// Create a new file upload handler
			ServletFileUpload upload = new ServletFileUpload(factory);

			upload.setHeaderEncoding("UTF-8"); // 设置字符编码
			// Set overall request size constraint
			upload.setSizeMax(1024 * 1024 * 300);// 单个文件超过300M抛FileUploadException异常

			MyProgressListener getBarListener = new MyProgressListener(request);
			upload.setProgressListener(getBarListener);

			try {
				// Parse the request
				List<FileItem> items = upload.parseRequest(request);

				// Process the uploaded items
				Iterator<FileItem> iter = items.iterator();
				while (iter.hasNext()) {
					FileItem item = iter.next();
					if (item.isFormField()) {
						String name = item.getFieldName();
						String value = item.getString();
						System.out.println(name + ":" + value);
					} else {
						// OutputStream outStream = item.getOutputStream();
						// InputStream inputSteram = item.getInputStream();
						if(!"".equals(item.getName())){
							String extensionName = FilenameUtils.getExtension(item.getName());//取扩展名,本处不使用
							File uploadedFile = new File("D:/temp/destDir/" + item.getName());
							item.write(uploadedFile);
						}
					}
					item.delete();
				}
			} catch (Exception e) {
				e.printStackTrace();
				response.getWriter().write(e.getMessage());
			}
		} else {
			response.getWriter().write("is not Multipart !");
		}

	}

}
