package com.db.tourist.controllers.admin;

import com.db.tourist.models.District;
import com.db.tourist.models.Region;
import com.db.tourist.services.DistrictService;
import com.db.tourist.services.RegionService;
import com.db.tourist.utils.View;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Controller
public class DistrictController {

    @Autowired
    private DistrictService districtService;

    @Autowired
    private RegionService regionService;

    @ModelAttribute("regionList")
    public Map populateRegions()
    {
        List<Region> regionList = regionService.findAll();
        Map<String, String> map = new LinkedHashMap<String, String>();
        for(Region r : regionList) {
            map.put(Objects.toString(r.getId()), r.getName());
        }
        return map;
    }

    @RequestMapping(value = "/admin/district", method = RequestMethod.GET)
    public ModelAndView list() {
        View view = new View("district/list", true);
        view.addObject("title", "Районы");
        view.addObject("districts", districtService.findAll());
        return view;
    }

    @ResponseBody
    @RequestMapping(value = "/admin/district/delete", method = RequestMethod.POST)
    public void delete(@RequestParam("id") Long id) {
        districtService.delete(id);
    }

    @RequestMapping(value = "/admin/district/add", method = RequestMethod.GET)
    public ModelAndView add() {
        View view = new View("district/edit", true);
        view.addObject("title", "Создание района");
        view.addObject("district", new District());
        return view;
    }

    @RequestMapping(value = "/admin/district/add", method = RequestMethod.POST)
    public String add(@ModelAttribute("district") District district, RedirectAttributes redirectAttributes) {
        District d = districtService.save(district);
        if(d != null) {
            redirectAttributes.addFlashAttribute("success", "Район "+d.getName()+" успешно создан");
        }
        return "redirect:/admin/district";
    }

    @RequestMapping(value = "/admin/district/edit/{id}", method = RequestMethod.GET)
    public ModelAndView edit(@PathVariable("id") Long id) {
        View view = new View("district/edit", true);
        view.addObject("title", "Редактирование района");
        view.addObject("district", districtService.findOne(id));
        return view;
    }

    @RequestMapping(value = "/admin/district/edit/{id}", method = RequestMethod.POST)
    public String edit(District district, RedirectAttributes redirectAttributes) {
        if(districtService.save(district) != null) {
            redirectAttributes.addFlashAttribute("success", "Район успешно отредактирован");
        }
        return "redirect:/admin/district";
    }
}
