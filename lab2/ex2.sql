CREATE TABLE movie (
  id  SERIAL PRIMARY KEY,
  title VARCHAR NOT NULL,
  length  HOUR_SECOND NOT NULL,
  year_of_release YEAR NOT NULL,
  plot_outline TEXT NOT NULL,
  production_company_id INTEGER REFERENCES production_company(id)
);

CREATE TABLE genre (
  id  SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL
);

CREATE TABLE movie_genre (
  movie_id  INTEGER REFERENCES movie(id),
  genre_id  INTEGER REFERENCES genre(id)
);

CREATE TABLE production_company (
  id  SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  address TEXT NOT NULL
);

CREATE TABLE director (
  id  SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  date_of_birth DATE NOT NULL
);

CREATE TABLE actor (
  id  SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  date_of_birth DATE NOT NULL
);

CREATE TABLE quote (
  id  SERIAL PRIMARY KEY,
  qtext TEXT NOT NULL,
  movie_id  INTEGER REFERENCES movie(id),
  actor_id  INTEGER REFERENCES actor(id)
);

CREATE TABLE movie_actor (
  movie_id  INTEGER REFERENCES movie(id),
  actor_id  INTEGER REFERENCES actor(id),
  role TEXT NOT NULL
);

CREATE TABLE movie_director (
  movie_id  INTEGER REFERENCES movie(id),
  director_id INTEGER REFERENCES director(id)
);
