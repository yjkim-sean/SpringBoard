package kr.co.dao;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import kr.co.vo.BoardVO;
import kr.co.vo.SearchCriteria;

@Repository
public class BoardDAOImpl implements BoardDAO {

	@Inject
	private SqlSession sqlSession;
	
	// 게시글 작성
	@Override
	public void write(BoardVO boardVO) throws Exception {
		sqlSession.insert("boardMapper.insert", boardVO);
	}
	
	//첨부파일 업로드
	@Override
	public void insertFile(Map<String, Object> map) throws Exception {
		sqlSession.insert("boardMapper.insertFile", map);
	}
	
	// 첨부파일 조회
	@Override
	public List<Map<String, Object>> selectFileList(int bno) throws Exception {
		return sqlSession.selectList("boardMapper.selectFileList", bno);
	}
	
	// 첨부파일 다운로드
	@Override
	public Map<String, Object> selectFileInfo(Map<String, Object> map) throws Exception {
		return sqlSession.selectOne("boardMapper.selectFileInfo", map);
	}
	
	@Override
	public void updateFile(Map<String, Object> map) throws Exception {
		sqlSession.update("boardMapper.updateFile", map);
	}
	
	//게시판 목록 조회
	@Override
	public List<BoardVO> list(SearchCriteria scri) throws Exception {
		return sqlSession.selectList("boardMapper.listPage", scri);
		//boardMapper.xml에서 mapper의 namespace가 boardMapper이고 그중에 id가 list/listPage인것을 가져와서 반환해라
	}

	@Override
	public int listCount(SearchCriteria scri) throws Exception {
		return sqlSession.selectOne("boardMapper.listCount", scri);
	}

	//게시물 조회
	@Override
	public BoardVO read(int bno) throws Exception {
		return sqlSession.selectOne("boardMapper.read", bno);
	}
	
	//게시물 수정
	@Override
	public void update(BoardVO boardVO) throws Exception {
		sqlSession.update("boardMapper.update", boardVO);
	}

	//게시물 삭제
	@Override
	public void delete(int bno) throws Exception {
		sqlSession.delete("boardMapper.delete", bno);
	}
	
	//게시판 조회수
	@Override
	public void boardHit(int bno) throws Exception {
		sqlSession.update("boardMapper.boardHit", bno);
	}


}
