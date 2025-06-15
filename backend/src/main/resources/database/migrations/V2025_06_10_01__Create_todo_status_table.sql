CREATE TABLE todo_status (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE -- Ví dụ: "Chưa hoàn thành", "Đã hoàn thành"
);