CREATE TABLE IF NOT EXISTS quotes (
    id SERIAL PRIMARY KEY,
    text TEXT NOT NULL
);

INSERT INTO quotes (text) VALUES
('Know thyself.'),
('The unexamined life is not worth living.'),
('We are what we repeatedly do. Excellence, then, is not an act, but a habit.'),
('To thine own self be true.'),
('There is no greater wealth than wisdom.'),
('The mind is everything. What you think you become.'),
('Your visions will become clear only when you can look into your own heart.'),
('He who conquers himself is the mightiest warrior.'),
('Happiness depends upon ourselves.'),
('The greatest discovery of my generation is that a human being can alter his life by altering his attitudes.');
