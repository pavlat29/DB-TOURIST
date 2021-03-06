package com.db.tourist.services;

import com.db.tourist.models.District;

import java.util.List;

public interface DistrictService {
    List<District> findAll();

    void delete(Long id);

    District findOne(Long id);

    District save(District district);

    List<District> findByRegionId(Long id);

    List<District> findAllByOrderByNameAsc();
}
