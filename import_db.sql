CREATE TABLE  users(
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE  questions(
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL,
  users_id INTEGER REFERENCES users(id)
);

CREATE TABLE  question_follows(
  users_id INTEGER REFERENCES users(id),
  questions_id INTEGER REFERENCES questions(id)
);

CREATE TABLE  replies(
  id INTEGER PRIMARY KEY,
  questions_id INTEGER REFERENCES questions(id),
  parent_id INTEGER REFERENCES replies(id),
  users_id INTEGER REFERENCES users(id),
  body VARCHAR(255) NOT NULL
);

CREATE TABLE  question_likes(
  questions_id INTEGER REFERENCES questions(id),
  users_id INTEGER REFERENCES users(id)
);
