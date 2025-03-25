-- 사용자 테이블 생성
CREATE TABLE users (
                       user_id INT PRIMARY KEY AUTO_INCREMENT,
                       username VARCHAR(255) UNIQUE NOT NULL,
                       email VARCHAR(255) UNIQUE NOT NULL,
                       age INT,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

# ALTER  TABLE  users RENAME column username TO nickname;
#
# INSERT INTO users (username, email, age) VALUES
#                                              ('JohnDoe', 'john@example.com', 30),
#                                              ('JaneSmith', 'jane@example.com', 25),
#                                              ('DavidLee', 'david@example.com', 40),
#                                              ('SarahKim', 'sarah@example.com', 28);


-- 상품 테이블 생성
CREATE TABLE products (
                          product_id INT PRIMARY KEY AUTO_INCREMENT,
                          product_name VARCHAR(255) NOT NULL,
                          price DECIMAL(10, 2) NOT NULL,
                          category VARCHAR(255),
                          stock INT DEFAULT 0
);

-- 주문 테이블 생성
CREATE TABLE orders (
                        order_id INT PRIMARY KEY AUTO_INCREMENT,
                        user_id INT,
                        product_id INT,
                        quantity INT,
                        order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        FOREIGN KEY (user_id) REFERENCES users(user_id),
                        FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 리뷰 테이블 생성
CREATE TABLE reviews (
                         review_id INT PRIMARY KEY AUTO_INCREMENT,
                         user_id INT,
                         product_id INT,
                         rating INT,
                         comment TEXT,
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         FOREIGN KEY (user_id) REFERENCES users(user_id),
                         FOREIGN KEY (product_id) REFERENCES products(product_id)
);

SELECT * FROM users;
