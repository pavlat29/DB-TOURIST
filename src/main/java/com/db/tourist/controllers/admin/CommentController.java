package com.db.tourist.controllers.admin;

import com.db.tourist.models.Comment;
import com.db.tourist.services.CommentService;
import com.db.tourist.utils.View;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class CommentController {
    @Autowired
    private CommentService commentService;

    @RequestMapping(value = "/admin/comment", method = RequestMethod.GET)
    public ModelAndView list() {
        View view = new View("comment/list", true);
        view.addObject("title", "Отзывы");
        view.addObject("notChecked", commentService.findNotChecked());
        view.addObject("checked", commentService.findChecked());
        return view;
    }

    @ResponseBody
    @RequestMapping(value = "/admin/comment/show", method = RequestMethod.GET)
    public String show(@RequestParam("id") Long id) {
        Comment comment = commentService.findOne(id);
        return comment != null ? comment.getText() : "";
    }

    @ResponseBody
    @RequestMapping(value = "/admin/comment/delete", method = RequestMethod.POST)
    public void delete(@RequestParam("id") Long id) {
        commentService.delete(id);
    }

    @RequestMapping(value = "/admin/comment/check", method = RequestMethod.POST)
    public String add(@RequestParam("id") Long id, RedirectAttributes redirectAttributes) {
        if(commentService.check(id)) {
            redirectAttributes.addFlashAttribute("success", "Отзыв одобрен");
        }
        return "redirect:/admin/comment";
    }
}