package com.db.tourist.controllers;

import com.db.tourist.models.Region;
import com.db.tourist.services.RegionService;
import com.db.tourist.utils.View;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
public class RegionController {

    @Autowired
    private RegionService regionService;

    @RequestMapping(value = "/admin/region", method = RequestMethod.GET)
    public ModelAndView list() {
        View view = new View("region/list", true);
        view.addObject("title", "Области");
        view.addObject("regions", regionService.findAll());
        return view;
    }

    @ResponseBody
    @RequestMapping(value = "/admin/region/delete", method = RequestMethod.POST)
    public void delete(@RequestParam("id") Long id) {
        regionService.delete(id);
    }

    @RequestMapping(value = "/regions", method = RequestMethod.GET)
    public ModelAndView regions() {
        View view = new View("locality/regions");
        view.addObject("title", "Области");
        List<Region> regionList = regionService.findAllByOrderByNameAsc();
//        for (Region r: regionList) {
//            if (r.getDistricts().size() > 0) {
//                Collections.sort(r.getDistricts(), new Comparator<District>() {
//                    @Override
//                    public int compare(final District object1, final District object2) {
//                        return object1.getName().compareTo(object2.getName());
//                    }
//                });
//            }
//        }
        view.addObject("regions", regionList);
        return view;
    }

    @RequestMapping(value = "/admin/region/add", method = RequestMethod.GET)
    public ModelAndView add() {
        View view = new View("region/edit", true);
        view.addObject("title", "Создание области");
        view.addObject("region", new Region());
        return view;
    }

    @RequestMapping(value = "/admin/region/add", method = RequestMethod.POST)
    public String add(@ModelAttribute("region") Region region, RedirectAttributes redirectAttributes) {
        Region r = regionService.save(region);
        if(r != null) {
            redirectAttributes.addFlashAttribute("success", "Область "+r.getName()+" успешно создана");
        }
        return "redirect:/admin/region";
    }

    @RequestMapping(value = "/admin/region/edit/{id}", method = RequestMethod.GET)
    public ModelAndView edit(@PathVariable("id") Long id) {
        View view = new View("region/edit", true);
        view.addObject("title", "Редактирование области");
        view.addObject("region", regionService.findOne(id));
        return view;
    }

    @RequestMapping(value = "/admin/region/edit/{id}", method = RequestMethod.POST)
    public String edit(Region region, RedirectAttributes redirectAttributes) {
        if(regionService.save(region) != null) {
            redirectAttributes.addFlashAttribute("success", "Область успешно отредактирована");
        }
        return "redirect:/admin/region";
    }
}
