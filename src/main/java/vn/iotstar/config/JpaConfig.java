package vn.iotstar.config;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JpaConfig {
    private static EntityManagerFactory factory;

    public static synchronized EntityManagerFactory getEntityManagerFactory() {
        if (factory == null || !factory.isOpen()) {
            try {
                factory = Persistence.createEntityManagerFactory("jpa-hibernate-mysql");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return factory;
    }

    public static EntityManager getEntityManager() {
        EntityManagerFactory emf = getEntityManagerFactory();
        if (emf == null) {
            throw new IllegalStateException("Không thể khởi tạo EntityManagerFactory! Vui lòng kiểm tra kết nối CSDL.");
        }
        return emf.createEntityManager();
    }

    public static void shutdown() {
        if (factory != null && factory.isOpen()) {
            factory.close();
        }
    }
}
