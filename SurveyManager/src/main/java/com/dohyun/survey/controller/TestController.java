package com.dohyun.survey.controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class TestController {

    @Autowired
    private DataSource dataSource;

    @RequestMapping("/dbtest.do")
    @ResponseBody
    public String dbtest() {
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT 1");
             ResultSet rs = ps.executeQuery()) {

            rs.next();
            return "OK / url=" + conn.getMetaData().getURL() + " / select=" + rs.getInt(1);

        } catch (Exception e) {
            return "FAIL / " + e.getClass().getName() + " / " + e.getMessage();
        }
    }
}