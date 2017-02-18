package com.db.tourist.models;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.util.Date;

@Entity
@Table(name = "static_page")
public class StaticPage extends BaseEntity {
    @Column(name = "title")
    private String title;

    @Column(name = "text", columnDefinition="LONGTEXT")
    private String text;

    @Column(name = "url")
    private String url;

    @Column(name = "create_date")
    private Date createDate;

    public StaticPage() {
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }
}
