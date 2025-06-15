package com.example.backend.databases.seeders;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.example.backend.modules.users.entities.User;
import com.example.backend.modules.users.repositories.UserRepository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

@Component
public class UserDatabaseSeeder implements CommandLineRunner {
    private static final Logger logger = LoggerFactory.getLogger(UserDatabaseSeeder.class);

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private UserRepository userRepository;

    @Transactional
    @Override
    public void run (String ...args) throws Exception {
        logger.info("Seeding database...");

        if (isTableEmpty()) {
            String passwordEncode = passwordEncoder.encode("12345");

            User user = new User();
            user.setFirstName("Hân");
            user.setMiddleName("Ngọc");
            user.setLastName("Hồ");
            user.setEmail("hhan30579@gmail.com");
            user.setPhone("0329556805");
            user.setPassword(passwordEncode);
            user.setImg(null);

            userRepository.save(user);
        }
    }

    private boolean isTableEmpty() {
        Long count = (Long) entityManager.createQuery("SELECT COUNT(id) FROM User").getSingleResult();
        return count == 0;
    }
}