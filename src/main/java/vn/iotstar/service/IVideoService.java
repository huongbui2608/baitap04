package vn.iotstar.service;

import vn.iotstar.entity.Video;

import java.util.List;

public interface IVideoService {
    void insert(Video video);
    void update(Video video);
    void delete(String videoId);
    Video findById(String videoId);
    List<Video> findAll();
    List<Video> findAll(int page, int pageSize);
    int count();
    List<Video> findTop10Newest();
    List<Video> findByUserId(int userId, int page, int pageSize);
    int countByUserId(int userId);
    void increaseViews(String videoId);
}
