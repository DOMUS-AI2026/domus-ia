-- DOMUS AI — schema MySQL (dados estruturais e estado atual)
-- Leituras de série temporal ficam no MongoDB (ver README).

CREATE DATABASE IF NOT EXISTS domus_ai CHARACTER SET utf8mb4;
USE domus_ai;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(160) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE homes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  name VARCHAR(120) NOT NULL DEFAULT 'Minha Casa',
  address VARCHAR(255),
  area_m2 DECIMAL(6,2) NOT NULL,
  width_m DECIMAL(5,2) NOT NULL,
  depth_m DECIMAL(5,2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE rooms (
  id INT AUTO_INCREMENT PRIMARY KEY,
  home_id INT NOT NULL,
  slug VARCHAR(40) NOT NULL,        -- ex: 'banheiro', 'quarto1'
  name VARCHAR(80) NOT NULL,
  area_m2 DECIMAL(6,2) NOT NULL,
  pos_x DECIMAL(6,2) NOT NULL,      -- metros, canto inferior esquerdo
  pos_z DECIMAL(6,2) NOT NULL,
  width_m DECIMAL(6,2) NOT NULL,
  depth_m DECIMAL(6,2) NOT NULL,
  FOREIGN KEY (home_id) REFERENCES homes(id) ON DELETE CASCADE,
  UNIQUE KEY uq_room_slug (home_id, slug)
);

CREATE TABLE devices (
  id INT AUTO_INCREMENT PRIMARY KEY,
  room_id INT NOT NULL,
  key_name VARCHAR(40) NOT NULL,    -- 'luz','valvula','maquina','porta','janela'
  label VARCHAR(80) NOT NULL,
  state VARCHAR(40) NOT NULL,       -- valor atual, ex: 'Ligada'/'Desligada'
  on_value VARCHAR(40) NOT NULL,
  off_value VARCHAR(40) NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE
);

CREATE TABLE sensors (
  id INT AUTO_INCREMENT PRIMARY KEY,
  room_id INT NOT NULL,
  key_name VARCHAR(40) NOT NULL,    -- 'temp','presenca','agua','energia','vazamento'...
  label VARCHAR(80) NOT NULL,
  unit VARCHAR(20),                 -- '°C','L/dia','kWh'...
  last_value VARCHAR(40) NOT NULL,
  last_status ENUM('normal','atencao','critico','equipamento') NOT NULL DEFAULT 'normal',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE
);

CREATE TABLE room_status (
  id INT AUTO_INCREMENT PRIMARY KEY,
  room_id INT NOT NULL UNIQUE,
  status ENUM('normal','atencao','critico','equipamento') NOT NULL DEFAULT 'normal',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE
);

CREATE TABLE automations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  home_id INT NOT NULL,
  rule_key VARCHAR(40) NOT NULL,    -- 'valve','light','clima'
  label VARCHAR(160) NOT NULL,
  enabled BOOLEAN NOT NULL DEFAULT TRUE,
  FOREIGN KEY (home_id) REFERENCES homes(id) ON DELETE CASCADE,
  UNIQUE KEY uq_rule (home_id, rule_key)
);

CREATE TABLE alerts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  home_id INT NOT NULL,
  room_id INT NOT NULL,
  status ENUM('atencao','critico') NOT NULL,
  message VARCHAR(255) NOT NULL,
  resolved_by ENUM('manual','automation') NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  resolved_at TIMESTAMP NULL,
  FOREIGN KEY (home_id) REFERENCES homes(id) ON DELETE CASCADE,
  FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE
);

CREATE TABLE commands (
  id INT AUTO_INCREMENT PRIMARY KEY,
  device_id INT NOT NULL,
  action VARCHAR(40) NOT NULL,      -- 'Ligar','Desligar','Fechar válvula'...
  issued_by ENUM('user','automation') NOT NULL,
  issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  result VARCHAR(40) NOT NULL DEFAULT 'ok',
  FOREIGN KEY (device_id) REFERENCES devices(id) ON DELETE CASCADE
);

CREATE TABLE domus_score (
  id INT AUTO_INCREMENT PRIMARY KEY,
  home_id INT NOT NULL,
  overall INT NOT NULL,
  energia INT NOT NULL,
  agua INT NOT NULL,
  eficiencia INT NOT NULL,
  seguranca INT NOT NULL,
  sustentabilidade INT NOT NULL,
  comportamento INT NOT NULL,
  computed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (home_id) REFERENCES homes(id) ON DELETE CASCADE
);
