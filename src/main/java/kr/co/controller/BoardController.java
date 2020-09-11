package kr.co.controller;

import java.io.File;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.co.service.BoardService;
import kr.co.service.ReplyService;
import kr.co.vo.BoardVO;
import kr.co.vo.PageMaker;
import kr.co.vo.ReplyVO;
import kr.co.vo.SearchCriteria;

@Controller
public class BoardController {
	
	private static final Logger Logger = LoggerFactory.getLogger(BoardController.class);
	
	@Inject
	BoardService service;
	
	@Inject
	ReplyService replyService;
	
	//게시판 글 작성 화면
	@RequestMapping(value = "board/writeView", method = RequestMethod.GET)
	public void writeView() throws Exception{
		Logger.info("writeView");
	
	}
	
	//게시판 글 작성
	@RequestMapping(value = "board/write", method = RequestMethod.POST)
	public String write(BoardVO boardVO, MultipartHttpServletRequest mpRequest) throws Exception{
		//MultipartHttpServletRequest mpRequest : 첨부파일 파라미터 받아옴
		Logger.info("write");

		service.write(boardVO, mpRequest);
		
		return "redirect:/board/list"; 
	  //return "/board/list" 라고만 썼을 땐 동작하지 않음. 다른 페이지를 불러와야 할땐 redirect 써야함
	}
	
	// 게시물 조회
	//오라클 > DAO > 서비스 > 컨트롤러로 가져온 데이터들을 jsp에 뿌려주는 작업
	@RequestMapping(value = "board/list", method = RequestMethod.GET)
	public String list(Model model, @ModelAttribute("scri") SearchCriteria scri) throws Exception{
		Logger.info("list");
		
		model.addAttribute("list", service.list(scri));
		
		PageMaker pageMaker = new PageMaker();
		pageMaker.setCri(scri);
		pageMaker.setTotalCount(service.listCount(scri));
		
		model.addAttribute("pageMaker", pageMaker);
		
		return "board/list";
		
	}
	
	// 게시판 조회
	@RequestMapping(value = "board/readView", method = RequestMethod.GET)
	public String read(BoardVO boardVO, Model model, @ModelAttribute("scri") SearchCriteria scri) throws Exception{
		Logger.info("read");
		
		model.addAttribute("read", service.read(boardVO.getBno()));
		model.addAttribute("scri", scri);
		
		List<ReplyVO> replyList = replyService.readReply(boardVO.getBno());
		model.addAttribute("replyList", replyList);
		
		List<Map<String, Object>> fileList = service.selectFileList(boardVO.getBno());
		model.addAttribute("file", fileList);
		return "board/readView";
	}
	
	//첨부파일 다운로드
	@RequestMapping(value="board/fileDown")
	public void fileDown(@RequestParam Map<String, Object> map, HttpServletResponse response) throws Exception{
		//게시판 글 작성할 때 MultipartHttpServletRequest mpRequest을 이용하여 서버에 요청
		//request는 jsp화면에서 서버로 요청할 때 쓰고,
		//HttpServletResponse response는 서버에서 jsp화면으로 응답할때에 쓰입니다. 
		//그래서 파일정보들을 responses에 담아 처리를 합니다.
		
		Map<String, Object> resultMap = service.selectFileInfo(map);
		String storedFileName = (String) resultMap.get("STORED_FILE_NAME");
		String originalFileName = (String) resultMap.get("ORG_FILE_NAME");
		
		// 파일을 저장했던 위치에서 첨부파일을 읽어 byte[]형식으로 변환한다.
		byte fileByte[] = org.apache.commons.io.FileUtils.readFileToByteArray(new File("C:\\mp\\file\\"+storedFileName));
		
		response.setContentType("application/octet-stream");
		response.setContentLength(fileByte.length);
		response.setHeader("Content-Disposition",  "attachment; fileName=\""+URLEncoder.encode(originalFileName, "UTF-8")+"\";");
		response.getOutputStream().write(fileByte);
		response.getOutputStream().flush(); //데이터 비우기
		response.getOutputStream().close(); //닫기
		
	}

	// 게시판 수정뷰
	@RequestMapping(value = "board/updateView", method = RequestMethod.GET)
	public String updateView(BoardVO boardVO, @ModelAttribute("scri") SearchCriteria scri, Model model) throws Exception {
		Logger.info("updateView");

		model.addAttribute("update", service.read(boardVO.getBno()));
		model.addAttribute("scri", scri);
		
		List<Map<String, Object>> fileList = service.selectFileList(boardVO.getBno());
		model.addAttribute("file", fileList);

		return "board/updateView";
	}

	// 게시판 수정
	@RequestMapping(value = "board/update", method = RequestMethod.POST)
	public String update(BoardVO boardVO, 
						 @ModelAttribute("scri") SearchCriteria scri, 
						 RedirectAttributes rttr,
						 @RequestParam(value="fileNoDel[]") String[] files,
						 @RequestParam(value="fileNameDel[]") String[] fileNames,
						 MultipartHttpServletRequest mpRequest) throws Exception {
		//파라미터에 @RequestParam이 붙은 fileNoDel[]과 fileNameDel[]은 jsp에서 fileNoDel[]과 fileNameDel[]로 지정한 값을 String[] 타입으로 담겠다는 말입니다.
		//service.update 파라미터값이 전달되도록
		Logger.info("update");

		service.update(boardVO, files, fileNames, mpRequest);
		
		rttr.addAttribute("page", scri.getPage());
		rttr.addAttribute("perPageNum", scri.getPerPageNum());
		rttr.addAttribute("searchType", scri.getSearchType());
		rttr.addAttribute("keyword", scri.getKeyword());
		
		return "redirect:/board/list";
	}
	
	// 게시판 삭제
	@RequestMapping(value = "board/delete", method = RequestMethod.POST)
	public String delete(BoardVO boardVO, @ModelAttribute("scri") SearchCriteria scri, RedirectAttributes rttr) throws Exception {
		Logger.info("delete");

		service.delete(boardVO.getBno());

		rttr.addAttribute("page", scri.getPage());
		rttr.addAttribute("perPageNum", scri.getPerPageNum());
		rttr.addAttribute("searchType", scri.getSearchType());
		rttr.addAttribute("keyword", scri.getKeyword());
		
		return "redirect:/board/list";
	}
	
	//댓글 작성
	@RequestMapping(value="board/replyWrite", method = RequestMethod.POST)
	public String replyWrite(ReplyVO vo, SearchCriteria scri, RedirectAttributes rttr) throws Exception {
		//ReplyVO는 댓글 작성하기위한 데이터
		//SearchCriteria는 readView에 있던 page, perPageNum, searchType, keyword값을 받아오기 위한것
		//RedirectAttributes는 redirect했을때 값들을 물고 이동
		//그래서 SearchCriteria의 값을 넣어서 댓글을 저장 한 뒤 원래 페이지로 redirect하여 이동하게 됩니다.
		
		Logger.info("reply Write");
		
		replyService.writeReply(vo);
		
		rttr.addAttribute("bno", vo.getBno());
		rttr.addAttribute("page", scri.getPage());
		rttr.addAttribute("perPageNum", scri.getPerPageNum());
		rttr.addAttribute("searchType", scri.getSearchType());
		rttr.addAttribute("keyword", scri.getKeyword());
		
		return "redirect:/board/readView";
	}
	
	//댓글 수정 GET
	@RequestMapping(value="board/replyUpdateView", method = RequestMethod.GET)
	public String replyUpdateView(ReplyVO vo, SearchCriteria scri, Model model) throws Exception {
		Logger.info("reply UpdateView");
		
		model.addAttribute("replyUpdate", replyService.selectReply(vo.getRno()));
		model.addAttribute("scri", scri);
		
		return "board/replyUpdateView";
	}
	
	//댓글 수정 POST
	@RequestMapping(value="board/replyUpdate", method = RequestMethod.POST)
	public String replyUpdate(ReplyVO vo, SearchCriteria scri, RedirectAttributes rttr) throws Exception {
		Logger.info("reply replyUpdate");
		
		replyService.updateReply(vo);
		
		rttr.addAttribute("bno", vo.getBno());
		rttr.addAttribute("page", scri.getPage());
		rttr.addAttribute("perPageNum", scri.getPerPageNum());
		rttr.addAttribute("searchType", scri.getSearchType());
		rttr.addAttribute("keyword", scri.getKeyword());
		
		return "redirect:/board/readView";
	}
	
	
	//댓글 삭제 GET
	@RequestMapping(value="board/replyDeleteView", method = RequestMethod.GET)
	public String replyDeleteView(ReplyVO vo, SearchCriteria scri, Model model) throws Exception {
		Logger.info("reply Write");
		
		model.addAttribute("replyDelete", replyService.selectReply(vo.getRno()));
		model.addAttribute("scri", scri);
		

		return "board/replyDeleteView";
	}
	
	//댓글 삭제
	@RequestMapping(value="board/replyDelete", method = RequestMethod.POST)
	public String replyDelete(ReplyVO vo, SearchCriteria scri, RedirectAttributes rttr) throws Exception {
		Logger.info("reply Write");
		
		replyService.deleteReply(vo);
		
		rttr.addAttribute("bno", vo.getBno());
		rttr.addAttribute("page", scri.getPage());
		rttr.addAttribute("perPageNum", scri.getPerPageNum());
		rttr.addAttribute("searchType", scri.getSearchType());
		rttr.addAttribute("keyword", scri.getKeyword());
		
		return "redirect:/board/readView";
	}

}
