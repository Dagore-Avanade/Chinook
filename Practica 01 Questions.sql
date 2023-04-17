---------------------------------------------------------------------------------------------------------
-- ejercicios iniciales 1
---------------------------------------------------------------------------------------------------------


USE Chinook
GO

-- Obtener el nombre, apellidos, ciudad y país de cada cliente.
SELECT
	[FirstName],
	[LastName],
	[City],
	[Country]
FROM Customer;

-- Obtener todos los artistas cuyo nombre comiencen por "G" (No case sensitive).
SELECT
	[Name]
FROM Artist
WHERE Name LIKE 'G%';

-- Obtener todos los artistas que contengan "GU" en su nombre (no case sensitive).
SELECT
	[Name]
FROM Artist
WHERE Name LIKE '%GU%';

-- Obtener todos los artistas y sus correspondientes álbumes (tengan o no tengan).
SELECT
	[Name],
	[Title]
FROM Artist
LEFT JOIN Album
	ON Artist.ArtistId = Album.ArtistId;

-- Obtener todos los artistas que no tengan álbumes.
SELECT
	[Name]
FROM Artist
LEFT JOIN Album
	ON Artist.ArtistId = Album.ArtistId
WHERE Album.AlbumId IS NULL;

-- Obtener todos los artistas con el número total de álbumes que tiene (tengan o no).
SELECT
	[Name],
	COUNT([Title]) "Number of albums"
FROM Artist
LEFT JOIN Album
	ON Artist.ArtistId = Album.ArtistId
GROUP BY [Name];

-- Obtener todos los artistas que tengan 3 o más álbumes 
SELECT
	[Name],
	COUNT([Title]) "Number of albums"
FROM Artist
LEFT JOIN Album
	ON Artist.ArtistId = Album.ArtistId
GROUP BY [Name]
HAVING COUNT([Title]) > 2;

-- Obtener todos los artistas con el número total de álbumes que tiene (que tengan).
SELECT
	[Name],
	COUNT([Title]) "Number of albums"
FROM Artist
JOIN Album
	ON Artist.ArtistId = Album.ArtistId
GROUP BY [Name];

-- Obtener todos los artistas con más de 3 álbumes y ordenados por el número de álbumes de menor a mayor.
SELECT
	[Name],
	COUNT([Title]) "Number of albums"
FROM Artist
JOIN Album
	ON Artist.ArtistId = Album.ArtistId
GROUP BY [Name]
HAVING COUNT([Title]) > 3
ORDER BY COUNT([Title]);

-- Obtener todos los medios digitales existentes con el número de canciones existentes por cada uno de ellos.
SELECT
	MediaType.Name [Name],
	COUNT(Track.TrackId) "Count"
FROM MediaType
LEFT JOIN Track
	ON MediaType.MediaTypeId = Track.MediaTypeId
GROUP BY MediaType.Name;

-- Obtener todas las canciones de género Rock.
SELECT
	Track.Name [Name]
FROM Track
JOIN Genre
	ON Track.GenreId = Genre.GenreId
WHERE Genre.Name LIKE 'Rock';
