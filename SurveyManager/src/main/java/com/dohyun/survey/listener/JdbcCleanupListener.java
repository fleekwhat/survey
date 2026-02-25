package com.dohyun.survey.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;

public class JdbcCleanupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // 할 거 없음
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // 1) MySQL AbandonedConnectionCleanupThread 종료 (구버전 드라이버 기준)
        try {
            com.mysql.jdbc.AbandonedConnectionCleanupThread.shutdown();
        } catch (Throwable t) {
            // 드라이버 버전/환경에 따라 클래스나 메서드가 없을 수 있음 -> 무시
        }

        // 2) DriverManager에 등록된 드라이버 해제 (클래스로더 누수/재배포 이슈 방지)
        ClassLoader cl = Thread.currentThread().getContextClassLoader();
        Enumeration<Driver> drivers = DriverManager.getDrivers();

        while (drivers.hasMoreElements()) {
            Driver d = drivers.nextElement();
            if (d.getClass().getClassLoader() == cl) {
                try {
                    DriverManager.deregisterDriver(d);
                } catch (SQLException ignore) {}
            }
        }
    }
}