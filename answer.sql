-- 01. 30세 이상 사용자의 이름과 이메일을 조회하세요.
SELECT * FROM users; # *을 찍어라
SELECT username, email FROM users; # 원하는 열 이름으로 좁히기
# SELECT username, email, age
SELECT username, email # 3. 그래서 여기 가서야... username, email "선택"
FROM users # 1. FROM으로 테이블을 불러옵니다 (실제 테이블일 수도 있고 논리적으로 존재...)
WHERE age >= 30 ; # 2. 조건이 되는 열을 입력하고 해당 조건을 작성 - 아직 모든 열이 있음
-- 02. 평균 상품 가격보다 비싼 상품의 이름과 가격을 조회하세요.
SELECT * FROM products;
SELECT avg(price) FROM products;
# SELECT * FROM products where price > avg(price); # 그룹연산이 뭐야(???)
SELECT *
FROM products # 1
WHERE price > (SELECT avg(price) FROM products); # 2
# 서브 쿼리 -> 쿼리문을 내부에 실행시켜서 마치 '값'처럼 만든 것.
SELECT product_name, price
FROM products
WHERE price > (SELECT avg(price) FROM products);
-- 03. JohnDoe 사용자가 '주문'(order)한 상품(product)의 이름과 수량을 조회하세요.
SELECT * FROM users; # PK = Primary Key 기본키
SELECT * FROM users WHERE username = 'JohnDoe';
# SELECT user_id FROM users WHERE username = 'JohnDoe';
SELECT * FROM users u # u -> 테이블은 스스로와도 합칠 수 있어서 임시 이름이 필요 alias
                  JOIN orders o
                       ON # WHERE이랑 거의 똑같은 역할
                           u.user_id = o.user_id; # 컬럼 이름이 달라도 합칠 수 있음.
SELECT * FROM users u
                  JOIN orders o
                       USING (user_id) # 일치.
# FROM ~ JOIN ~ USING 또는 ON
WHERE username = 'JohnDoe';
# SELECT product_name, quantity
SELECT *
FROM users u # 1-1
         JOIN orders o # 1-2
              ON username = 'JohnDoe' # WHERE은 #2로 실행...
              # AI에게 이게 무슨 차이인지, WHERE도 해도 되지 않아? 무슨 목적이야?
                  AND u.user_id = o.user_id # ~ 1-2.
         JOIN products p # 1-3
              ON o.product_id = p.product_id;
# 여기까지만...
-- 04. 별점 4점 이상인 리뷰의 상품 이름과 리뷰 내용을 조회하세요.
-- 05. 카테고리별 상품 수를 조회하세요.
-- 06. 가장 많이 팔린 상품의 이름과 판매 수량을 조회하세요.
-- 07. 사용자별 총 주문 금액을 조회하세요.
-- 08. 평균 별점이 4점 이상인 상품의 이름과 평균 별점을 조회하세요.
-- 09. 상품별 리뷰 수를 조회하고, 리뷰 수가 2개 이상인 상품만 조회하세요.
-- 10. T-shirt를 구매한 사용자의 이름과 이메일을 조회하세요.

# 와일드카드, IS NULL, IFNULL, index, function, procedure, trigger(event)