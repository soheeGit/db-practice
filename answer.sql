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
-- 04. 별점(rating) 4점 이상인 리뷰(reviews)의 상품 이름(???)과 리뷰 내용(comment)을 조회하세요.
desc orders;
desc users;
desc products; # product_name
desc reviews; # rating!
SELECT * FROM reviews;
SELECT * FROM reviews WHERE rating >= 4;
SELECT count(*) FROM reviews; # 5
SELECT count(*) FROM products; # 5
SELECT count(*)
FROM reviews, products; # 5 x 5 = 25 -> 카테시안 곱
# 내추럴 조인
SELECT count(*)
FROM reviews, products
WHERE reviews.product_id = products.product_id;
# SELECT *
SELECT product_name, comment
FROM reviews, products
WHERE reviews.product_id = products.product_id
  AND rating >= 4; # 1.267s
SELECT product_name, comment
FROM reviews
         JOIN products
              ON reviews.product_id = products.product_id
WHERE rating >= 4; # 1.318s

SELECT product_name, comment
FROM reviews
         JOIN products
              ON reviews.product_id = products.product_id
                  AND rating >= 4; # 1.318s

SELECT product_name, comment
FROM reviews
         JOIN products
              using (product_id)
WHERE rating >= 4; # 1.2s # 미묘미묘~

SELECT product_name, comment
FROM (SELECT product_id, comment, rating
      FROM reviews) AS r
         JOIN (SELECT product_id, product_name
               FROM products) AS p
              using (product_id)
WHERE rating >= 4;

-- 05. 카테고리별 상품 수를 조회하세요.
SELECT * FROM products;
# SELECT * FROM products GROUP BY category;
# 그룹연산 (count, sum, avg, min, max...)
# 근데 영향을 안 받는게 있다~ GROUP BY에 언급되었다면 그냥 쓸 수 있다
SELECT category,
       count(*) AS '상품수',
       sum(stock) AS '전체수량'
FROM products
GROUP BY category;
# FWGHSO
# - G => ? GROUP BY에서 사용한 컬럼, (그룹연산이 필요한 묶음들)

-- 06. 가장 많이 팔린 상품의 이름과 판매 수량을 조회하세요.
SELECT * FROM orders;
# SELECT product_id, product_name, sum(quantity)
SELECT product_name AS '상품명',
       sum(quantity) AS '판매 수량'
FROM orders
         JOIN products
              USING (product_id)
GROUP BY product_id;
SELECT product_name AS '상품명',
       sum(quantity) AS '판매 수량'
FROM orders
         JOIN products
              USING (product_id)
GROUP BY product_id
ORDER BY `판매 수량` ASC;
# ASCENDING -> 오름차순 => 데이터가 전개되는 방향과 데이터가 증가하는 방향이 같게 정렬함
SELECT product_name AS '상품명',
       sum(quantity) AS '판매 수량'
FROM orders
         JOIN products
              USING (product_id)
GROUP BY product_id
ORDER BY `판매 수량` DESC
LIMIT 1; # DESC 테이블 vs ORDER BY 컬럼명 DESC
SELECT product_name AS '상품명',
       sum(quantity) AS '판매 수량'
FROM orders
         JOIN products
              USING (product_id)
GROUP BY product_id;
# ASCENDING -> 오름차순 => 데이터가 전개되는 방향과 데이터가 증가하는 방향이 같게 정렬함
SELECT product_name AS '상품명',
       sum(quantity) AS '판매 수량'
FROM orders
         JOIN products
              USING (product_id)
GROUP BY product_id
HAVING sum(quantity) = (
    SELECT max(sq) FROM
        (SELECT sum(quantity) AS sq
         FROM orders
         GROUP BY product_id) AS so);
SELECT `상품명`, `판매 수량` FROM
    (SELECT product_name AS '상품명',
            sum(quantity) AS '판매 수량'
     FROM orders
              JOIN products
                   USING (product_id)
     GROUP BY product_id) AS op
        JOIN
    (SELECT max(sq) AS m FROM
        (SELECT sum(quantity) AS sq
         FROM orders
         GROUP BY product_id) AS so) AS tmp
    ON op.`판매 수량` = tmp.m;
-- 07. 사용자별 총 주문 금액을 조회하세요.
SELECT username, sum(quantity * price) `총 주문 금액`
FROM users
         JOIN orders
              USING (user_id)
         JOIN products
              USING (product_id)
GROUP BY user_id;
-- 08. 평균 별점이 4점 이상인 상품의 이름과 평균 별점을 조회하세요.
-- 09. 상품별 리뷰 수를 조회하고, 리뷰 수가 2개 이상인 상품만 조회하세요.
-- 10. T-shirt를 구매한 사용자의 이름과 이메일을 조회하세요.

# 와일드카드, IS NULL, IFNULL, index, function, procedure, trigger(event)